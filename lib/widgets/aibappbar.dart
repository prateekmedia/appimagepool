import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../utils/utils.dart';

Widget aibAppBar(
  BuildContext context, {
  String? title,
  bool alwaysOpened = false,
  List<Widget>? leading,
  List<Widget>? trailing,
  ValueNotifier<String>? searchText,
  required Widget body,
}) {
  var trailingIcons = [
    Hero(
      tag: 'window-buttons',
      child: Row(
        children: [
          MinimizeWindowButton(
            colors: WindowButtonColors(
                iconNormal: context.isDark ? Colors.white : Colors.black),
          ),
          MaximizeWindowButton(
            colors: WindowButtonColors(
                iconNormal: context.isDark ? Colors.white : Colors.black),
          ),
          CloseWindowButton(
            colors: WindowButtonColors(
              iconNormal: context.isDark ? Colors.white : Colors.black,
              mouseOver: Colors.red,
            ),
          ),
        ],
      ),
    ),
  ];
  if (trailing != null) {
    trailing.addAll(trailingIcons);
  } else {
    trailing = trailingIcons;
  }
  return MoveWindow(
    child: WindowBorder(
      color: Colors.grey,
      width: 1,
      child: FloatingSearchAppBar(
          title: title != null && title.isNotEmpty
              ? Hero(tag: 'header-title', child: Text(title))
              : Container(),
          alwaysOpened: alwaysOpened,
          leadingActions: leading,
          transitionDuration: const Duration(milliseconds: 800),
          colorOnScroll: context.isDark
              ? Colors.grey[800]!.darken(20)
              : Colors.grey[200]!.brighten(20),
          color: context.isDark ? Colors.grey[800] : Colors.grey[300],
          onQueryChanged: (query) {
            if (searchText != null) {
              searchText.value = query;
            }
          },
          actions: trailing,
          body: body),
    ),
  );
}
