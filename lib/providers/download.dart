import 'package:appimagepool/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final dLocationProvider =
    StateNotifierProvider<DownloadLocationNotifier, String>((ref) {
  late String path;
  () async {
    path = "/" +
        (await getApplicationDocumentsDirectory())
            .toString()
            .split('/')
            .toList()
            .sublist(1, 3)
            .join("/") +
        "/Applications/";
  };
  return DownloadLocationNotifier(path);
});

class DownloadLocationNotifier extends StateNotifier<String> {
  DownloadLocationNotifier(state) : super(state);

  set update(String value) => state = value;
}

final isDownloadingProvider =
    StateNotifierProvider<DownloadingStatusNotifier, int>((ref) {
  return DownloadingStatusNotifier(0);
});

class DownloadingStatusNotifier extends StateNotifier<int> {
  DownloadingStatusNotifier(state) : super(state);

  increment() => state++;
  decrement() => state--;
}

final downloadListProvider =
    StateNotifierProvider<DownloadNotifier, List<QueryApp>>((ref) {
  return DownloadNotifier(<QueryApp>[]);
});

class DownloadNotifier extends StateNotifier<List<QueryApp>> {
  DownloadNotifier(state) : super(state);

  refresh() => state = state;
}
