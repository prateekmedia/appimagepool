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
      (keyFunction(element) as List)
          .forEach((el) => map..putIfAbsent(el, () => <E>[]).add(element));
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

extension getHumanizedFileSizeExtension on int {
  String getFileSize({int decimals = 1}) {
    if (this <= 0) return "0.0 KB";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}

extension ColorTint on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(this.alpha, (this.red * f).round(),
        (this.green * f).round(), (this.blue * f).round());
  }

  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        this.alpha,
        this.red + ((255 - this.red) * p).round(),
        this.green + ((255 - this.green) * p).round(),
        this.blue + ((255 - this.blue) * p).round());
  }
}
