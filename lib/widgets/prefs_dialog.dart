import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';
import 'package:appimagepool/widgets/widgets.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/utils/utils.dart';

Dialog prefsDialog(BuildContext context) {
  return roundedDialog(context, height: 600, width: 600, children: [
    const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: PrefsWidget(),
    ),
  ]);
}

class PrefsWidget extends HookConsumerWidget {
  const PrefsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: context.theme.canvasColor,
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
                icon: const AdwaitaIcon(
                  AdwaitaIcons.go_down,
                  size: 16,
                ),
                selectedItemBuilder: (ctx) => ThemeType.values
                    .map(
                      (e) => Align(
                        alignment: Alignment.center,
                        child: Text(describeEnum(e)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
