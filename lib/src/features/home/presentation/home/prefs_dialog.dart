import 'package:appimagepool/src/features/app_info/presentation/rounded_dialog.dart';
import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/features/home/application/reset_all.dart';
import 'package:appimagepool/src/features/home/data/local_path_provider.dart';
import 'package:appimagepool/src/features/home/data/portable_appimage_provider.dart';
import 'package:appimagepool/src/features/theme/data/theme_mode.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/src/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';

class PrefsDialog extends HookConsumerWidget {
  const PrefsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isBrowserActive = useState<int>(0);
    final localPathP = ref.watch(localPathServiceProvider);

    void browseFolder(int value) async {
      if (isBrowserActive.value == 0) {
        isBrowserActive.value = value;
        var val = await FilePicker.platform.getDirectoryPath(
          dialogTitle: AppLocalizations.of(context)!.chooseFolder,
        );

        if (val != null && val.isNotEmpty) {
          switch (value) {
            case 1:
              ref.read(downloadPathProvider.notifier).update = val;
              break;
            case 2:
              localPathP.applicationsDir = val;
              break;
            case 3:
              localPathP.iconsDir = val;
              break;
            default:
          }
        }
        isBrowserActive.value = 0;
      }
    }

    return RoundedDialog(
      height: 600,
      width: 600,
      children: [
        AdwPreferencesGroup(
          children: [
            AdwActionRow(
              title: AppLocalizations.of(context)!.downloadPath,
              subtitle: ref.watch(downloadPathProvider),
              onActivated: () => browseFolder(1),
              end: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdwButton(
                    onPressed: () => browseFolder(1),
                    child: Text(
                      AppLocalizations.of(context)!.browseFolder,
                      style: TextStyle(
                          color: context.isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            AdwActionRow(
              title: "Applications Directory",
              subtitle: localPathP.applicationsDir,
              onActivated: () => browseFolder(2),
              end: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdwButton(
                    onPressed: () => browseFolder(2),
                    child: Text(
                      AppLocalizations.of(context)!.browseFolder,
                      style: TextStyle(
                          color: context.isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            AdwActionRow(
              title: "Icons Directory",
              subtitle: localPathP.iconsDir,
              onActivated: () => browseFolder(3),
              end: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdwButton(
                    onPressed: () => browseFolder(3),
                    child: Text(
                      AppLocalizations.of(context)!.browseFolder,
                      style: TextStyle(
                          color: context.isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            AdwSwitchRow(
              title: AppLocalizations.of(context)!.forceDarkTheme,
              value: context.isDark,
              onChanged: (value) => ref
                  .read(themeModeProvider.notifier)
                  .toggle(context.brightness),
            ),
            AdwSwitchRow(
              title: AppLocalizations.of(context)!.portableHome,
              value: ref.watch(portableAppImageProvider).isPortableHome,
              onChanged: (value) =>
                  ref.read(portableAppImageProvider).isPortableHome = value,
            ),
            AdwSwitchRow(
              title: AppLocalizations.of(context)!.portableConfig,
              value: ref.watch(portableAppImageProvider).isPortableConfig,
              onChanged: (value) =>
                  ref.read(portableAppImageProvider).isPortableConfig = value,
            ),
          ],
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AdwButton(
              onPressed: ref.read(resetSettingsProvider).reset,
              child: Text(AppLocalizations.of(context)!.restoreDefaults),
            ),
          ],
        ),
      ],
    );
  }
}
