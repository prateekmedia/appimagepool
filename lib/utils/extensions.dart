import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension Context on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);

  Brightness get brightness => Theme.of(this).brightness;
  bool get isDark => brightness == Brightness.dark;
  back() => Navigator.of(this).pop();
}

extension CategoryIterable<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(List<K> Function(E) keyFunction) {
    return fold(
      {},
      (Map<K, List<E>> map, E element) {
        for (var el in keyFunction(element)) {
          map.putIfAbsent(el, () => <E>[]).add(element);
        }
        return map;
      },
    );
  }
}

extension UrlLauncher on String {
  launchIt() async => await launch(this);
}

extension GetHumanizedFileSizeExtension on int {
  String getFileSize() {
    if (this <= 0) return "0.0 KB";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }
}

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

extension FileMoveExt on FileSystemEntity {
  File get toFile => File(path);

  Future moveFile(String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await toFile.rename(newPath);
    } on FileSystemException catch (_) {
      // if rename fails, copy the source file and then delete it
      final newFile = await toFile.copy(newPath);
      await delete();
      return newFile;
    }
  }
}
