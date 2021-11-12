import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gtk/gtk.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';

import 'widgets.dart';
import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/providers/providers.dart';

Widget prefsDialog(BuildContext context) {
  return const RoundedDialog(
    height: 600,
    width: 600,
    children: [
      SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: PrefsWidget(),
      ),
    ],
  );
}

class PrefsWidget extends HookConsumerWidget {
  const PrefsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isBrowserActive = useState<bool>(false);
    final path = ref.watch(downloadPathProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Theme type",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).bgColor,
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
            const Text('Download Path'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                      SelectableText(
                          path == p.join(Platform.environment['HOME']!, 'Applications') + '/' ? 'Applications' : path),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Theme.of(context).sidebars),
              onPressed: !isBrowserActive.value
                  ? () async {
                      isBrowserActive.value = true;
                      var dirPath = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Choose Download Folder');
                      isBrowserActive.value = false;
                      ref.watch(downloadPathProvider.notifier).update = dirPath ?? path;
                    }
                  : null,
              child: Text(
                'Browse...',
                style: TextStyle(color: context.isDark ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Force dark theme'),
            CupertinoSwitch(
              value: context.isDark,
              activeColor: context.theme.primaryColor,
              onChanged: (value) {
                ref.read(forceDarkThemeProvider.notifier).toggle(context.brightness);
              },
            ),
          ],
        ),
      ],
    );
  }
}
