import 'package:flutter/material.dart';
import 'package:adwaita_icons/adwaita_icons.dart';

class GtkSidebar extends StatelessWidget {
  final int? itemCount;
  final int? currentIndex;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final List<GtkSidebarItem>? children;
  final Function(int index) onSelected;
  final GtkSidebarItem Function(
      BuildContext context, int index, bool isSelected)? itemBuilder;

  const GtkSidebar({
    Key? key,
    required this.currentIndex,
    required this.onSelected,
    this.itemBuilder,
    this.itemCount,
    this.controller,
    this.padding,
    this.children,
  })  : assert(children != null || (itemBuilder != null && itemCount != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return children != null
        ? ListView(
            controller: controller,
            padding: padding,
            children: children!
                .asMap()
                .entries
                .map(
                  (e) => _gtkSidebarItem(
                    context,
                    e.value,
                    currentIndex == e.key,
                    onSelected: () => onSelected(e.key),
                  ),
                )
                .toList(),
          )
        : ListView.builder(
            controller: controller,
            padding: padding,
            itemBuilder: (context, index) => _gtkSidebarItem(
              context,
              itemBuilder!(context, index, currentIndex == index),
              currentIndex == index,
              onSelected: () => onSelected(index),
            ),
            itemCount: itemCount!,
          );
  }
}

class GtkSidebarItem {
  /// The key of the gtk sidebar item child.
  final Key? key;

  /// The label to render to the right of the button
  final String? label;

  /// The style of the label
  final TextStyle? labelStyle;

  /// The label to render to the right of the button
  final Widget? labelWidget;

  // the leading widget for sidebar item
  final Widget? leading;

  // the leading icon for sidebar item
  final String? leadingIcon;

  GtkSidebarItem({
    this.key,
    this.label,
    this.labelStyle,
    this.labelWidget,
    this.leading,
    this.leadingIcon,
  })  : assert(labelWidget != null || label != null),
        assert(leading == null || leadingIcon == null);
}

Widget _gtkSidebarItem(
  BuildContext context,
  GtkSidebarItem item,
  bool isSelected, {
  VoidCallback? onSelected,
}) {
  return ListTile(
    onTap: onSelected,
    tileColor: isSelected ? Theme.of(context).primaryColor : null,
    title: Row(
      children: [
        item.leading != null
            ? item.leading!
            : item.leadingIcon != null
                ? AdwaitaIcon(
                    item.leadingIcon!,
                    size: 19,
                    color: isSelected ? Colors.white : null,
                  )
                : const SizedBox(),
        const SizedBox(width: 12),
        item.labelWidget ??
            Text(
              item.label!,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 15,
              ),
            ),
      ],
    ),
  );
}
