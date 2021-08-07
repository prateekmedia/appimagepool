import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/widgets/custom_adwaita_header_button.dart';
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
          onDoubleTap: () => appWindow.maximizeOrRestore(),
          child: AdwaitaHeaderBar(
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
                  child: CustomAdwaitaHeaderButton(
                    child: IconButton(
                      icon: const AdwaitaIcon(AdwaitaIcons.go_previous),
                      onPressed: context.back,
                    ),
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
