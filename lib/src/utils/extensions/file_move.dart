import 'dart:io';

extension FileMoveExt on FileSystemEntity {
  File get toFile => File(path);

  Future moveFile(String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await toFile.rename(newPath);
    } on FileSystemException catch (_) {
      // if rename fails, copy the source file and then delete it
      final newFile = await toFile.copy(newPath);
      await delete();
      return newFile;
    }
  }
}
