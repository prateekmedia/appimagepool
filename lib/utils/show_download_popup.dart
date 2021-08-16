import 'dart:io';

import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/models/models.dart';
import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import './utils.dart';

Widget downloadButton(
    BuildContext context, List<QueryApp> listDownloads, bool downloading) {
  return Hero(
    tag: 'download_menu',
    child: Material(
      type: MaterialType.transparency,
      child: GtkPopupMenu(
        popupWidth: 400,
        icon: downloading
            ? AdwaitaIcons.folder_download
            : AdwaitaIcons.emblem_default,
        children: List.generate(listDownloads.length, (index) {
          var i = listDownloads[index];
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
                      i.actualBytes == i.totalBytes
                          ? "Download finished"
                          : "${i.actualBytes.getFileSize()}/${i.totalBytes.getFileSize()}",
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        if (i.actualBytes != i.totalBytes) {
                          i.cancelToken.cancel("cancelled");
                        } else {
                          File(i.downloadLocation + i.name).deleteSync();
                          listDownloads.removeAt(index);
                        }
                      },
                      icon: AdwaitaIcon((i.actualBytes != i.totalBytes)
                          ? AdwaitaIcons.edit_delete
                          : AdwaitaIcons.user_trash),
                    ),
                    onTap: (i.actualBytes == i.totalBytes && i.totalBytes != 0)
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
                  )),
              value: i.name);
        }).toList(),
      ),
    ),
  );
}
