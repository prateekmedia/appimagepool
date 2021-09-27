import 'dart:io';

bool doesContain(String any, List<String> val) {
  for (var item in val) {
    if (any.contains(item, 0)) return true;
  }
  return false;
}

makeProgramExecutable({required String location, required String program}) async {
  return (await Process.run(
    'chmod +x $program',
    [],
    workingDirectory: location,
  ))
      .exitCode;
}

runProgram({required String location, required String program}) async {
  return (await Process.run(
    'type flatpak-spawn && '
    'flatpak-spawn --host ./$program ||' // Execute with flatpak if app is contanerized
    './$program' // Else execute normally
    ,
    [],
    workingDirectory: location,
  ))
      .exitCode;
}
