import 'dart:async';

import 'package:appimagepool/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

abstract class ConfigurationImpl {
  Future init();
}

class Configuration extends ConfigurationImpl {
  static const windowOptions = WindowOptions(
    size: Size(1000, 600),
    minimumSize: Size(400, 450),
    skipTaskbar: false,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'AppImage Pool',
  );

  static Future<void> initWindowManager() async {
    await windowManager.ensureInitialized();

    unawaited(
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setAsFrameless();
        await windowManager.show();
        await windowManager.focus();
      }),
    );
  }

  @override
  init() async {
    await initWindowManager();
    await MyPrefs().init();
  }
}
