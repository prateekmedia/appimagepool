import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:appimagepool/utils/utils.dart';

final forceDarkThemeProvider = StateNotifierProvider<ForceDarkThemeNotifier, bool>((ref) {
  return ForceDarkThemeNotifier(
    MyPrefs().prefs.getBool('forceDarkTheme') ?? false,
  );
});

class ForceDarkThemeNotifier extends StateNotifier<bool> {
  ForceDarkThemeNotifier(state) : super(state);

  toggle() {
    state = !state;
    MyPrefs().prefs.setBool('forceDarkTheme', state);
  }
}
