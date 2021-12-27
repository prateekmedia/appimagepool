import 'dart:io';

import 'package:appimagepool/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool doesContain(String any, List<String> val) {
  for (var item in val) {
    if (any.contains(item, 0)) return true;
  }
  return false;
}

makeProgramExecutable(
    {required String location, required String program}) async {
  return (await Process.run(
    'chmod',
    ['+x', program],
    workingDirectory: location,
    runInShell: true,
  ))
      .exitCode;
}

runProgram(WidgetRef ref,
    {required String location, required String program}) async {
  makeProgramExecutable(location: location, program: program);

  var result = (await Process.run(
    'type',
    ['flatpak-spawn'],
    runInShell: true,
  ))
      .exitCode;

  if (result == 0) {
    // Execute with flatpak if app is contanerized

    if (ref.read(portableAppImageProvider).isPortableHome) {
      (await Process.run(
        'flatpak-spawn',
        [
          '--host',
          './$program',
          "--appimage-portable-home",
        ],
        workingDirectory: location,
        runInShell: true,
      ))
          .exitCode;
    }
    if (ref.read(portableAppImageProvider).isPortableConfig) {
      (await Process.run(
        'flatpak-spawn',
        [
          '--host',
          './$program',
          "--appimage-portable-config",
        ],
        workingDirectory: location,
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
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
  } else {
    // Else execute normally
    if (ref.read(portableAppImageProvider).isPortableHome) {
      (await Process.run(
        './$program',
        [
          "--appimage-portable-home",
        ],
        workingDirectory: location,
        runInShell: true,
      ))
          .exitCode;
    }
    if (ref.read(portableAppImageProvider).isPortableConfig) {
      (await Process.run(
        './$program',
        [
          "--appimage-portable-config",
        ],
        workingDirectory: location,
        runInShell: true,
      ))
          .exitCode;
    }
    return (await Process.run(
      './$program',
      [],
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
  }
}
