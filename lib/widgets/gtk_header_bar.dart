import 'package:appimagepool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:window_decorations/window_decorations.dart';

class GtkHeaderBar extends StatelessWidget {
  final Widget leading;
  final Widget center;
  final Widget trailling;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;
  final ThemeType themeType;

  const GtkHeaderBar({
    Key? key,
    this.leading = const SizedBox(),
    this.center = const SizedBox(),
    this.trailling = const SizedBox(),
    this.themeType = ThemeType.auto,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
  }) : super(key: key);

  bool get hasWindowControls =>
      onClose != null || onMinimize != null || onMaximize != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => appWindow.startDragging(),
      onDoubleTap: () => appWindow.maximizeOrRestore(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                getAdaptiveGtkColor(
                  context,
                  colorType: GtkColorType.headerBarBackgroundTop,
                ),
                getAdaptiveGtkColor(
                  context,
                  colorType: GtkColorType.headerBarBackgroundBottom,
                ),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: getAdaptiveGtkColor(
                  context,
                  colorType: GtkColorType.headerBarTopBorder,
                ),
              ),
              bottom: BorderSide(
                color: getAdaptiveGtkColor(
                  context,
                  colorType: GtkColorType.headerBarBottomBorder,
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
                                  type: themeType,
                                  onPressed: onMinimize,
                                ),
                              if (onMaximize != null)
                                DecoratedMaximizeButton(
                                  type: themeType,
                                  onPressed: onMaximize,
                                ),
                              if (onClose != null)
                                DecoratedCloseButton(
                                  type: themeType,
                                  onPressed: onClose,
                                ),
                            ]
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
      ),
    );
  }
}
