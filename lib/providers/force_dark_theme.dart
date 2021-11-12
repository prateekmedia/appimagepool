import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:appimagepool/utils/utils.dart';

final forceDarkThemeProvider = StateNotifierProvider<ForceDarkThemeNotifier, ThemeMode>((ref) {
  return ForceDarkThemeNotifier(
    ThemeMode.values.firstWhere((ele) => ele.index == (MyPrefs().prefs.getInt('forceDark') ?? 2)),
  );
});

class ForceDarkThemeNotifier extends StateNotifier<ThemeMode> {
  ForceDarkThemeNotifier(state) : super(state);

  toggle(Brightness brightness) {
    state = brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    MyPrefs().prefs.setInt('forceDark', state.index);
  }
}
