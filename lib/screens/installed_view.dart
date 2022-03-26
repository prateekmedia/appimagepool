import 'dart:io';

import 'package:gap/gap.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';
import 'package:appimagepool/providers/providers.dart';

class InstalledView extends ConsumerStatefulWidget {
  final ValueNotifier<String> searchedTerm;

  const InstalledView({Key? key, required this.searchedTerm}) : super(key: key);

  @override
  ConsumerState<InstalledView> createState() => _InstalledViewState();
}

class _InstalledViewState extends ConsumerState<InstalledView> {
  late List _content = [];

  updateContent() {
    _content = Directory(applicationsDir).existsSync()
        ? Directory(applicationsDir)
            .listSync(recursive: false)
            .map((event) => path.basenameWithoutExtension(event.path))
            .toList()
        : [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateContent();
  }

  @override
  Widget build(context) {
    final downloadPath = ref.watch(downloadPathProvider);
    List<FileSystemEntity> listInstalled = Directory(downloadPath).existsSync()
        ? Directory(downloadPath)
            .listSync()
            .where((element) => element.path.endsWith('.AppImage'))
            .where((element) => path
                .basename(element.path)
                .toLowerCase()
                .contains(widget.searchedTerm.value))
            .toList()
        : [];
    return listInstalled.isNotEmpty
        ? SingleChildScrollView(
            controller: ScrollController(),
            child: Center(
              child: AdwClamp(
                child: AdwPreferencesGroup(
                  children: List.generate(
                    listInstalled.length,
                    (index) {
                      final i = listInstalled[index];
                      int integratedIndex = _content.isNotEmpty
                          ? _content.indexOf(
                              'aip_' + path.basenameWithoutExtension(i.path))
                          : -1;

                      bool isIntegrated = integratedIndex >= 0;

                      void removeItem() async {
                        File(i.path).deleteSync();
                        listInstalled.removeAt(index);
                        setState(() {});
                      }

                      void integrateOrRemove() async {
                        if (isIntegrated) {
                          // Delete Desktop file
                          await File(applicationsDir +
                                  _content[integratedIndex] +
                                  ".desktop")
                              .delete();

                          // Delete Icons
                          for (var icon in Directory(iconsDir)
                              .listSync(recursive: true)) {
                            if (icon is File &&
                                path.basenameWithoutExtension(icon.path) ==
                                    _content[integratedIndex]) {
                              await icon.delete();
                            }
                          }

                          // Remove checksum from app
                          final basenl =
                              path.basenameWithoutExtension(i.path).split('_');
                          i.moveFile(path.dirname(i.path) +
                              '/' +
                              basenl.sublist(0, basenl.length - 1).join('_') +
                              path.extension(i.path));
                        } else {
                          String tempDir =
                              (await getTemporaryDirectory()).path +
                                  "/appimagepool_" +
                                  path.basenameWithoutExtension(i.path);

                          // Create Temporary Directory
                          Directory dir = Directory(tempDir);
                          await dir.create();

                          // Create AppImage executable first
                          makeProgramExecutable(
                            location: path.dirname(i.path),
                            program: path.basename(i.path),
                          );

                          //Extract AppImage's Content
                          await Process.run(
                            i.path,
                            ["--appimage-extract"],
                            workingDirectory: tempDir,
                          );

                          final checksum = (await Process.run(
                            'md5sum',
                            [i.path],
                          ))
                              .stdout
                              .toString()
                              .split(' ')[0]
                              .trim();

                          var newPath = path.withoutExtension(i.path) +
                              '_$checksum' +
                              path.extension(i.path);
                          i.moveFile(newPath);

                          String squashDir = tempDir + "/squashfs-root";

                          String desktopfilename = 'aip_' +
                              path.basenameWithoutExtension(newPath) +
                              ".desktop";

                          // Copy desktop file
                          try {
                            var desktopFile = Directory(squashDir)
                                .listSync()
                                .firstWhere((element) =>
                                    path.extension(element.path) == ".desktop");
                            await desktopFile
                                .moveFile(applicationsDir + desktopfilename);
                            String execPath = (await Process.run(
                              "grep",
                              [
                                "Exec=",
                                desktopfilename,
                              ],
                              runInShell: true,
                              workingDirectory: applicationsDir,
                            ))
                                .stdout
                                .split("=")[1]
                                .split(' ')[0]
                                .trim();

                            String iconName = (await Process.run(
                              "grep",
                              [
                                "Icon=",
                                desktopfilename,
                              ],
                              runInShell: true,
                              workingDirectory: applicationsDir,
                            ))
                                .stdout
                                .split("=")[1]
                                .trim();

                            // Update desktop file
                            debugPrint((await Process.run(
                              "sed",
                              [
                                "-i",
                                "-e",
                                "s:Exec=$execPath:Exec=$newPath:g",
                                "-e",
                                "s:Icon=$iconName:Icon=aip_${iconName}_$checksum:g",
                                desktopfilename,
                              ],
                              workingDirectory: applicationsDir,
                            ))
                                .stderr);
                          } catch (_) {
                            debugPrint("Desktop file not found!");
                          }

                          // Copy Icons
                          var iconsDir =
                              Directory(squashDir + "/usr/share/icons");

                          if (iconsDir.existsSync()) {
                            for (FileSystemEntity icon
                                in iconsDir.listSync(recursive: true)) {
                              if (icon is File) {
                                icon.moveFile(path.dirname(icon.path) +
                                    '/aip_' +
                                    path.basenameWithoutExtension(icon.path) +
                                    '_$checksum' +
                                    path.extension(icon.path));
                              }
                            }

                            (await Process.run(
                              "cp",
                              ["-r", "./usr/share/icons", localShareDir],
                              workingDirectory: squashDir,
                            ));
                          }

                          Directory(tempDir).delete(recursive: true);
                        }

                        updateContent();
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: isIntegrated
                                  ? AppLocalizations.of(context)!.disintegrate
                                  : AppLocalizations.of(context)!.integrate,
                              onPressed: integrateOrRemove,
                              icon: Icon(isIntegrated
                                  ? LucideIcons.x
                                  : LucideIcons.check),
                            ),
                            const Gap(4),
                            IconButton(
                              onPressed: removeItem,
                              icon: const Icon(LucideIcons.trash),
                            ),
                          ],
                        ),
                        onTap: () => runProgram(
                          ref,
                          location: path.dirname(i.path),
                          program: path.basename(i.path),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: Text(
                '${AppLocalizations.of(context)!.noAppImageInThisRelease} ' +
                    downloadPath));
  }
}
