class ReleaseItem {
  final String name;
  final int size;
  final String url;

  ReleaseItem({required this.name, required this.size, required this.url});

  static ReleaseItem fromMap(Map map) => ReleaseItem(
        name: map['name'],
        size: map['size'] as int,
        url: map['browser_download_url'],
      );
}
