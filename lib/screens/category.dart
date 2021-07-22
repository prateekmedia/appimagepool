import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/widgets/grid_of_apps.dart';
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

  const CategoryPage(
      {Key? key,
      required this.theme,
      required this.category,
      required this.items})
      : super(key: key);
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
      title: '',
      leading: [
        FloatingSearchBarAction(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              category,
              style: context.textTheme.headline6,
            ),
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          color: context.isDark ? Colors.white : Colors.grey[800],
        ),
      ],
      searchText: searchedTerm,
      trailing: [
        Hero(
          tag: 'theme-switch',
          child: FloatingSearchBarAction.icon(
              icon: const Icon(Icons.nightlight_round),
              onTap: () => {
                    theme.value = theme.value.index == 2
                        ? ThemeMode.light
                        : ThemeMode.dark
                  }),
        ),
        if (listDownloads.isNotEmpty)
          downloadButton(context, listDownloads, downloading),
      ],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridOfApps(itemList: itemsNew),
        ),
      ),
    ));
  }
}
