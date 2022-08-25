import 'package:flutter/material.dart';

extension BuildContextExtended on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);

  Brightness get brightness => Theme.of(this).brightness;
  bool get isDark => brightness == Brightness.dark;
  back() => Navigator.of(this).pop();
}
