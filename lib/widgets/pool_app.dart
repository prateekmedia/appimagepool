import 'package:gtk/gtk.dart';
import 'package:flutter/material.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';
import '../providers/providers.dart';

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
        GtkHeaderBar.nativeshell(
          titlebarSpace: 0,
          window: Window.of(context),
          showMinimize: context.width >= mobileWidth,
          showMaximize: context.width >= mobileWidth,
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
              : center ?? const SizedBox(),
          trailling: Row(children: trailing),
          themeType: ref.watch(themeTypeProvider),
        ),
        Expanded(child: body),
      ],
    );
  }
}
