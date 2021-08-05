import 'dart:convert';
import 'dart:math';
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
import 'package:flutter/services.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'utils/utils.dart';
import 'widgets/widgets.dart';

void main() {
  var theme = ValueNotifier(ThemeMode.system);
  runApp(
    ProviderScope(
      child: ValueListenableBuilder(
        valueListenable: theme,
        builder: (ctx, ThemeMode themeMode, ch) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            canvasColor: AdwaitaLightColors.canvas,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blue[700],
            canvasColor: AdwaitaDarkColors.canvas,
          ),
          themeMode: themeMode,
          home: HomePage(theme: theme),
        ),
      ),
    ),
  );
  doWhenWindowReady(() {
    final win = appWindow;
    win.size = const Size(1280, 720);
    win.alignment = Alignment.center;
    win.title = "Pool";
    win.show();
  });
}

class HomePage extends StatefulHookWidget {
  final ValueNotifier<ThemeMode> theme;
  // bool _isConnected = true;

  const HomePage({Key? key, required this.theme}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   setState(() => _isConnected = false);
    //   return null;
    // }
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
    final _carouselIndex = useState<int>(0);
    final _navrailIndex = useState<int>(0);
    final toggleSearch = useState<bool>(false);
    var itemsNew = allItems != null && _navrailIndex.value == 0
        ? allItems!
            .where((element) => element['name']
                .toLowerCase()
                .contains(searchedTerm.value.toLowerCase(), 0))
            .toList()
        : allItems != null && _navrailIndex.value > 0 && categories != null
            ? (categories!.entries.toList()[_navrailIndex.value - 1].value
                    as List)
                .where((element) => element['name']
                    .toLowerCase()
                    .contains(searchedTerm.value.toLowerCase(), 0))
                .toList()
            : [];

    switchSearchBar() {
      if (categories == null && featured == null) return null;
      searchedTerm.value = '';
      toggleSearch.value = !toggleSearch.value;
    }

    return Scaffold(
      body: Consumer(
        builder: (ctx, ref, _) {
          List<QueryApp> listDownloads = ref.watch(downloadListProvider);
          var downloading = ref.watch(isDownloadingProvider);
          return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.runtimeType == RawKeyDownEvent &&
                  event.isControlPressed &&
                  event.logicalKey.keyId == 102) switchSearchBar();
            },
            child: aibAppBar(
              context,
              title: '',
              leading: [
                Container(
                  padding: const EdgeInsets.only(right: 4),
                  width: context.width >= 640 ? 242 : null,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdwaitaHeaderButton(
                          icon: Icons.search,
                          onTap: switchSearchBar,
                        ),
                        GestureDetector(
                          onTap: () => _navrailIndex.value = 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 26.0),
                            child: Center(
                                child: Text(
                              "Pool",
                              style: context.textTheme.headline6!
                                  .copyWith(fontSize: 17),
                            )),
                          ),
                        ),
                        CustomAdwaitaHeaderButton(
                          child: AppPopupMenu(
                            menuItems: [
                              PopupMenuItem(
                                child: Text(
                                  "About Appimages",
                                  style: context.textTheme.bodyText1,
                                ),
                                value: "appimage",
                              ),
                              PopupMenuItem(
                                child: Text(
                                  "About the App",
                                  style: context.textTheme.bodyText1,
                                ),
                                value: "app",
                              ),
                            ],
                            color: context.theme.canvasColor,
                            icon: const Icon(Icons.menu, size: 17),
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
                            offset: const Offset(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ]),
                ),
                if (context.width >= 640)
                  VerticalDivider(
                    width: 1,
                    color: context.isDark ? Colors.grey[800] : Colors.grey[400],
                  ),
              ],
              trailing: [
                Hero(
                  tag: 'theme-switch',
                  child: AdwaitaHeaderButton(
                    icon: Icons.nightlight_round,
                    onTap: () => {
                      widget.theme.value = widget.theme.value.index == 2
                          ? ThemeMode.light
                          : ThemeMode.dark
                    },
                  ),
                ),
                if (listDownloads.isNotEmpty)
                  downloadButton(context, listDownloads, downloading),
              ],
              body: categories == null && featured == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context.width >= 640)
                          Container(
                            // color: context.isDark
                            //     ? AdwaitaDarkColors.headerBarBackgroundBottom
                            //     : AdwaitaLightColors.headerBarBackgroundBottom,
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      gtkSidebarItem(
                                          context, _navrailIndex.value == 0,
                                          label: "Explore",
                                          icon: Icons.explore, onSelected: () {
                                        _navrailIndex.value = 0;
                                      }),
                                      for (var category in categories!.entries
                                          .toList()
                                          .asMap()
                                          .entries)
                                        gtkSidebarItem(
                                            context,
                                            _navrailIndex.value ==
                                                category.key + 1,
                                            label: category.value.key,
                                            icon: categoryIcons.containsKey(
                                                    category.value.key)
                                                ? categoryIcons[
                                                    category.value.key]!
                                                : Icons.help, onSelected: () {
                                          _navrailIndex.value =
                                              category.key + 1;
                                        }),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  width: 1,
                                  color: context.isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              if (toggleSearch.value)
                                Container(
                                  color: context.isDark
                                      ? AdwaitaDarkColors
                                          .headerBarBackgroundBottom
                                      : AdwaitaLightColors
                                          .headerBarBackgroundBottom,
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 260),
                                      height: toggleSearch.value ? 52 : 0,
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 450),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: RawKeyboardListener(
                                          child: TextField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            autofocus: true,
                                            cursorHeight: 20,
                                            onChanged: (query) {
                                              searchedTerm.value = query;
                                            },
                                            style: context.textTheme.bodyText1!
                                                .copyWith(fontSize: 14),
                                            decoration: InputDecoration(
                                              fillColor:
                                                  context.theme.canvasColor,
                                              contentPadding:
                                                  const EdgeInsets.only(top: 8),
                                              isCollapsed: true,
                                              filled: true,
                                              prefixIcon: const Icon(
                                                Icons.search,
                                                size: 18,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ),
                                          focusNode: FocusNode(),
                                          onKey: (event) {
                                            if (event.runtimeType ==
                                                    RawKeyDownEvent &&
                                                event.logicalKey.keyId ==
                                                    4295426089) {
                                              searchedTerm.value = '';
                                              toggleSearch.value = false;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: searchedTerm.value.trim().isEmpty &&
                                        _navrailIndex.value == 0
                                    ? SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              child: Text(
                                                "Featured Apps",
                                                style: context
                                                    .textTheme.headline6!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 1.2),
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                CarouselSlider.builder(
                                                  itemCount: featured!.length,
                                                  itemBuilder:
                                                      (context, index, i) {
                                                    App featuredApp =
                                                        App.fromItem(featured!
                                                            .values
                                                            .toList()[index]);
                                                    return GestureDetector(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  AppPage(
                                                                      app:
                                                                          featuredApp))),
                                                      child: Stack(
                                                        children: [
                                                          if (featuredApp
                                                                  .screenshotsUrl !=
                                                              null)
                                                            Container(
                                                                constraints:
                                                                    const BoxConstraints
                                                                        .expand(),
                                                                child:
                                                                    CachedNetworkImage(
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
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                          Center(
                                                            child: Container(
                                                              color: context
                                                                      .isDark
                                                                  ? Colors.grey
                                                                      .shade900
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors.grey
                                                                      .shade300
                                                                      .withOpacity(
                                                                          0.5),
                                                              height: 400,
                                                              child: ClipRect(
                                                                child:
                                                                    BackdropFilter(
                                                                  filter:
                                                                      ImageFilter
                                                                          .blur(
                                                                    sigmaX: 10,
                                                                    sigmaY: 10,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            100,
                                                                        child: featuredApp.iconUrl !=
                                                                                null
                                                                            ? featuredApp.iconUrl!.endsWith('.svg')
                                                                                ? SvgPicture.network(
                                                                                    featuredApp.iconUrl!,
                                                                                  )
                                                                                : CachedNetworkImage(
                                                                                    imageUrl: featuredApp.iconUrl!,
                                                                                    fit: BoxFit.cover,
                                                                                    placeholder: (c, u) => const Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    ),
                                                                                    errorWidget: (c, w, i) => SvgPicture.network(
                                                                                      brokenImageUrl,
                                                                                      color: context.isDark ? Colors.white : Colors.grey[800],
                                                                                    ),
                                                                                  )
                                                                            : SvgPicture.network(
                                                                                brokenImageUrl,
                                                                                color: context.isDark ? Colors.white : Colors.grey[800],
                                                                              ),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          featuredApp
                                                                              .name,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
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
                                                  carouselController:
                                                      _controller,
                                                  options: CarouselOptions(
                                                      height: 400,
                                                      viewportFraction: 0.75,
                                                      initialPage: 0,
                                                      enableInfiniteScroll:
                                                          true,
                                                      reverse: false,
                                                      autoPlay: true,
                                                      autoPlayInterval:
                                                          const Duration(
                                                              seconds: 3),
                                                      autoPlayAnimationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  800),
                                                      autoPlayCurve:
                                                          Curves.fastOutSlowIn,
                                                      enlargeCenterPage: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      onPageChanged: (idx,
                                                              rsn) =>
                                                          _carouselIndex.value =
                                                              idx),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SizedBox(
                                                    height: 400,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.chevron_left),
                                                      onPressed: () =>
                                                          _controller
                                                              .previousPage(),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SizedBox(
                                                    height: 400,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.chevron_right),
                                                      onPressed: () =>
                                                          _controller
                                                              .nextPage(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                  featured!.length, (index) {
                                                return GestureDetector(
                                                  onTap: () => _controller
                                                      .animateToPage(index),
                                                  child: Container(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _carouselIndex
                                                                  .value ==
                                                              index
                                                          ? (context.isDark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black)
                                                              .withOpacity(0.9)
                                                          : (context.isDark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black)
                                                              .withOpacity(0.4),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 20),
                                            if (categories != null)
                                              Center(
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: min(
                                                          1200,
                                                          context.width >= 640
                                                              ? context.width -
                                                                  300
                                                              : context.width)),
                                                  child: Column(children: [
                                                    for (var category
                                                        in categories!.entries
                                                            .toList()) ...[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 16),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              category.key,
                                                              style: context
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      letterSpacing:
                                                                          1.2),
                                                            ),
                                                            OutlinedButton.icon(
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                primary: context
                                                                        .isDark
                                                                    ? Colors.grey[
                                                                        200]
                                                                    : Colors.grey[
                                                                        800],
                                                              ),
                                                              onPressed: () {
                                                                _navrailIndex
                                                                    .value = categories!
                                                                        .keys
                                                                        .toList()
                                                                        .indexOf(
                                                                            category.key) +
                                                                    1;
                                                              },
                                                              label: const Icon(
                                                                  Icons
                                                                      .chevron_right,
                                                                  size: 14),
                                                              icon: const Text(
                                                                  "See all"),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      GridOfApps(
                                                        itemList: category.value
                                                            .take(8)
                                                            .toList(),
                                                      ),
                                                    ],
                                                  ]),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: min(
                                                  1400,
                                                  context.width >= 640
                                                      ? context.width - 300
                                                      : context.width)),
                                          child: GridOfApps(
                                              itemList: searchedTerm
                                                          .value.isEmpty &&
                                                      categories != null
                                                  ? categories!.entries
                                                      .toList()[
                                                          _navrailIndex.value -
                                                              1]
                                                      .value
                                                  : itemsNew),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget gtkSidebarItem(
    BuildContext context,
    bool isSelected, {
    required String label,
    required IconData icon,
    VoidCallback? onSelected,
  }) {
    return ListTile(
      onTap: onSelected,
      tileColor: isSelected ? context.theme.primaryColor : null,
      title: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: isSelected ? Colors.white : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : null,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
