import 'package:process_run/shell_run.dart';

bool doesContain(String any, List<String> val) {
  for (var item in val) {
    if (any.contains(item, 0)) return true;
  }
  return false;
}

makeProgramExecutable({required String location, required String program}) {
  Shell().run('chmod +x ${location + program}');
}

runProgram({required String location, required String program}) {
  Shell().run('type flatpak-spawn && '
      'flatpak-spawn --host ${location + program} ||' // Execute with flatpak if app is contanerized
      '${location + program}'); // Else execute normally
}
