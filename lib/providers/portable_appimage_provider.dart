import 'package:appimagepool/utils/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final portableAppImageProvider =
    ChangeNotifierProvider<PortableAppImageNotifier>(
        (ref) => PortableAppImageNotifier(ref));

class PortableAppImageNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;
  PortableAppImageNotifier(this.ref);
  refresh() => notifyListeners();

  bool _isPortableHome = MyPrefs().prefs.getBool('is_portable_home') ?? false;
  bool _isPortableConfig =
      MyPrefs().prefs.getBool('is_portablec_onfig') ?? false;

  bool get isPortableHome => _isPortableHome;
  bool get isPortableConfig => _isPortableConfig;

  set isPortableHome(bool newVal) {
    _isPortableHome = newVal;
    MyPrefs().prefs.setBool('is_portable_home', newVal);
    refresh();
  }

  set isPortableConfig(bool newVal) {
    _isPortableConfig = newVal;
    MyPrefs().prefs.setBool('is_portablec_onfig', newVal);
    refresh();
  }

  reset() {
    _isPortableHome = false;
    _isPortableConfig = false;
    MyPrefs().prefs.remove('is_portable_home');
    MyPrefs().prefs.remove('is_portablec_onfig');
  }
}
