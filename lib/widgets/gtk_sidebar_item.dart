import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

Widget gtkSidebarItem(
  BuildContext context,
  bool isSelected, {
  String? label,
  String? icon,
  Widget? labelWidget,
  Widget? iconWidget,
  VoidCallback? onSelected,
}) {
  return ListTile(
    onTap: onSelected,
    tileColor: isSelected ? context.theme.primaryColor : null,
    title: Row(
      children: [
        if (iconWidget != null) iconWidget,
        if (icon != null)
          AdwaitaIcon(
            icon,
            size: 19,
            color: isSelected ? Colors.white : null,
          ),
        const SizedBox(width: 12),
        labelWidget ??
            Text(
              label!,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 15,
              ),
            ),
      ],
    ),
  );
}
