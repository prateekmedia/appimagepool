import 'dart:io';

import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import './utils.dart';

Widget downloadButton(
    BuildContext context, List<QueryApp> listDownloads, bool downloading) {
  return Hero(
    tag: 'download_menu',
    child: CustomAdwaitaHeaderButton(
      child: AppPopupMenu(
        menuItems: List.generate(listDownloads.length, (index) {
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
                    subtitle: Text(
                        "${i.actualBytes.getFileSize()}/${i.totalBytes.getFileSize()}"),
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
                            : AdwaitaIcons.user_trash)),
                  )),
              value: i.name);
        }).toList(),
        elevation: 3,
        color: context.theme.canvasColor,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: AdwaitaIcon(
            downloading
                ? AdwaitaIcons.folder_download
                : AdwaitaIcons.emblem_default,
            size: 18),
      ),
    ),
  );
}
