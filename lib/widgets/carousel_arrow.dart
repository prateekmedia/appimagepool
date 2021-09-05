import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';

class CarouselArrow extends StatelessWidget {
  const CarouselArrow({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: getAdaptiveGtkColor(
            context,
            colorType: GtkColorType.headerButtonBackgroundBottom,
          ).withOpacity(0.70),
          shape: const CircleBorder(),
        ),
        child: AdwaitaIcon(icon, color: context.textTheme.bodyText1!.color, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
