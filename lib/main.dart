import 'dart:convert';
import 'dart:ui';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/widgets/grid_of_apps.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'utils/utils.dart';
import 'widgets/widgets.dart';

void main() {
  var theme = ValueNotifier(ThemeMode.dark);
  runApp(
    ProviderScope(
      child: ValueListenableBuilder(
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
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          themeMode: themeMode,
          home: HomePage(theme: theme),
        ),
      ),
    ),
  );
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1280, 720);
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Pool";
    win.show();
  });
}

class HomePage extends StatefulHookWidget {
  final ValueNotifier<ThemeMode> theme;

  const HomePage({Key? key, required this.theme}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    Map response =
        (await Dio().get("https://appimage.github.io/feed.json")).data;
    Map res = json.decode((await Dio().get(
            "https://gist.githubusercontent.com/prateekmedia/44c1ea7f7a627d284b9e50d47aa7200f/raw/gistfile1.txt"))
        .data);
    List i = response['items'];
    setState(() {
      featured = res;
      allItems = i;
      categories = i.groupBy((m) {
        List categori = m['categories'];
        List newList = [];
        for (var category in categori) {
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
            } else if (doesContain(category, [
              'Application',
              'AdventureGame',
              'Astronomy',
              'Chat',
              'InstantMessag',
              'Database',
              'Engineering',
              'Electronics',
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
          } else {
            newList.add("Others");
          }
        }
        return newList;
      });
    });
  }

  Map? categories;
  List? allItems;
  Map? featured;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchedTerm = useState<String>("");
    final _current = useState<int>(0);
    var itemsNew = allItems != null
        ? allItems!
            .where((element) => element['name']
                .toLowerCase()
                .contains(searchedTerm.value.toLowerCase(), 0))
            .toList()
        : [];
    return Scaffold(
      body: Consumer(
        builder: (ctx, ref, _) {
          List<QueryApp> listDownloads = ref.watch(downloadListProvider);
          var downloading = ref.watch(isDownloadingProvider);
          return aibAppBar(
            context,
            title: '',
            searchText: searchedTerm,
            leading: [
              FloatingSearchBarAction(
                child: AppPopupMenu(
                  menuItems: const [
                    PopupMenuItem(
                      child: Text("About Appimages"),
                      value: "appimage",
                    ),
                    PopupMenuItem(
                      child: Text("About the App"),
                      value: "app",
                    ),
                  ],
                  icon: const Icon(Icons.menu),
                  onSelected: (val) {
                    switch (val) {
                      case 'app':
                        showDialog(
                          context: context,
                          builder: (ctx) => aboutDialog(ctx),
                        );
                        break;
                      case 'appimage':
                        showDialog(
                          context: context,
                          builder: (ctx) => appimageAboutDialog(ctx),
                        );
                        break;
                    }
                  },
                  elevation: 3,
                  offset: const Offset(0, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              FloatingSearchBarAction(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Pool", style: context.textTheme.headline6),
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                color: context.isDark ? Colors.white : Colors.grey[800],
              ),
            ],
            trailing: [
              Hero(
                tag: 'theme-switch',
                child: FloatingSearchBarAction.icon(
                    icon: const Icon(Icons.nightlight_round),
                    onTap: () => {
                          widget.theme.value = widget.theme.value.index == 2
                              ? ThemeMode.light
                              : ThemeMode.dark
                        }),
              ),
              if (listDownloads.isNotEmpty)
                downloadButton(context, listDownloads, downloading),
            ],
            body: categories == null && featured == null
                ? const Center(child: CircularProgressIndicator())
                : searchedTerm.value.trim().isEmpty
                    ? SingleChildScrollView(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  child: Text(
                                    "Featured Apps",
                                    style: context.textTheme.headline6!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    CarouselSlider.builder(
                                      itemCount: featured!.length,
                                      itemBuilder: (context, index, i) {
                                        App featuredApp = App.fromItem(
                                            featured!.values.toList()[index]);
                                        return GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (ctx) => AppPage(
                                                      app: featuredApp))),
                                          child: Stack(
                                            children: [
                                              if (featuredApp.screenshotsUrl !=
                                                  null)
                                                Container(
                                                    constraints:
                                                        const BoxConstraints
                                                            .expand(),
                                                    child: CachedNetworkImage(
                                                      imageUrl: featuredApp
                                                              .screenshotsUrl![
                                                                  0]
                                                              .startsWith(
                                                                  'http')
                                                          ? (featuredApp
                                                                  .screenshotsUrl!)[
                                                              0]
                                                          : prefixUrl +
                                                              featuredApp
                                                                  .screenshotsUrl![0],
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            child: featuredApp
                                                                        .iconUrl !=
                                                                    null
                                                                ? featuredApp
                                                                        .iconUrl!
                                                                        .endsWith(
                                                                            '.svg')
                                                                    ? SvgPicture
                                                                        .network(
                                                                        featuredApp
                                                                            .iconUrl!,
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            featuredApp.iconUrl!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (c, u) =>
                                                                                const Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                        errorWidget: (c,
                                                                                w,
                                                                                i) =>
                                                                            SvgPicture.network(
                                                                          brokenImageUrl,
                                                                          color: context.isDark
                                                                              ? Colors.white
                                                                              : Colors.grey[800],
                                                                        ),
                                                                      )
                                                                : SvgPicture
                                                                    .network(
                                                                    brokenImageUrl,
                                                                    color: context.isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .grey[800],
                                                                  ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              featuredApp.name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: context
                                                                  .textTheme
                                                                  .headline3,
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
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (idx, rsn) =>
                                              _current.value = idx),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        height: 400,
                                        child: IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: () =>
                                              _controller.previousPage(),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        height: 400,
                                        child: IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: () =>
                                              _controller.nextPage(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      List.generate(featured!.length, (index) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(index),
                                      child: Container(
                                        width: 10.0,
                                        height: 10.0,
                                        padding: const EdgeInsets.all(4),
                                        margin: const EdgeInsets.symmetric(
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
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: Text(
                                    "Categories",
                                    style: context.textTheme.headline6!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2),
                                  ),
                                ),
                                StaggeredGridView.countBuilder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item =
                                        categories!.entries.toList()[index];
                                    return OutlinedButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => CategoryPage(
                                                  theme: widget.theme,
                                                  category: item.key ?? "N.A.",
                                                  items: item.value))),
                                      style: OutlinedButton.styleFrom(
                                          alignment: const Alignment(-1, 0)),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
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
                      )
                    : GridOfApps(itemList: itemsNew),
          );
        },
      ),
    );
  }
}
