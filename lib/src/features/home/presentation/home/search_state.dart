import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchStateProvider = StateNotifierProvider<SearchState, String>((ref) {
  return SearchState('');
});

class SearchState extends StateNotifier<String> {
  SearchState(String value) : super(value);
}
