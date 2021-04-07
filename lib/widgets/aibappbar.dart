import 'package:flutter/material.dart';
import '../utils/utils.dart';

Widget aibAppBar(BuildContext context,
    {bool forceElevated = false,
    String title = "",
    Widget? leading,
    List<Widget>? trailing}) {
  return SliverAppBar(
    forceElevated: forceElevated,
    backgroundColor: context.isDark ? Colors.grey[800] : Colors.grey[100],
    floating: true,
    leading: leading,
    title: Text(
      title,
      style: TextStyle(color: context.isDark ? Colors.white : Colors.black),
    ),
    actions: trailing,
  );
}
