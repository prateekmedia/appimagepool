import 'package:libadwaita/libadwaita.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PoolApp extends HookConsumerWidget {
  final String? title;
  final Widget? center;
  final List<Widget> leading;
  final List<Widget> trailing;
  final bool showBackButton;
  final Widget body;
  final VoidCallback? onBackPressed;

  const PoolApp({
    Key? key,
    this.title,
    this.center,
    required this.body,
    this.leading = const [],
    this.trailing = const [],
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        AdwHeaderBar.bitsdojo(
          titlebarSpace: 0,
          appWindow: appWindow,
          start: [
            if (showBackButton)
              Hero(
                tag: 'back-button',
                child: Material(
                  type: MaterialType.transparency,
                  child: AdwHeaderButton(
                    icon: const Icon(LucideIcons.chevronLeft, size: 17),
                    onPressed: () {
                      if (onBackPressed != null) onBackPressed!();
                      context.back();
                    },
                  ),
                ),
              ),
            ...leading,
          ],
          title: (title != null && title!.isNotEmpty)
              ? Text(title!)
              : center ?? const SizedBox(),
          end: trailing,
        ),
        Expanded(child: body),
      ],
    );
  }
}
