import 'package:appimagepool/src/features/app_info/domain/release_item.dart';

class DownloadItem {
  final DateTime date;
  final List<ReleaseItem> items;
  final String version;

  DownloadItem(
      {required this.items, required this.date, required this.version});

  static List<DownloadItem> fromItems(List items) => items
      .map(
        (e) => DownloadItem(
          items: (e['assets'] as List)
              .where((element) =>
                  element['name'].toLowerCase().endsWith('.appimage'))
              .map((e) => ReleaseItem.fromMap(e))
              .toList(),
          date: DateTime.parse(e['created_at']),
          version: e['name'] ?? e['tag_name'] ?? "",
        ),
      )
      .toList();
}
