import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:file_picker/file_picker.dart';
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

    void browseFolder() async {
      if (!isBrowserActive.value) {
        isBrowserActive.value = true;
        ref.read(downloadPathProvider.notifier).update =
            await FilePicker.platform.getDirectoryPath(
                dialogTitle:
                    AppLocalizations.of(context)!.chooseDownloadFolder);
        isBrowserActive.value = false;
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
              subtitle: path,
              onActivated: browseFolder,
              end: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdwButton(
                    onPressed: browseFolder,
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
              onChanged: (value) {
                ref
                    .read(forceDarkThemeProvider.notifier)
                    .toggle(context.brightness);
              },
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
              onPressed: () {
                ref.read(forceDarkThemeProvider.notifier).reset();
                ref.read(portableAppImageProvider.notifier).reset();
                ref.read(viewTypeProvider.notifier).reset();
              },
              child: Text(AppLocalizations.of(context)!.restoreDefaults),
            ),
          ],
        ),
      ],
    );
  }
}
