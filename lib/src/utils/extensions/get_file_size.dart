import 'dart:math';

extension GetFileSize on int {
  String getFileSize() {
    if (this <= 0) return "0.0 KB";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return ((this / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }
}
