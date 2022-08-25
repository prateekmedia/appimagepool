import 'package:flutter/material.dart';

extension ColorExts on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }

  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(alpha, red + ((255 - red) * p).round(),
        green + ((255 - green) * p).round(), blue + ((255 - blue) * p).round());
  }

  Color invertColor() {
    const colors = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f'
    ];
    var inverseColor = '';
    value.toRadixString(16).replaceAll('#', '').split('').forEach((String i) {
      final int index = colors.indexOf(i);
      inverseColor += colors.reversed.toList()[index];
    });
    return Color(int.parse(inverseColor.toString(), radix: 16));
  }
}
