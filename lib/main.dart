import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gtk/gtk.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'utils/utils.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPrefs().init();
  runApp(const ProviderScope(child: MyApp()));

  doWhenWindowReady(() {
    appWindow.alignment = Alignment.center;
    appWindow.title = "Pool";
    appWindow.show();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    return GnomeTheme(
        isDark: ref.watch(forceDarkThemeProvider),
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: GnomeTheme.of(context).themeData,
            home: const HomePage(),
          );
        });
  }
}

class HomePage extends StatefulHookWidget {
  // bool _isConnected = true;

  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

Map getSimplifiedCategories(List value) {
  return value.groupBy((m) {
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
}

class _HomePageState extends State<HomePage> {
  bool _isConnected = true;
  void getData() async {
    setState(() => _isConnected = true);
    try {
      allItems = (await Dio().get("https://appimage.github.io/feed.json")).data['items'];
      featured = json.decode((await Dio().get(
              "https://gist.githubusercontent.com/prateekmedia/44c1ea7f7a627d284b9e50d47aa7200f/raw/gistfile1.txt"))
          .data);
    } catch (e) {
      debugPrint(e.toString());
      setState(() => _isConnected = false);
      return;
    }
    categories = (await compute<List, Map>(getSimplifiedCategories, allItems!));
    setState(() {});
  }

  Map? categories;
  List? allItems;
  Map? featured;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navrailIndex = useState<int>(0);
    final searchedTerm = useState<String>("");
    final _currentViewIndex = useState<int>(0);
    final toggleSearch = useState<bool>(false);
    final isSidebarActive = useState<bool>(true);
    final _controller = PageController();

    void switchSearchBar([bool? value]) {
      if (categories == null && _currentViewIndex.value == 0) return;
      searchedTerm.value = '';
      toggleSearch.value = value ?? !toggleSearch.value;
    }

    return Consumer(
      builder: (ctx, ref, _) => Scaffold(
        drawer: context.width < mobileWidth
            ? Drawer(child: buildSidebar(context, ref, isSidebarActive, navrailIndex, true))
            : null,
        body: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.runtimeType == RawKeyDownEvent && event.isControlPressed && event.logicalKey.keyId == 102) {
              switchSearchBar();
            }
          },
          child: PoolApp(
            center: toggleSearch.value
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    color: GnomeTheme.of(context).sidebars,
                    constraints: BoxConstraints.loose(const Size(500, 50)),
                    child: RawKeyboardListener(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: true,
                        onChanged: (query) => searchedTerm.value = query,
                        style: context.textTheme.bodyText1!.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          fillColor: context.theme.canvasColor,
                          contentPadding: const EdgeInsets.only(top: 8),
                          isCollapsed: true,
                          filled: true,
                          prefixIcon: const Icon(Icons.search, size: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                      focusNode: FocusNode(),
                      onKey: (event) {
                        if (event.runtimeType == RawKeyDownEvent && event.logicalKey.keyId == 4294967323) {
                          switchSearchBar(false);
                        }
                      },
                    ),
                  )
                : context.width >= mobileWidth
                    ? buildViewSwitcher(_currentViewIndex, _controller, ref)
                    : null,
            leading: [
              GtkHeaderButton(
                icon: AdwaitaIcon(
                  !toggleSearch.value ? AdwaitaIcons.system_search : AdwaitaIcons.go_previous,
                  size: 17,
                ),
                onPressed: switchSearchBar,
              ),
            ],
            trailing: !toggleSearch.value
                ? [
                    GtkPopupMenu(
                      body: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            dense: true,
                            title: Text(
                              "Preferences",
                              style: context.textTheme.bodyText1,
                            ),
                            onTap: () {
                              context.back();
                              showDialog(
                                context: context,
                                builder: (ctx) => prefsDialog(ctx),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            dense: true,
                            title: Text(
                              "About Appimages",
                              style: context.textTheme.bodyText1,
                            ),
                            onTap: () {
                              context.back();
                              showDialog(
                                context: context,
                                builder: (ctx) => appimageAboutDialog(ctx),
                              );
                            },
                          ),
                          ListTile(
                            dense: true,
                            title: Text(
                              "About the App",
                              style: context.textTheme.bodyText1,
                            ),
                            onTap: () {
                              context.back();
                              showDialog(
                                context: context,
                                builder: (ctx) => aboutDialog(ctx),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]
                : [],
            body: PageView(
              controller: _controller,
              onPageChanged: (index) => _currentViewIndex.value = index,
              children: [
                Row(
                  children: [
                    if (context.width >= mobileWidth)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: buildSidebar(context, ref, isSidebarActive, navrailIndex),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(builder: (context) {
                                  return GtkHeaderButton(
                                    isActive: isSidebarActive.value,
                                    icon: const AdwaitaIcon(AdwaitaIcons.sidebar_toggle_left),
                                    onPressed: () {
                                      if (context.width < mobileWidth) {
                                        Scaffold.of(context).openDrawer();
                                      } else {
                                        isSidebarActive.value = !isSidebarActive.value;
                                      }
                                    },
                                  );
                                }),
                                buildDropdown(
                                  context,
                                  ref,
                                  label: "View type",
                                  index: ref.watch(viewTypeProvider),
                                  onChanged: (value) => ref.read(viewTypeProvider.notifier).update(),
                                  items: [
                                    const DropdownMenuItem(value: 0, child: Text('Grid')),
                                    const DropdownMenuItem(value: 1, child: Text('List')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: BrowseView(
                              context: context,
                              toggleSearch: toggleSearch,
                              navrailIndex: navrailIndex,
                              searchedTerm: searchedTerm,
                              switchSearchBar: switchSearchBar,
                              getData: getData,
                              isConnected: _isConnected,
                              featured: featured,
                              categories: categories,
                              allItems: allItems,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InstalledView(searchedTerm: searchedTerm),
                DownloadsView(searchedTerm: searchedTerm),
              ],
            ),
          ),
        ),
        bottomNavigationBar: context.width < mobileWidth && searchedTerm.value.isEmpty
            ? buildViewSwitcher(_currentViewIndex, _controller, ref, ViewSwitcherStyle.mobile)
            : null,
      ),
    );
  }

  GtkSidebar buildSidebar(
      BuildContext context, WidgetRef ref, ValueNotifier<bool> isSidebarActive, ValueNotifier<int> navrailIndex,
      [bool isSidebar = false]) {
    return GtkSidebar(
      width: isSidebarActive.value ? 265 : 0,
      padding: EdgeInsets.zero,
      currentIndex: navrailIndex.value,
      onSelected: (index) {
        navrailIndex.value = index;
        if (isSidebar) {
          context.back();
        }
      },
      children: [
        GtkSidebarItem(
          label: "Explore",
          leading: const AdwaitaIcon(AdwaitaIcons.explore2, size: 17),
        ),
        for (var category in (categories ?? {}).entries.toList().asMap().entries)
          GtkSidebarItem(
            label: category.value.key,
            leading: AdwaitaIcon(
              categoryIcons.containsKey(category.value.key)
                  ? categoryIcons[category.value.key]!
                  : AdwaitaIcons.question,
              size: 19,
            ),
          ),
      ],
    );
  }

  Row buildDropdown(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required int index,
    required Function(int? value)? onChanged,
    required List<DropdownMenuItem<int>> items,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 10),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: GnomeTheme.of(context).sidebars, borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<int>(
            value: index,
            onChanged: onChanged,
            items: items,
            icon: const Icon(Icons.arrow_drop_down),
            underline: const SizedBox(),
          ),
        ),
      ],
    );
  }

  GtkViewSwitcher buildViewSwitcher(ValueNotifier<int> _currentViewIndex, PageController _controller, WidgetRef ref,
      [ViewSwitcherStyle viewSwitcherStyle = ViewSwitcherStyle.desktop]) {
    var currentlyDownloading =
        ref.watch(downloadListProvider).where((element) => element.actualBytes != element.totalBytes).length;
    return GtkViewSwitcher(
      currentIndex: _currentViewIndex.value,
      onViewChanged: (index) {
        _controller.jumpToPage(index);
      },
      height: 50,
      tabs: [
        const ViewSwitcherData(title: "Browse", icon: Icons.web),
        const ViewSwitcherData(title: "Installed", icon: Icons.view_list),
        ViewSwitcherData(
          title: "Downloads${currentlyDownloading > 0 ? ' ($currentlyDownloading)' : ''}",
          icon: Icons.download,
        ),
      ],
      style: viewSwitcherStyle,
    );
  }
}
