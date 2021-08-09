import 'package:appimagepool/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';

class GtkHeaderBar extends HookConsumerWidget {
  final Widget leading;
  final Widget center;
  final Widget trailling;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;

  const GtkHeaderBar({
    Key? key,
    this.leading = const SizedBox(),
    this.center = const SizedBox(),
    this.trailling = const SizedBox(),
    this.onMinimize,
    this.onMaximize,
    this.onClose,
  }) : super(key: key);

  bool get hasWindowControls =>
      onClose != null || onMinimize != null || onMaximize != null;

  @override
  Widget build(BuildContext context, ref) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemePicker.of(context).pick(
                light: AdwaitaLightColors.headerBarBackgroundTop,
                dark: AdwaitaDarkColors.headerBarBackgroundTop,
              ),
              ThemePicker.of(context).pick(
                light: AdwaitaLightColors.headerBarBackgroundBottom,
                dark: AdwaitaDarkColors.headerBarBackgroundBottom,
              ),
            ],
          ),
          border: Border(
            top: BorderSide(
              color: ThemePicker.of(context).pick(
                light: AdwaitaLightColors.headerBarTopBorder,
                dark: AdwaitaDarkColors.headerBarTopBorder,
              ),
            ),
            bottom: BorderSide(
              color: ThemePicker.of(context).pick(
                light: AdwaitaLightColors.headerBarBottomBorder,
                dark: AdwaitaDarkColors.headerBarBottomBorder,
              ),
            ),
          ),
        ),
        height: 47,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading,
                  Row(
                    children: [
                      trailling,
                      Row(
                        children: [
                          if (hasWindowControls) const SizedBox(width: 16),
                          ...[
                            if (onMinimize != null)
                              DecoratedMinimizeButton(
                                type: ref.read(themeTypeProvider),
                                onPressed: onMinimize,
                              ),
                            if (onMaximize != null)
                              DecoratedMaximizeButton(
                                type: ref.read(themeTypeProvider),
                                onPressed: onMaximize,
                              ),
                            if (onClose != null)
                              DecoratedCloseButton(
                                type: ref.read(themeTypeProvider),
                                onPressed: onClose,
                              ),
                          ].separate(11)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            center,
          ],
        ),
      ),
    );
  }
}
