import 'dart:io';

import 'package:gap/gap.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/widgets/widgets.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                            const Gap(6),
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
              const Gap(13),
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
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdwButton(
                    onPressed: () {
                      ref.read(forceDarkThemeProvider.notifier).reset();
                      ref.read(portableAppImageProvider.notifier).reset();
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
