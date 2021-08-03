import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import '../utils/utils.dart';

Widget aibAppBar(
  BuildContext context, {
  String? title,
  bool alwaysOpened = false,
  List<Widget> leading = const [],
  List<Widget> trailing = const [],
  ValueNotifier<String>? searchText,
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
            onMaximize: appWindow.maximize,
            leading: Row(children: [
              title != null && title.isNotEmpty
                  ? Hero(tag: 'header-title', child: Text(title))
                  : Container(),
              ...leading,
            ]),
            // onQueryChanged: (query) {
            //   if (searchText != null) {
            //     searchText.value = query;
            //   }
            // },
            trailling: Row(children: trailing),
          ),
        ),
        Expanded(child: body),
      ],
    ),
  );
}
