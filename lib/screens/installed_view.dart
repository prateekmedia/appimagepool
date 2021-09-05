import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/providers/providers.dart';

class InstalledView extends HookConsumerWidget {
  const InstalledView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    final downloadPath = ref.watch(downloadPathProvider);
    final listInstalled = useState<List<FileSystemEntity>>(
        Directory(downloadPath).listSync().where((element) => element.path.endsWith('.AppImage')).toList());
    return listInstalled.value.isNotEmpty
        ? ListView.builder(
            itemBuilder: (ctx, index) {
              final i = listInstalled.value[index];

              void removeItem() async {
                File(i.path).deleteSync();
                listInstalled.value.removeAt(index);
                listInstalled.value = listInstalled.value;
              }

              return ListTile(
                title: Text(
                  path.basenameWithoutExtension(i.path),
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyText1,
                ),
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                subtitle: Text(i.statSync().size.getFileSize()),
                trailing: IconButton(
                  onPressed: removeItem,
                  icon: const AdwaitaIcon(AdwaitaIcons.user_trash),
                ),
                onTap: () {
                  var shell = Shell().cd(path.dirname(i.path));
                  shell.run('./' + path.basename(i.path));
                },
              );
            },
            itemCount: listInstalled.value.length,
          )
        : Center(child: Text('No AppImage found in ' + downloadPath));
  }
}
