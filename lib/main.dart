import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'pages/pages.dart';
import 'utils/utils.dart';
import 'pages/category.dart';
import 'widgets/aibappbar.dart';

void main() {
  var theme = ValueNotifier(ThemeMode.dark);
  runApp(
    ValueListenableBuilder(
      valueListenable: theme,
      builder: (ctx, ThemeMode themeMode, ch) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.grey[800]),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        themeMode: themeMode,
        home: HomePage(theme: theme),
      ),
    ),
  );
}

class HomePage extends StatefulHookWidget {
  final ValueNotifier<ThemeMode> theme;

  HomePage({required this.theme});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    Map response =
        (await Dio().get("https://appimage.github.io/feed.json")).data;
    Map res = json.decode((await Dio().get(
            "https://gist.githubusercontent.com/prateekmedia/44c1ea7f7a627d284b9e50d47aa7200f/raw/cd4d9e14fdee79719eb9fb93e2fbb9a3c1d0ebb0/gistfile1.txt"))
        .data);
    List i = response['items'];
    // i.retainWhere((element) => i.indexOf(element) < 40);
    setState(() {
      featured = res;
      categories = i.groupBy((m) {
        List categori = m['categories'];
        List newList = [];
        categori.forEach((category) {
          if (category != null && category.length > 0) {
            if (doesContain(category, ['Video'])) {
              newList.add('Video');
            } else if (doesContain(category, ['Audio', 'Music'])) {
              newList.add('Audio');
            } else if (doesContain(category, ['Photo'])) {
              newList.add('Graphics');
            } else if (doesContain(category, ['KDE'])) {
              newList.add('Qt');
            } else if (doesContain(category, ['GNOME'])) {
              newList.add('GTK');
            } else if (doesContain(category, ['Chat', 'InstantMessag'])) {
              newList.add('Communication');
            } else if (doesContain(category, [
              'Application',
              'AdventureGame',
              'Astronomy',
              'Database',
              'Engineering',
              'HamRadio',
              'IDE',
              'News',
              'ProjectManagement',
              'Settings',
              'StrategyGame',
              'TextEditor',
              'TerminalEmulator',
              'Viewer',
              'WebDev',
              'WordProcessor',
              'X-Tool',
            ])) {
              newList.add('Others');
            } else {
              newList.add(category);
            }
          } else
            newList.add("Others");
        });
        return newList;
      });
    });
    // i.retainWhere((element) => i.indexOf(element) < 40);
    print(i.firstWhere((element) => element['name'].contains('Firefox', 0)));
  }

  Map? categories;
  Map? featured;

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _current = useState<int>(0);
    final _controller = CarouselController();
    return Scaffold(
      body: aibAppBar(
        context,
        title: "AppImageBrowser",
        trailing: [
          FloatingSearchBarAction.searchToClear(
            color: context.isDark ? Colors.white : Colors.grey[800],
          ),
          FloatingSearchBarAction.icon(
              icon: Icon(Icons.nightlight_round),
              onTap: () => {
                    widget.theme.value = widget.theme.value.index == 2
                        ? ThemeMode.light
                        : ThemeMode.dark
                  }),
        ],
        body: categories == null && featured == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Text(
                            "Featured Apps",
                            style: context.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2),
                          ),
                        ),
                        Stack(
                          children: [
                            CarouselSlider.builder(
                              itemCount: featured!.length,
                              itemBuilder: (context, index, i) {
                                var prefixNameUrl =
                                    featured!.values.toList()[index]['icons'] !=
                                                null &&
                                            (featured!.values.toList()[index]
                                                    ['icons']! as List)[0]
                                                .startsWith('http')
                                        ? ""
                                        : PREFIX_URL;
                                return GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => AppPage(
                                              app: featured!.values
                                                  .toList()[index]))),
                                  child: Stack(
                                    children: [
                                      if (featured!.values.toList()[index]
                                              ['screenshots'] !=
                                          null)
                                        Container(
                                            constraints:
                                                BoxConstraints.expand(),
                                            child: CachedNetworkImage(
                                              imageUrl: (featured!.values
                                                                  .toList()[index]
                                                              ['screenshots']!
                                                          as List)[0]
                                                      .startsWith('http')
                                                  ? (featured!.values
                                                              .toList()[index]
                                                          ['screenshots']!
                                                      as List)[0]
                                                  : PREFIX_URL +
                                                      (featured!.values
                                                                  .toList()[index]
                                                              ['screenshots']!
                                                          as List)[0],
                                              fit: BoxFit.cover,
                                            )),
                                      Center(
                                        child: Container(
                                          color: context.isDark
                                              ? Colors.grey.shade900
                                                  .withOpacity(0.5)
                                              : Colors.grey.shade300
                                                  .withOpacity(0.5),
                                          height: 400,
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 10,
                                                sigmaY: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: featured!.values
                                                                        .toList()[
                                                                    index][
                                                                'icons'] !=
                                                            null
                                                        ? (featured!.values.toList()[
                                                                            index]
                                                                        [
                                                                        'icons']!
                                                                    as List)[0]
                                                                .endsWith(
                                                                    '.svg')
                                                            ? SvgPicture
                                                                .network(
                                                                prefixNameUrl +
                                                                    (featured!
                                                                            .values
                                                                            .toList()[index]['icons']!
                                                                        as List)[0],
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl: prefixNameUrl +
                                                                    (featured!
                                                                            .values
                                                                            .toList()[index]['icons']!
                                                                        as List)[0],
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    (c, u) =>
                                                                        Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                                errorWidget: (c,
                                                                        w, i) =>
                                                                    SvgPicture
                                                                        .network(
                                                                  brokenImageUrl,
                                                                  color: context
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors.grey[
                                                                          800],
                                                                ),
                                                              )
                                                        : SvgPicture.network(
                                                            brokenImageUrl,
                                                            color: context
                                                                    .isDark
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[800],
                                                          ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "${featured!.values.toList()[index]['name']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: context
                                                          .textTheme.headline3,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              carouselController: _controller,
                              options: CarouselOptions(
                                  height: 400,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (idx, rsn) =>
                                      _current.value = idx),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 400,
                                child: IconButton(
                                  icon: Icon(Icons.chevron_left),
                                  onPressed: () => _controller.previousPage(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 400,
                                child: IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () => _controller.nextPage(),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(featured!.length, (index) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(index),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current.value == index
                                      ? (context.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(0.9)
                                      : (context.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text(
                            "Categories",
                            style: context.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2),
                          ),
                        ),
                        StaggeredGridView.countBuilder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          shrinkWrap: true,
                          primary: false,
                          crossAxisCount: 12,
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.fit(context.width > 1000
                                  ? 3
                                  : context.width > 600
                                      ? 4
                                      : context.width > 500
                                          ? 6
                                          : 12),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          itemCount: categories!.entries.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = categories!.entries.toList()[index];
                            return OutlinedButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => CategoryPage(
                                          theme: widget.theme,
                                          category: item.key ?? "N.A.",
                                          items: item.value))),
                              style: OutlinedButton.styleFrom(
                                  alignment: Alignment(-1, 0)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Text(
                                    "${item.key} (${item.value.length}) ",
                                    style: context.textTheme.headline6!
                                        .copyWith(fontSize: 17)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
