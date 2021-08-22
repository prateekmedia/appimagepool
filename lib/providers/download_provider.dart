import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:process_run/shell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

import '../models/models.dart';

final downloadPathProvider =
    StateNotifierProvider<DownloadPathNotifier, String>((ref) {
  return DownloadPathNotifier(
      xdg.configHome.path.replaceAll('.config', 'Applications/'));
});

class DownloadPathNotifier extends StateNotifier<String> {
  DownloadPathNotifier(state) : super(state);

  set update(String value) => state = value.endsWith('/') ? value : value + '/';
}

final isDownloadingProvider =
    StateNotifierProvider<DownloadingStatusNotifier, int>((ref) {
  return DownloadingStatusNotifier(0);
});

class DownloadingStatusNotifier extends StateNotifier<int> {
  DownloadingStatusNotifier(state) : super(state);

  void increment() => state++;
  void decrement() => state--;
}

final downloadListProvider =
    StateNotifierProvider<DownloadNotifier, List<QueryApp>>((ref) {
  return DownloadNotifier(<QueryApp>[], ref);
});

class DownloadNotifier extends StateNotifier<List<QueryApp>> {
  final ProviderRefBase ref;
  DownloadNotifier(state, this.ref) : super(state);

  refresh() => state = state;

  addDownload({required String url, required String name}) async {
    final List<QueryApp> listDownloads = ref.read(downloadListProvider);
    var location = ref.watch(downloadPathProvider);
    if (!Directory(location).existsSync()) {
      try {
        Directory(location).createSync();
      } catch (e) {
        debugPrint(e.toString());
        return;
      }
    }
    ref.watch(isDownloadingProvider.notifier).increment();
    final CancelToken cancelToken = CancelToken();
    listDownloads.insert(
      0,
      QueryApp(
        name: name,
        url: url,
        cancelToken: cancelToken,
        downloadLocation: location,
        actualBytes: 0,
        totalBytes: 0,
      ),
    );
    ref.read(downloadListProvider.notifier).refresh();
    await Dio().download(url, location + name,
        onReceiveProgress: (recieved, total) {
      var item = listDownloads[
          listDownloads.indexWhere((element) => element.name == name)];
      item.actualBytes = recieved;
      item.totalBytes = total;
      ref.read(downloadListProvider.notifier).refresh();
    }, cancelToken: cancelToken).whenComplete(() {
      ref.read(isDownloadingProvider.notifier).decrement();

      var shell = Shell().cd(location);
      shell.run('chmod +x ' + name);
    });
  }
}
