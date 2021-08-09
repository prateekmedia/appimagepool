import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/widgets/widgets.dart';
import 'package:appimagepool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import 'package:popover/popover.dart';

class GtkPopupMenu extends StatelessWidget {
  final List<Widget> children;
  final String? icon;
  final double popupWidth;
  final double? popupHeight;

  const GtkPopupMenu({
    Key? key,
    required this.children,
    this.icon,
    this.popupWidth = 200,
    this.popupHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAdwaitaHeaderButton(
        child: IconButton(
      icon: Center(
        child: AdwaitaIcon(
          icon ?? AdwaitaIcons.menu,
          size: 17,
        ),
      ),
      onPressed: () {
        showPopover(
          context: context,
          barrierColor: Colors.transparent,
          contentDyOffset: 4,
          shadow: [
            BoxShadow(
              color: context.isDark
                  ? const Color(0x1FFFFFFF)
                  : const Color(0x1F000000),
              blurRadius: 5,
            )
          ],
          backgroundColor: context.isDark
              ? AdwaitaDarkColors.headerButtonBackgroundTop
              : AdwaitaLightColors.headerButtonBackgroundTop,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          direction: PopoverDirection.top,
          width: popupWidth,
          height: popupHeight,
          arrowHeight: 10,
          arrowWidth: 22,
        );
      },
    ));
  }
}
