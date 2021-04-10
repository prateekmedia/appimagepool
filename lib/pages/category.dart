import 'package:appimagebrowser/pages/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class CategoryPage extends StatelessWidget {
  final List items;
  final String category;
  final ValueNotifier<ThemeMode> theme;

  CategoryPage(
      {required this.theme, required this.category, required this.items});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: aibAppBar(
      context,
      title: category,
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
      body: Scrollbar(
        child: GridView.count(
          padding: EdgeInsets.all(15),
          crossAxisCount: context.width > 1300
              ? 8
              : context.width > 1000
                  ? 6
                  : context.width > 600
                      ? 4
                      : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: items.map((item) {
            String name = item['name'] != null ? item['name'] : "N.A.";
            String desc =
                item['description'] != null ? item['description'] : "";
            String logoUrl =
                item['icons'] != null ? PREFIX_URL + item['icons'][0] : "";

            if (name.length > 12) name = name.substring(0, 12) + "...";
            Widget brokenImageWidget = SvgPicture.network(
              brokenImageUrl,
              color: context.isDark ? Colors.white : Colors.grey[800],
            );

            return Tooltip(
              message: desc,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AppPage(app: item))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: item['icons'] != null
                                ? (!logoUrl.endsWith('.svg'))
                                    ? Image.network(
                                        logoUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (c, w, i) => Center(
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 40, maxHeight: 40),
                                            child: LoadingIndicator(
                                              indicatorType: Indicator.orbit,
                                              color: context.isDark
                                                  ? Colors.white
                                                  : Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        errorBuilder: (c, w, i) =>
                                            brokenImageWidget,
                                      )
                                    : SvgPicture.network(logoUrl)
                                : brokenImageWidget),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        name,
                        style: context.textTheme.headline6!.copyWith(
                            color: context.isDark
                                ? Colors.white
                                : Colors.grey[900]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ));
  }
}
