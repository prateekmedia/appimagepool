import 'dart:io';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:appimagepool/models/models.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'extensions.dart';

Widget downloadButton(
    BuildContext context, List<QueryApp> listDownloads, bool downloading) {
  return CircularButton(
    onPressed: () {},
    icon: AppPopupMenu(
      menuItems: List.generate(listDownloads.length, (index) {
        var i = listDownloads[index];
        return PopupMenuItem<String>(
            child: Tooltip(
                message: i.name,
                child: ListTile(
                  // leading: i.value[2], icon
                  title: Text(
                    i.name,
                    overflow: TextOverflow.ellipsis,
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
                        debugPrint(i.cancelToken.toString());
                        if (i.actualBytes != i.totalBytes) {
                          i.cancelToken.cancel("cancelled");
                        } else {
                          File(i.downloadLocation + i.name).deleteSync();
                          listDownloads.removeAt(index);
                        }
                      },
                      icon: Icon((i.actualBytes != i.totalBytes)
                          ? Icons.close
                          : Icons.delete)),
                )),
            value: i.name);
      }).toList(),
      elevation: 3,
      offset: const Offset(0, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: Icon(
          downloading ? Icons.download_outlined : Icons.download_done_outlined),
    ),
  );
}
