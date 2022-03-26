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
                          ? _content
                              .indexOf(path.basenameWithoutExtension(i.path))
                          : -1;

                      bool isIntegrated = integratedIndex >= 0;

                      void removeItem() async {
                        File(i.path).deleteSync();
                        listInstalled.removeAt(index);
                        setState(() {});
                      }

                      void integrateOrRemove() async {
                        if (isIntegrated) {
                          File(applicationsDir +
                                  _content[integratedIndex] +
                                  ".desktop")
                              .deleteSync();
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
                          String squashDir = tempDir + "/squashfs-root";

                          String desktopfilename =
                              path.basenameWithoutExtension(i.path) +
                                  ".desktop";
                          // Copy desktop file
                          try {
                            var desktopFile = Directory(squashDir)
                                .listSync()
                                .firstWhere((element) =>
                                    path.extension(element.path) == ".desktop");
                            await desktopFile
                                .moveFile(applicationsDir + desktopfilename);
                            String grepOut = (await Process.run(
                              "grep",
                              [
                                "Exec=",
                                desktopfilename,
                              ],
                              runInShell: true,
                              workingDirectory: applicationsDir,
                            ))
                                .stdout;
                            var execPath =
                                grepOut.split("=")[1].split(' ')[0].trim();
                            // Update desktop file
                            debugPrint((await Process.run(
                              "sed",
                              [
                                "s:Exec=$execPath:Exec=${i.path}:g",
                                desktopfilename,
                                "-i",
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
                            (await Process.run(
                              "cp",
                              ["-r", "./usr/share/icons", localShareDir],
                              workingDirectory: squashDir,
                            ));
                          }

                          Directory(tempDir).delete(recursive: true);
                          updateContent();
                        }
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
