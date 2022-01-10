import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';

import 'widgets.dart';
import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';
import 'package:appimagepool/providers/providers.dart';

class PrefsDialog extends HookConsumerWidget {
  const PrefsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isBrowserActive = useState<bool>(false);
    final path = ref.watch(downloadPathProvider);
    return RoundedDialog(
      height: 600,
      width: 600,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.themeType,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<ThemeType>(
                      value: ref.watch(themeTypeProvider),
                      items: ThemeType.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                describeEnum(e),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.read(themeTypeProvider.notifier).set(value!);
                      },
                      underline: const SizedBox(),
                      icon: const Icon(
                        LucideIcons.chevronsUpDown,
                        size: 16,
                      ),
                      itemHeight: 48,
                      selectedItemBuilder: (ctx) => ThemeType.values
                          .map(
                            (e) => Align(
                              alignment: Alignment.center,
                              child: Text(
                                describeEnum(e),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.downloadPath),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Icon(LucideIcons.folder, size: 18),
                            const SizedBox(width: 6),
                            SelectableText(path ==
                                    p.join(Platform.environment['HOME']!,
                                            'Applications') +
                                        '/'
                                ? 'Applications'
                                : path),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AdwButton(
                    onPressed: !isBrowserActive.value
                        ? () async {
                            isBrowserActive.value = true;
                            ref.watch(downloadPathProvider.notifier).update =
                                await FilePicker.platform.getDirectoryPath(
                                    dialogTitle: AppLocalizations.of(context)!
                                        .chooseDownloadFolder);
                            isBrowserActive.value = false;
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.browseFolder,
                      style: TextStyle(
                          color: context.isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              ApSwitchTile(
                title: AppLocalizations.of(context)!.forceDarkTheme,
                value: context.isDark,
                onChanged: (value) {
                  ref
                      .read(forceDarkThemeProvider.notifier)
                      .toggle(context.brightness);
                },
              ),
              ApSwitchTile(
                title: AppLocalizations.of(context)!.portableHome,
                value: ref.watch(portableAppImageProvider).isPortableHome,
                onChanged: (value) =>
                    ref.read(portableAppImageProvider).isPortableHome = value,
              ),
              ApSwitchTile(
                title: AppLocalizations.of(context)!.portableConfig,
                value: ref.watch(portableAppImageProvider).isPortableConfig,
                onChanged: (value) =>
                    ref.read(portableAppImageProvider).isPortableConfig = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdwButton(
                    onPressed: () {
                      ref.read(forceDarkThemeProvider.notifier).reset();
                      ref.read(portableAppImageProvider.notifier).reset();
                      ref.read(themeTypeProvider.notifier).reset();
                      ref.read(viewTypeProvider.notifier).reset();
                    },
                    child: Text(AppLocalizations.of(context)!.restoreDefaults),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
