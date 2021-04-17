import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../utils/utils.dart';

Widget aibAppBar(
  BuildContext context, {
  String title = '',
  List<Widget>? leading,
  List<Widget>? trailing,
  ValueNotifier<String>? searchText,
  required Widget body,
}) {
  return FloatingSearchAppBar(
      title: Text(title),
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
      body: body);
}
