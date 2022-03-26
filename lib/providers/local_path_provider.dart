import 'package:appimagepool/utils/constants.dart' as constants;
import 'package:appimagepool/utils/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localPathProvider =
    ChangeNotifierProvider<LocalPathNotifier>((ref) => LocalPathNotifier());

class LocalPathNotifier extends ChangeNotifier {
  String _applicationsDir =
      MyPrefs().prefs.getString('applicationsDir') ?? constants.applicationsDir;
  String _iconsDir =
      MyPrefs().prefs.getString('iconsDir') ?? constants.iconsDir;

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
