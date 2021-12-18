import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/translations.dart';
import 'package:appimagepool/providers/providers.dart';

class DownloadButton extends HookConsumerWidget {
  const DownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    int downloading = ref.watch(downloadProvider).downloadCount;
    List<QueryApp> listDownloads = ref.watch(downloadProvider).downloadList;
    return Hero(
      tag: 'download_menu',
      child: Visibility(
        visible: listDownloads.isNotEmpty,
        child: Material(
          type: MaterialType.transparency,
          child: AdwPopupMenu(
            popupWidth: 400,
            icon: Icon(
              downloading > 0 ? LucideIcons.download : LucideIcons.check,
              size: 17,
            ),
            body: Consumer(
              builder: (ctx, ref, child) {
                List<QueryApp> listDownloads =
                    ref.watch(downloadProvider).downloadList;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(listDownloads.length, (index) {
                    var i = listDownloads[index];
                    void removeItem() async {
                      if (!i.cancelToken.isCancelled) {
                        File(i.downloadLocation + i.name).deleteSync();
                      }
                      if (listDownloads.length == 1) context.back();
                      await Future.delayed(const Duration(milliseconds: 155));
                      listDownloads.removeAt(index);
                      ref.watch(downloadProvider).refresh();
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
                                ? AppLocalizations.of(context)!.cancelled
                                : i.totalBytes == 0
                                    ? AppLocalizations.of(context)!
                                        .startingDownload
                                    : i.actualBytes == i.totalBytes
                                        ? AppLocalizations.of(context)!
                                            .downloadCompleted
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
                                ref.watch(downloadProvider).refresh();
                              }
                            },
                            icon: Icon(i.cancelToken.isCancelled
                                ? LucideIcons.xCircle
                                : (i.actualBytes != i.totalBytes ||
                                        i.actualBytes == 0)
                                    ? LucideIcons.x
                                    : LucideIcons.trash),
                          ),
                          onTap: (i.actualBytes == i.totalBytes &&
                                  i.totalBytes != 0)
                              ? () => runProgram(
                                    location: ref.watch(downloadPathProvider),
                                    program: i.name,
                                  )
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

downloadApp(BuildContext context, Map<String, String> checkmap, WidgetRef ref) {
  for (var item in checkmap.entries) {
    ref
        .watch(downloadProvider)
        .addDownload(context: context, url: item.key, name: item.value);
  }
}
