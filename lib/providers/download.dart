import 'package:appimagepool/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isDownloadingProvider =
    StateNotifierProvider<DownloadingStatusNotifier, bool>((ref) {
  return DownloadingStatusNotifier(false);
});

class DownloadingStatusNotifier extends StateNotifier<bool> {
  DownloadingStatusNotifier(state) : super(state);

  toggleValue() {
    state = !state;
  }
}

final downloadListProvider =
    StateNotifierProvider<DownloadNotifier, List<QueryApp>>((ref) {
  return DownloadNotifier(<QueryApp>[]);
});

class DownloadNotifier extends StateNotifier<List<QueryApp>> {
  DownloadNotifier(state) : super(state);
}
