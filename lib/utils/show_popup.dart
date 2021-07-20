import 'dart:io';

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
    icon: GestureDetector(
      onTapDown: (details) {
        showPopupMenu(context, details.globalPosition, listDownloads);
      },
      child: Icon(
          downloading ? Icons.download_outlined : Icons.download_done_outlined),
    ),
  );
}

showPopupMenu(BuildContext context, Offset offset, List listDownloads) {
  double left = offset.dx;
  double top = offset.dy;
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top, 0, 0),
    items: List.generate(listDownloads.length, (index) {
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
                    "${(i.actualBytes as int).getFileSize()}/${(i.totalBytes as int).getFileSize()}"),
                trailing: IconButton(
                    onPressed: () {
                      debugPrint(i.cancelToken.toString());
                      if (i.actualBytes != i.totalBytes)
                        i.cancelToken.cancel("cancelled");
                      else {
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
    elevation: 8.0,
  );
}
