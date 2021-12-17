import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';
import 'package:appimagepool/utils/utils.dart';

final themeTypeProvider =
    StateNotifierProvider<ThemeTypeNotifier, ThemeType>((ref) {
  return ThemeTypeNotifier(
    MyPrefs().prefs.getInt('themeType') != null
        ? ThemeType.values.firstWhere(
            (element) => element.index == MyPrefs().prefs.getInt('themeType'))
        : ThemeType.auto,
  );
});

class ThemeTypeNotifier extends StateNotifier<ThemeType> {
  ThemeTypeNotifier(state) : super(state);

  set(ThemeType value) {
    state = value;
    MyPrefs().prefs.setInt('themeType', state.index);
  }
}
