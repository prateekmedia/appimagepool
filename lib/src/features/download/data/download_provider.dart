import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:desktop_notifications/desktop_notifications.dart';

import 'package:appimagepool/src/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';

import '../domain/query_app.dart';

final downloadPathProvider =
    StateNotifierProvider<DownloadPathNotifier, String>((ref) {
  return DownloadPathNotifier(MyPrefs().prefs.getString('path') ??
      path.join(Platform.environment['HOME']!, 'Applications') + '/');
});

class DownloadPathNotifier extends StateNotifier<String> {
  DownloadPathNotifier(state) : super(state);

  set update(String? value) {
    if (value != null) {
      state = value.endsWith('/') ? value : value + '/';
      MyPrefs().prefs.setString('path', state);
    }
  }
}

final downloadProvider =
    ChangeNotifierProvider<DownloadingStatusNotifier>((ref) {
  return DownloadingStatusNotifier(ref);
});

class DownloadingStatusNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;
  DownloadingStatusNotifier(this.ref);
  refresh() => notifyListeners();

  int downloadCount = 0;

  void increment() {
    downloadCount++;
    refresh();
  }

  void decrement() {
    downloadCount--;
    refresh();
  }

  List<QueryApp> downloadList = [];

  addDownload(
      {required String url,
      required String name,
      required BuildContext context}) async {
    var location = ref.watch(downloadPathProvider);
    if (!Directory(location).existsSync()) {
      try {
        Directory(location).createSync();
      } catch (e) {
        debugPrint(e.toString());
        return;
      }
    }
    increment();
    final CancelToken cancelToken = CancelToken();
    downloadList.insert(
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
    refresh();
    await Dio().download(url, location + name,
        onReceiveProgress: (recieved, total) {
      var item = downloadList[downloadList.indexWhere(
        (element) =>
            (element.name == name) && (element.downloadLocation == location),
      )];
      item.actualBytes = recieved;
      item.totalBytes = total;
      refresh();
    }, cancelToken: cancelToken).whenComplete(() async {
      decrement();
      if (!cancelToken.isCancelled) {
        if (Platform.isLinux) {
          var client = NotificationsClient();
          await client.notify(
            AppLocalizations.of(context)!.downloadCompleted,
            body:
                "$name ${AppLocalizations.of(context)!.hasBeenDownloadedSuccessfully}",
            appName: "AppImage Pool",
            appIcon: "success",
          );
          await client.close();
        }

        ProgramUtils.makeProgramExecutable(
          location: location,
          program: name,
        );
      }
    });
  }
}
