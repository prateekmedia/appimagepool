import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/utils.dart';

class PoolApp extends HookConsumerWidget {
  final String? title;
  final List<Widget> leading;
  final List<Widget> trailing;
  final bool showBackButton;
  final Widget body;
  final VoidCallback? onBackPressed;

  const PoolApp({
    Key? key,
    this.title,
    required this.body,
    this.leading = const [],
    this.trailing = const [],
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return WindowBorder(
      color: getAdaptiveGtkColor(
        context,
        colorType: GtkColorType.headerSwitcherTabBorder,
      ),
      width: 1,
      child: Column(
        children: [
          GtkHeaderBar(
            onClose: appWindow.close,
            onMinimize:
                context.width >= mobileWidth ? appWindow.minimize : null,
            onMaximize: context.width >= mobileWidth
                ? appWindow.maximizeOrRestore
                : null,
            leading: Row(children: [
              if (showBackButton)
                Hero(
                  tag: 'back-button',
                  child: Material(
                    type: MaterialType.transparency,
                    child: GtkHeaderButton(
                      icon: const AdwaitaIcon(AdwaitaIcons.go_previous),
                      onPressed: () {
                        if (onBackPressed != null) onBackPressed!();
                        context.back();
                      },
                    ),
                  ),
                ),
              ...leading,
            ]),
            center: (title != null && title!.isNotEmpty)
                ? Text(
                    title!,
                    style: context.textTheme.headline6!.copyWith(fontSize: 17),
                  )
                : const SizedBox(),
            trailling: Row(children: trailing),
            themeType: ref.watch(themeTypeProvider),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
