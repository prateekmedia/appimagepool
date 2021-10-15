import 'dart:io';

import 'package:gtk/gtk.dart';
import 'package:flutter/material.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/providers/providers.dart';

class DownloadsView extends HookConsumerWidget {
  final ValueNotifier<String> searchedTerm;

  const DownloadsView({Key? key, required this.searchedTerm}) : super(key: key);

  @override
  Widget build(context, ref) {
    final listDownloads = ref
        .watch(downloadListProvider)
        .where((element) =>
            element.name.toLowerCase().contains(searchedTerm.value))
        .toList();
    return listDownloads.isNotEmpty
        ? SingleChildScrollView(
            child: Center(
                child: GtkContainer(
                    child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              final i = listDownloads[index];

              void removeItem() async {
                if (!i.cancelToken.isCancelled) {
                  File(i.downloadLocation + i.name).deleteSync();
                }
                listDownloads.removeAt(index);
                ref.watch(downloadListProvider.notifier).refresh();
              }

              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i.name,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyText1,
                    ),
                    const SizedBox(height: 3),
                    LinearProgressIndicator(
                      value:
                          i.totalBytes != 0 ? i.actualBytes / i.totalBytes : 0,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 3),
                  ],
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
                        (i.actualBytes == i.totalBytes && i.actualBytes != 0)) {
                      removeItem();
                    } else if (i.actualBytes != i.totalBytes ||
                        i.actualBytes == 0) {
                      i.cancelToken.cancel("cancelled");
                      ref.watch(downloadListProvider.notifier).refresh();
                    }
                  },
                  icon: AdwaitaIcon(i.cancelToken.isCancelled
                      ? AdwaitaIcons.list_remove
                      : (i.actualBytes != i.totalBytes || i.actualBytes == 0)
                          ? AdwaitaIcons.window_close
                          : AdwaitaIcons.user_trash),
                ),
                onTap: (i.actualBytes == i.totalBytes && i.totalBytes != 0)
                    ? () => runProgram(
                          location: ref.watch(downloadPathProvider),
                          program: i.name,
                        )
                    : () {},
              );
            },
            itemCount: listDownloads.length,
          ))))
        : const Center(child: Text('No Downloads found'));
  }
}
