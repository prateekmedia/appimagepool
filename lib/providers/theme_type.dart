import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';

final themeTypeProvider =
    StateNotifierProvider<ThemeTypeNotifier, ThemeType>((ref) {
  return ThemeTypeNotifier(ThemeType.adwaita);
});

class ThemeTypeNotifier extends StateNotifier<ThemeType> {
  ThemeTypeNotifier(state) : super(state);

  set(ThemeType value) {
    state = value;
  }
}
