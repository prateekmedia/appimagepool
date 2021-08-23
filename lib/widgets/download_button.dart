import 'dart:io';

import 'package:gtk/gtk.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';
import '../models/models.dart';
import '../providers/providers.dart';

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
            icon: AdwaitaIcon(
              downloading > 0
                  ? AdwaitaIcons.folder_download
                  : AdwaitaIcons.emblem_default,
              size: 17,
            ),
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
                      await Future.delayed(const Duration(milliseconds: 155));
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
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
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
                              ? () {
                                  var location =
                                      ref.watch(downloadPathProvider);

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

downloadApp(Map<String, String> checkmap, WidgetRef ref) async {
  if (checkmap.isNotEmpty) {
    var fileUrl = checkmap.keys.toList()[0];
    String fileName = checkmap.values.toList()[0];
    ref
        .watch(downloadListProvider.notifier)
        .addDownload(url: fileUrl, name: fileName);
  }
}
