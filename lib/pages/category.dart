import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/widgets/gridOfApps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class CategoryPage extends HookConsumerWidget {
  final List items;
  final String category;
  final ValueNotifier<ThemeMode> theme;

  CategoryPage(
      {required this.theme, required this.category, required this.items});
  @override
  Widget build(BuildContext context, ref) {
    final searchedTerm = useState<String>("");
    final itemsNew = items
        .where((element) => element['name']
            .toLowerCase()
            .contains(searchedTerm.value.toLowerCase(), 0))
        .toList();
    List<QueryApp> listDownloads = ref.watch(downloadListProvider);
    var downloading = ref.watch(isDownloadingProvider);
    return Scaffold(
        body: aibAppBar(
      context,
      title: category,
      leading: [
        FloatingSearchBarAction(
          showIfOpened: false,
          showIfClosed: true,
          builder: (context, animation) {
            final bar = FloatingSearchAppBar.of(context)!;

            return ValueListenableBuilder<String>(
              valueListenable: bar.queryNotifer,
              builder: (context, query, _) {
                final isEmpty = query.isEmpty;

                return SearchToClear(
                  isEmpty: isEmpty,
                  size: 24,
                  color: context.isDark ? Colors.white : Colors.grey[800],
                  duration: Duration(milliseconds: 900) * 0.5,
                  onTap: () {
                    if (!isEmpty) {
                      bar.clear();
                    } else {
                      bar.isOpen =
                          !bar.isOpen || (!bar.hasFocus && bar.isAlwaysOpened);
                    }
                  },
                );
              },
            );
          },
        ),
      ],
      searchText: searchedTerm,
      trailing: [
        FloatingSearchBarAction.icon(
            icon: Icon(Icons.nightlight_round),
            onTap: () => {
                  theme.value =
                      theme.value.index == 2 ? ThemeMode.light : ThemeMode.dark
                }),
        if (listDownloads.length > 0)
          downloadButton(context, listDownloads, downloading),
      ],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: GridOfApps(itemList: itemsNew),
        ),
      ),
    ));
  }
}
