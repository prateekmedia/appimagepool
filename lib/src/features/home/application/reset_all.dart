import 'package:appimagepool/src/features/home/data/portable_appimage_provider.dart';
import 'package:appimagepool/src/features/theme/data/theme_mode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view_type.dart';

final resetSettingsProvider = Provider<ResetSettings>((ref) {
  return ResetSettings(
    ref.read(portableAppImageProvider.notifier),
    ref.read(themeModeProvider.notifier),
    ref.read(viewTypeProvider.notifier),
  );
});

class ResetSettings {
  ResetSettings(
    this._portableAppImageNotifier,
    this._themeModeNotifier,
    this._viewTypeNotifier,
  );

  final PortableAppImageNotifier _portableAppImageNotifier;
  final ThemeModeNotifier _themeModeNotifier;
  final ViewTypeNotifier _viewTypeNotifier;

  reset() {
    _themeModeNotifier.reset();
    _portableAppImageNotifier.reset();
    _viewTypeNotifier.reset();
  }
}
