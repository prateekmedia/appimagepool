import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import '../utils/utils.dart';

Widget aibAppBar(
  BuildContext context, {
  String? title,
  List<Widget> leading = const [],
  List<Widget> trailing = const [],
  bool showBackButton = false,
  required Widget body,
}) {
  return WindowBorder(
    color: context.isDark
        ? AdwaitaDarkColors.headerSwitcherTabBorder
        : AdwaitaLightColors.headerSwitcherTabBorder,
    width: 1,
    child: Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (_) => appWindow.startDragging(),
          child: AdwaitaHeaderBar(
            onClose: appWindow.close,
            onMinimize: appWindow.minimize,
            onMaximize: appWindow.maximizeOrRestore,
            leading: Row(children: [
              if (showBackButton)
                Hero(
                  tag: 'back-button',
                  child: AdwaitaHeaderButton(
                    icon: Icons.chevron_left,
                    onTap: context.back,
                  ),
                ),
              ...leading,
            ]),
            center: (title != null && title.isNotEmpty)
                ? Text(
                    title,
                    style: context.textTheme.headline6!.copyWith(fontSize: 17),
                  )
                : const SizedBox(),
            trailling: Row(children: trailing),
          ),
        ),
        Expanded(child: body),
      ],
    ),
  );
}
