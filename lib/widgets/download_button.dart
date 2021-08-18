import 'dart:io';

import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import '../utils/utils.dart';

class DownloadButton extends HookConsumerWidget {
  const DownloadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var downloading = ref.watch(isDownloadingProvider);
    List<QueryApp> listDownloads = ref.watch(downloadListProvider);
    return Hero(
      tag: 'download_menu',
      child: Visibility(
        visible: listDownloads.isNotEmpty,
        child: Material(
          type: MaterialType.transparency,
          child: GtkPopupMenu(
            popupWidth: 400,
            icon: downloading > 0
                ? AdwaitaIcons.folder_download
                : AdwaitaIcons.emblem_default,
            body: Consumer(
              builder: (ctx, ref, child) {
                List<QueryApp> listDownloads = ref.watch(downloadListProvider);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(listDownloads.length, (index) {
                    var i = listDownloads[index];
                    removeItem() async {
                      if (!i.cancelToken.isCancelled) {
                        File(i.downloadLocation + i.name).deleteSync();
                      }
                      if (listDownloads.length == 1) context.back();
                      await Future.delayed(const Duration(milliseconds: 200));
                      listDownloads.removeAt(index);
                      ref.watch(downloadListProvider.notifier).refresh();
                    }

                    return PopupMenuItem<String>(
                      child: Tooltip(
                        message: i.name,
                        child: ListTile(
                          title: Text(
                            i.name,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyText1,
                          ),
                          subtitle: Text(
                            i.cancelToken.isCancelled
                                ? "Cancelled"
                                : i.actualBytes == 0
                                    ? 'Starting Download'
                                    : i.actualBytes == i.totalBytes
                                        ? "Download finished"
                                        : "${i.actualBytes.getFileSize()}/${i.totalBytes.getFileSize()}",
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              if (i.cancelToken.isCancelled ||
                                  (i.actualBytes == i.totalBytes &&
                                      i.actualBytes != 0)) {
                                removeItem();
                              } else if (i.actualBytes != i.totalBytes ||
                                  i.actualBytes == 0) {
                                i.cancelToken.cancel("cancelled");
                                ref
                                    .watch(downloadListProvider.notifier)
                                    .refresh();
                              }
                            },
                            icon: AdwaitaIcon(i.cancelToken.isCancelled
                                ? AdwaitaIcons.list_remove
                                : (i.actualBytes != i.totalBytes ||
                                        i.actualBytes == 0)
                                    ? AdwaitaIcons.edit_delete
                                    : AdwaitaIcons.user_trash),
                          ),
                          onTap: (i.actualBytes == i.totalBytes &&
                                  i.totalBytes != 0)
                              ? () async {
                                  var location = "/" +
                                      (await getApplicationDocumentsDirectory())
                                          .toString()
                                          .split('/')
                                          .toList()
                                          .sublist(1, 3)
                                          .join("/") +
                                      "/Applications/";

                                  var shell = Shell().cd(location);
                                  shell.run('./' + i.name);
                                }
                              : () {},
                        ),
                      ),
                      value: i.name,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

downloadApp(Map<String, String> checkmap, ref, url) async {
  var listDownloads = ref.watch(downloadListProvider);
  var location = "/" +
      (await getApplicationDocumentsDirectory())
          .toString()
          .split('/')
          .toList()
          .sublist(1, 3)
          .join("/") +
      "/Applications/";
  if (!Directory(location).existsSync()) {
    Directory(location).createSync();
  }
  if (checkmap.isNotEmpty) {
    var fileurl = checkmap.keys.toList()[0];
    String filename = checkmap.values.toList()[0];
    ref.watch(isDownloadingProvider.notifier).increment();
    CancelToken cancelToken = CancelToken();
    listDownloads.insert(
      0,
      QueryApp(
          name: filename,
          url: url,
          cancelToken: cancelToken,
          downloadLocation: location,
          actualBytes: 0,
          totalBytes: 0),
    );
    ref.watch(downloadListProvider.notifier).refresh();
    await Dio().download(fileurl, location + filename,
        onReceiveProgress: (recieved, total) {
      var item = listDownloads[
          listDownloads.indexWhere((element) => element.name == filename)];
      item.actualBytes = recieved;
      item.totalBytes = total;
      ref.watch(downloadListProvider.notifier).refresh();
    }, cancelToken: cancelToken).whenComplete(() {
      ref.watch(isDownloadingProvider.notifier).decrement();

      var shell = Shell().cd(location);
      shell.run('chmod +x ' + filename);
    });
  }
}
