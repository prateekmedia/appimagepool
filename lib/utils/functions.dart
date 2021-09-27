import 'dart:io';

bool doesContain(String any, List<String> val) {
  for (var item in val) {
    if (any.contains(item, 0)) return true;
  }
  return false;
}

makeProgramExecutable({required String location, required String program}) async {
  return (await Process.run(
    'chmod',
    ['+x', program],
    workingDirectory: location,
    runInShell: true,
  ))
      .exitCode;
}

runProgram({required String location, required String program}) async {
  makeProgramExecutable(location: location, program: program);

  var result = (await Process.run(
    'type',
    ['flatpak-spawn'],
    runInShell: true,
  ))
      .exitCode;

  if (result == 0) {
    // Execute with flatpak if app is contanerized
    var _result = (await Process.run(
      'flatpak-spawn',
      [
        '--host',
        './$program',
      ],
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
    if (_result == 0) {
      print("First strategy worked");
      return result;
    } else {
      var __result = (await Process.run(
        'flatpak-spawn',
        [
          '--host',
          location + (location.endsWith('/') ? '' : '/') + './$program',
        ],
        runInShell: true,
      ))
          .exitCode;
      if (__result == 0) {
        print("Second strategy worked");
        return __result;
      } else {
        print('Final Strategy');
        return (await Process.run(
          'flatpak-spawn',
          [
            '--host',
            'sh',
            '-c',
            location + (location.endsWith('/') ? '' : '/') + './$program',
          ],
          runInShell: true,
        ))
            .exitCode;
      }
    }
  } else {
    // Else execute normally
    return (await Process.run(
      './$program',
      [],
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
  }
}
