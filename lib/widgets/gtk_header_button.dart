import 'package:appimagepool/utils/utils.dart';
import 'package:flutter/material.dart';

class GtkHeaderButton extends StatelessWidget {
  final Widget child;
  final Color? color;

  const GtkHeaderButton({
    Key? key,
    required this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 36,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getAdaptiveGtkColor(
            context,
            colorType: GtkColorType.headerButtonBorder,
          ),
        ),
        color: color,
        gradient: color == null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  getAdaptiveGtkColor(
                    context,
                    colorType: GtkColorType.headerBarBackgroundBottom,
                  ),
                  getAdaptiveGtkColor(
                    context,
                    colorType: GtkColorType.headerBarBackgroundTop,
                  ),
                ],
              )
            : null,
      ),
      child: child,
    );
  }
}
