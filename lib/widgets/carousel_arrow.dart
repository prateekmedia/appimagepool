import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/extensions.dart';

class CarouselArrow extends ConsumerWidget {
  const CarouselArrow({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(context, ref) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: Theme.of(context).sidebars.withOpacity(0.70),
        ),
        child: Center(child: Icon(icon, color: context.textTheme.bodyText1!.color, size: 30)),
      ),
    );
  }
}
