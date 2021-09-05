import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gtk/gtk.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:nativeshell/nativeshell.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/utils.dart';
import 'screens/screens.dart';
import 'widgets/widgets.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPrefs().init();
  runApp(
    ProviderScope(child: WindowWidget(
      onCreateState: (initData) {
        WindowState? state;
        state ??= MyApp();
        return state;
      },
    )),
  );
}

class MyApp extends WindowState {
  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Future<void> initializeWindow(Size contentSize) async {
    window.setStyle(WindowStyle(frame: WindowFrame.noTitle));
    window.setTitle('Pool');
    return super.initializeWindow(const Size(1280, 720));
  }

  @override
  Widget build(BuildContext context) {
    final gTheme = GnomeTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: gTheme.data(context).copyWith(primaryColor: Colors.blue[600]),
      home: const HomePage(),
    );
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
    final searchedTerm = useState<String>("");
    final _currentViewIndex = useState<int>(0);
    final toggleSearch = useState<bool>(false);
    final _controller = PageController();

    void switchSearchBar([bool? value]) {
      if (categories == null && featured == null) return;
      searchedTerm.value = '';
      toggleSearch.value = value ?? !toggleSearch.value;
    }

    return Consumer(
      builder: (ctx, ref, _) => Scaffold(
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
                    color: getAdaptiveGtkColor(context, colorType: GtkColorType.headerBarBackgroundBottom),
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
                    if (_currentViewIndex.value == 0)
                      GtkHeaderButton(
                        icon: AdwaitaIcon(
                          ref.watch(viewTypeProvider) == 0 ? AdwaitaIcons.view_grid : AdwaitaIcons.view_list_bullet,
                          size: 17,
                        ),
                        onPressed: (categories != null || featured != null)
                            ? ref.watch(viewTypeProvider.notifier).update
                            : null,
                      ),
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
                BrowseView(
                  context: context,
                  toggleSearch: toggleSearch,
                  searchedTerm: searchedTerm,
                  switchSearchBar: switchSearchBar,
                  getData: getData,
                  isConnected: _isConnected,
                  featured: featured,
                  categories: categories,
                  allItems: allItems,
                ),
                InstalledView(searchedTerm: searchedTerm),
                DownloadsView(searchedTerm: searchedTerm),
              ],
            ),
          ),
        ),
        bottomNavigationBar: context.width < mobileWidth
            ? buildViewSwitcher(_currentViewIndex, _controller, ref, ViewSwitcherStyle.mobile)
            : null,
      ),
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
      tabs: [
        const ViewSwitcherData(title: "Browse", icon: Icons.web),
        const ViewSwitcherData(title: "Installed", icon: Icons.list_alt),
        ViewSwitcherData(
          title: "Downloads${currentlyDownloading > 0 ? ' ($currentlyDownloading)' : ''}",
          icon: Icons.download,
        ),
      ],
      style: viewSwitcherStyle,
    );
  }
}
