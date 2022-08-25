import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:appimagepool/src/utils/utils.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(
    ThemeMode.values.firstWhere(
        (ele) => ele.index == (MyPrefs().prefs.getInt('forceDark') ?? 0)),
  );
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(state) : super(state);

  toggle(bool isDark) {
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    MyPrefs().prefs.setInt('forceDark', state.index);
  }

  reset() {
    state = ThemeMode.system;
    MyPrefs().prefs.remove('forceDark');
  }
}
