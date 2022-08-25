import 'dart:io';

import 'package:appimagepool/src/constants/constants.dart' as constants;
import 'package:appimagepool/src/utils/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;

final localPathServiceProvider =
    Provider<LocalPathService>((ref) => LocalPathService(ref));

class LocalPathService {
  LocalPathService(this.ref);

  final Ref ref;

  String _applicationsDir =
      MyPrefs().prefs.getString('applicationsDir') ?? constants.applicationsDir;
  String _iconsDir =
      MyPrefs().prefs.getString('iconsDir') ?? constants.iconsDir;

  dynamic get getDirectory {
    return Directory(ref.read(localPathServiceProvider).applicationsDir)
            .existsSync()
        ? Directory(ref.read(localPathServiceProvider).applicationsDir)
            .listSync(recursive: false)
            .map((event) => path.basenameWithoutExtension(event.path))
            .toList()
        : [];
  }

  String get applicationsDir => _applicationsDir;
  String get iconsDir => _iconsDir;

  set applicationsDir(String appDir) {
    _applicationsDir = appDir;
    MyPrefs().prefs.setString('applicationsDir', _applicationsDir);
  }

  set iconsDir(String icnDir) {
    _iconsDir = icnDir;
    MyPrefs().prefs.setString('iconsDir', _iconsDir);
  }
}
