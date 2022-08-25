import 'dart:io';

import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/features/home/data/portable_appimage_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final programUtilsProvider = Provider<ProgramUtils>((ref) {
  final portableAppImageNotifier = ref.read(portableAppImageProvider);
  final location = ref.watch(downloadPathProvider);
  return ProgramUtils(portableAppImageNotifier, location);
});

class ProgramUtils {
  ProgramUtils(this._portableAppImageNotifier, this._location);

  final PortableAppImageNotifier _portableAppImageNotifier;
  final String _location;

  static Future<int> makeProgramExecutable({
    required String location,
    required String program,
  }) async {
    return (await Process.run(
      'chmod',
      ['+x', program],
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
  }

  Future<int> runProgram({
    String? location,
    required String program,
  }) async {
    makeProgramExecutable(location: _location, program: program);

    var result = (await Process.run(
      'type',
      ['flatpak-spawn'],
      runInShell: true,
    ))
        .exitCode;

    if (result == 0) {
      // Execute with flatpak if app is contanerized

      if (_portableAppImageNotifier.isPortableHome) {
        (await Process.run(
          'flatpak-spawn',
          [
            '--host',
            './$program',
            "--appimage-portable-home",
          ],
          workingDirectory: location ?? _location,
          runInShell: true,
        ))
            .exitCode;
      }
      if (_portableAppImageNotifier.isPortableConfig) {
        (await Process.run(
          'flatpak-spawn',
          [
            '--host',
            './$program',
            "--appimage-portable-config",
          ],
          workingDirectory: location ?? _location,
          runInShell: true,
        ))
            .exitCode;
      }
      return (await Process.run(
        'flatpak-spawn',
        [
          '--host',
          './$program',
        ],
        workingDirectory: location ?? _location,
        runInShell: true,
      ))
          .exitCode;
    } else {
      // Else execute normally
      if (_portableAppImageNotifier.isPortableHome) {
        (await Process.run(
          './$program',
          [
            "--appimage-portable-home",
          ],
          workingDirectory: location ?? _location,
          runInShell: true,
        ))
            .exitCode;
      }
      if (_portableAppImageNotifier.isPortableConfig) {
        (await Process.run(
          './$program',
          [
            "--appimage-portable-config",
          ],
          workingDirectory: location ?? _location,
          runInShell: true,
        ))
            .exitCode;
      }
      return (await Process.run(
        './$program',
        [],
        workingDirectory: location ?? _location,
        runInShell: true,
      ))
          .exitCode;
    }
  }
}
