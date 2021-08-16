import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

getGtkColor({
  required GtkColorType colorType,
  required bool isDark,
  GtkColorTheme colorTheme = GtkColorTheme.adwaita,
}) {
  return isDark
      ? _adwaitaDark[describeEnum(colorType)]
      : _adwaitaLight[describeEnum(colorType)];
}

getAdaptiveGtkColor(
  BuildContext context, {
  required GtkColorType colorType,
  GtkColorTheme colorTheme = GtkColorTheme.adwaita,
}) {
  return Theme.of(context).brightness == Brightness.dark
      ? _adwaitaDark[describeEnum(colorType)]
      : _adwaitaLight[describeEnum(colorType)];
}

enum GtkColorType {
  windowControlIconColor,
  canvas,
  headerBarBackgroundTop,
  headerBarBackgroundBottom,
  headerBarTopBorder,
  headerBarBottomBorder,
  headerButtonBackgroundTop,
  headerButtonBackgroundBottom,
  headerButtonBorder,
  headerButtonPrimary,
  headerSwitcherTabPrimary,
  headerSwitcherTabBackground,
  headerSwitcherTabBorder,
}

enum GtkColorTheme {
  adwaita,
}

final Map<String, Color> _adwaitaLight = {
  'windowControlIconColor': const Color(0xFF2E3436),
  'canvas': const Color(0xFFF6F5F4),
  'headerBarBackgroundTop': const Color(0xFFE1DEDB),
  'headerBarBackgroundBottom': const Color(0xFFDAD6D2),
  'headerBarTopBorder': const Color(0xFFF9F8F8),
  'headerBarBottomBorder': const Color(0xFFBFB8B1),
  'headerButtonBackgroundTop': const Color(0xFFF6F5F3),
  'headerButtonBackgroundBottom': const Color(0xFFEEECEA),
  'headerButtonBorder': const Color(0xFFCEC8C3),
  'headerButtonPrimary': const Color(0xFF393E40),
  'headerSwitcherTabPrimary': const Color(0xFF2E3436),
  'headerSwitcherTabBackground': const Color(0xFFD5D1CD),
  'headerSwitcherTabBorder': const Color(0xFFCDC7C2),
};

final Map<String, Color> _adwaitaDark = {
  'windowControlIconColor': const Color(0xFFEEEEEC),
  'canvas': const Color(0xFF353535),
  'headerBarBackgroundTop': const Color(0xFF2B2B2B),
  'headerBarBackgroundBottom': const Color(0xFF262626),
  'headerBarTopBorder': const Color(0xFF383838),
  'headerBarBottomBorder': const Color(0xFF070707),
  'headerButtonBackgroundTop': const Color(0xFF383838),
  'headerButtonBackgroundBottom': const Color(0xFF333333),
  'headerButtonBorder': const Color(0xFF1B1B1B),
  'headerButtonPrimary': const Color(0xFFEEEEEC),
  'headerSwitcherTabPrimary': const Color(0xFFE6E6E4),
  'headerSwitcherTabBackground': const Color(0xFF1E1E1E),
  'headerSwitcherTabBorder': const Color(0xFF1B1B1B),
};
