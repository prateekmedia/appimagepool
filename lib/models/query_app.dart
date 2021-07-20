import 'package:dio/dio.dart';

class QueryApp {
  final String name;
  final String iconUrl;
  final String url;
  final String downloadLocation;
  final CancelToken cancelToken;
  int actualBytes;
  int totalBytes;

  QueryApp(
    this.name,
    this.iconUrl,
    this.url,
    this.cancelToken,
    this.downloadLocation,
    this.actualBytes,
    this.totalBytes,
  );
}
