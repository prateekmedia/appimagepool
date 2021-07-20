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
}
