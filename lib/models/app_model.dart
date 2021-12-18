import 'package:appimagepool/utils/utils.dart';

class App {
  final String? name;
  final String? description;
  final String? iconUrl;
  final List? screenshotsUrl;
  final List? url;
  final List? authors;
  final String? license;
  final List? categories;

  App({
    required this.name,
    this.description,
    this.iconUrl,
    this.screenshotsUrl,
    this.categories,
    this.url,
    this.authors,
    this.license,
  });

  static App fromItem(item) {
    return App(
      name: item['name'].replaceAll('_', ' ').replaceAll('-', ' '),
      description: item['description'],
      iconUrl: item['icons'] != null
          ? item['icons'][0].startsWith('http')
              ? item['icons'][0]
              : prefixUrl + item['icons'][0]
          : null,
      categories: item['categories'],
      screenshotsUrl: item['screenshots'],
      url: item['links'],
      authors: item['authors'],
      license: item['license'],
    );
  }
}
