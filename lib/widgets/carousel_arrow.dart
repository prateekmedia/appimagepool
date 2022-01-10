import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/utils/extensions.dart';
import 'package:libadwaita/libadwaita.dart';

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
    return SizedBox(
      height: 44,
      width: 44,
      child: AdwButton.circular(
        onPressed: onPressed,
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.70),
        child: Icon(
          icon,
          color: context.textTheme.bodyText1!.color,
          size: 30,
        ),
      ),
    );
  }
}
