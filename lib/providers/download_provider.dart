import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:desktop_notifications/desktop_notifications.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/models/models.dart';

final downloadPathProvider = StateNotifierProvider<DownloadPathNotifier, String>((ref) {
  return DownloadPathNotifier(
      MyPrefs().prefs.getString('path') ?? path.join(Platform.environment['HOME']!, 'Applications') + '/');
});

class DownloadPathNotifier extends StateNotifier<String> {
  DownloadPathNotifier(state) : super(state);

  set update(String value) {
    state = value.endsWith('/') ? value : value + '/';
    MyPrefs().prefs.setString('path', state);
  }
}

final isDownloadingProvider = StateNotifierProvider<DownloadingStatusNotifier, int>((ref) {
  return DownloadingStatusNotifier(0);
});

class DownloadingStatusNotifier extends StateNotifier<int> {
  DownloadingStatusNotifier(state) : super(state);

  void increment() => state++;
  void decrement() => state--;
}

final downloadListProvider = StateNotifierProvider<DownloadNotifier, List<QueryApp>>((ref) {
  return DownloadNotifier(<QueryApp>[], ref);
});

class DownloadNotifier extends StateNotifier<List<QueryApp>> {
  final ProviderRefBase ref;
  DownloadNotifier(state, this.ref) : super(state);

  refresh() => state = state;

  addDownload({required String url, required String name}) async {
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
    state.insert(
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
    await Dio().download(url, location + name, onReceiveProgress: (recieved, total) {
      var item = state[state.indexWhere(
        (element) => (element.name == name) && (element.downloadLocation == location),
      )];
      item.actualBytes = recieved;
      item.totalBytes = total;
      ref.read(downloadListProvider.notifier).refresh();
    }, cancelToken: cancelToken).whenComplete(() async {
      ref.read(isDownloadingProvider.notifier).decrement();
      if (!cancelToken.isCancelled) {
        var client = NotificationsClient();
        await client.notify(
          "Download Complete!",
          body: name + " has been downloaded succesfully.",
          appName: "AppImage Pool",
          appIcon: "success",
        );
        await client.close();

        makeProgramExecutable(
          location: location,
          program: name,
        );
      }
    });
  }
}
