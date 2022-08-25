import 'dart:io';

import 'package:appimagepool/src/features/home/data/appimage_tools_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final installedViewControllerProvider =
    Provider<InstalledViewController>((ref) {
  return InstalledViewController(
    ref.watch(
      appimageToolsRepositoryProvider,
    ),
  );
});

class InstalledViewController {
  InstalledViewController(this._appimageToolsRepository);

  final AppimageToolsRepository _appimageToolsRepository;

  List<String> content = [];

  Future<void> integrateOrRemove({
    required FileSystemEntity file,
    required int index,
    required bool isIntegrated,
  }) async =>
      await _appimageToolsRepository.integrateOrRemove(
        name: content[index],
        file: file,
        isIntegrated: isIntegrated,
      );

  Future<void> removeItem({
    required FileSystemEntity file,
    required int index,
    required bool isIntegrated,
  }) async =>
      await _appimageToolsRepository.removeItem(
        isIntegrated: isIntegrated,
        name: content[index],
        file: file,
      );
}
