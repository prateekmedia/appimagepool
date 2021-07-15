import 'package:appimagepool/widgets/gridOfApps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class CategoryPage extends HookWidget {
  final List items;
  final String category;
  final ValueNotifier<ThemeMode> theme;

  CategoryPage(
      {required this.theme, required this.category, required this.items});
  @override
  Widget build(BuildContext context) {
    final searchedTerm = useState<String>("");
    final itemsNew = items
        .where((element) => element['name']
            .toLowerCase()
            .contains(searchedTerm.value.toLowerCase(), 0))
        .toList();
    return Scaffold(
        body: aibAppBar(
      context,
      title: category,
      searchText: searchedTerm,
      trailing: [
        FloatingSearchBarAction.searchToClear(
          color: context.isDark ? Colors.white : Colors.grey[800],
        ),
        FloatingSearchBarAction.icon(
            icon: Icon(Icons.nightlight_round),
            onTap: () => {
                  theme.value =
                      theme.value.index == 2 ? ThemeMode.light : ThemeMode.dark
                }),
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
