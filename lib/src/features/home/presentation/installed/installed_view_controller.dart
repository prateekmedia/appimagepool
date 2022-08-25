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

  Future<void> integrateOrRemove({
    required FileSystemEntity file,
    required List<String> content,
    required int index,
    required bool isIntegrated,
  }) async =>
      await _appimageToolsRepository.integrateOrRemove(
        content: content,
        index: index,
        file: file,
        isIntegrated: isIntegrated,
      );

  Future<void> removeItem({
    required FileSystemEntity file,
    required List<String> content,
    required int index,
    required bool isIntegrated,
  }) async =>
      await _appimageToolsRepository.removeItem(
        isIntegrated: isIntegrated,
        content: content,
        index: index,
        file: file,
      );
}
