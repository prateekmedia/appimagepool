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
    return (await Process.run(
      'flatpak-spawn',
      ['--host', './$program', 'flatpak-spawn'],
      workingDirectory: location,
      runInShell: true,
    ))
        .exitCode;
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
