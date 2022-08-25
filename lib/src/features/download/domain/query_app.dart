import 'package:dio/dio.dart';

class QueryApp {
  final String name;
  final String url;
  final String downloadLocation;
  final CancelToken cancelToken;
  int actualBytes;
  int totalBytes;

  QueryApp({
    required this.name,
    required this.url,
    required this.cancelToken,
    required this.downloadLocation,
    required this.actualBytes,
    required this.totalBytes,
  });

  QueryApp copyWith({
    String? name,
    String? url,
    String? downloadLocation,
    CancelToken? cancelToken,
    int? actualBytes,
    int? totalBytes,
  }) =>
      QueryApp(
        name: name ?? this.name,
        url: url ?? this.url,
        cancelToken: cancelToken ?? this.cancelToken,
        downloadLocation: downloadLocation ?? this.downloadLocation,
        actualBytes: actualBytes ?? this.actualBytes,
        totalBytes: totalBytes ?? this.totalBytes,
      );
}
