import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/utils.dart';

final viewTypeProvider = StateNotifierProvider<ViewTypeNotifier, int>((ref) {
  return ViewTypeNotifier(MyPrefs().prefs.getInt('viewType') ?? 0);
});

class ViewTypeNotifier extends StateNotifier<int> {
  ViewTypeNotifier(state) : super(state);

  update() {
    state = state == 1 ? 0 : state + 1;
    MyPrefs().prefs.setInt('viewType', state);
  }
}
