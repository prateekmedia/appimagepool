import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:appimagepool/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CarouselArrow extends ConsumerWidget {
  const CarouselArrow({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String icon;

  @override
  Widget build(context, ref) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: GnomeTheme.of(context).sidebars.withOpacity(0.70),
          shape: const CircleBorder(),
        ),
        child: AdwaitaIcon(icon, color: context.textTheme.bodyText1!.color, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}
