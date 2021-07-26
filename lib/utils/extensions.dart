import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension Context on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  back() => Navigator.of(this).pop();
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    Map<K, List<E>> mape(element, map) {
      for (var el in (keyFunction(element) as List)) {
        map.putIfAbsent(el, () => <E>[]).add(element);
      }
      return map;
    }

    return fold(
        <K, List<E>>{}, (Map<K, List<E>> map, E element) => mape(element, map));
  }
}

extension UrlLauncher on String {
  launchIt() async => await canLaunch(this)
      ? await launch(this)
      : throw 'Could not launch $this';
}

extension GetHumanizedFileSizeExtension on int {
  String getFileSize() {
    if (this <= 0) return "0.0 KB";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }
}

extension ColorTint on Color {
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
}
