import 'dart:io';

import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/features/home/data/local_path_provider.dart';
import 'package:appimagepool/src/features/home/presentation/home/search_state.dart';
import 'package:appimagepool/src/features/home/presentation/installed/installed_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;

final installedViewStateProvider = ChangeNotifierProvider<InstalledViewState>(
  (ref) => InstalledViewState(
    ref.watch(localPathServiceProvider),
    ref.watch(searchStateProvider),
    ref.watch(downloadPathProvider),
    ref.watch(installedViewControllerProvider),
  ),
);

class InstalledViewState extends ChangeNotifier {
  final LocalPathService _localPathService;
  final String _searchedTerm;
  final String _downloadPath;
  final InstalledViewController _installedViewController;

  InstalledViewState(
    this._localPathService,
    this._searchedTerm,
    this._downloadPath,
    this._installedViewController,
  ) {
    refresh();
  }

  Future<void> loadAppImage() async {
    final file = await _installedViewController.loadAppImage();
    if (file != null) {
      listInstalled.add(file);
      notifyListeners();
    }
  }

  Future<void> integrateOrRemove({
    required FileSystemEntity file,
    required int index,
    required bool isIntegrated,
  }) async {
    await _installedViewController.integrateOrRemove(
      file: file,
      index: index,
      content: _content,
      isIntegrated: isIntegrated,
    );
    refresh();
  }

  Future<void> removeItem({
    required FileSystemEntity file,
    required int index,
    required bool isIntegrated,
  }) async {
    await _installedViewController.removeItem(
      file: file,
      index: index,
      content: _content,
      isIntegrated: isIntegrated,
    );

    listInstalled.removeAt(index);
    notifyListeners();
  }

  int integratedIndex(String path) {
    return _content.isNotEmpty
        ? _content.indexOf('aip_${p.basenameWithoutExtension(path)}')
        : -1;
  }

  void refresh() {
    _content = _localPathService.getDirectory;
    listInstalled = Directory(_downloadPath).existsSync()
        ? Directory(_downloadPath)
            .listSync()
            .where((element) => element.path.endsWith('.AppImage'))
            .where(
              (element) => p
                  .basename(element.path)
                  .toLowerCase()
                  .contains(_searchedTerm),
            )
            .toList()
        : [];
    notifyListeners();
  }

  List<String> _content = [];

  List<FileSystemEntity> listInstalled = [];
}
