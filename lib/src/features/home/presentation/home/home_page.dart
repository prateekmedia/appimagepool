import 'dart:convert';

import 'package:appimagepool/src/features/download/data/download_provider.dart';
import 'package:appimagepool/src/utils/category_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/src/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';

import '../../application/view_type.dart';
import '../browse/browse_view.dart';
import '../downloads/downloads_view.dart';
import '../installed/installed_view_screen.dart';
import 'prefs_dialog.dart';

class HomePage extends StatefulHookConsumerWidget {
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
        if (CategoryUtils.doesContain(category, ['AudioVideo'])) {
          newList.add('Multimedia');
        } else if (CategoryUtils.doesContain(category, ['Video'])) {
          newList.add('Video');
        } else if (CategoryUtils.doesContain(category, ['Audio', 'Music'])) {
          newList.add('Audio');
        } else if (CategoryUtils.doesContain(category, ['Photo'])) {
          newList.add('Graphics');
        } else if (CategoryUtils.doesContain(category, ['KDE'])) {
          newList.add('Qt');
        } else if (CategoryUtils.doesContain(category, ['GNOME'])) {
          newList.add('GTK');
        } else if (CategoryUtils.doesContain(category, [
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

class _HomePageState extends ConsumerState<HomePage> {
  bool _isConnected = true;
  void getData() async {
    setState(() => _isConnected = true);
    try {
      allItems = (await Dio().get("https://appimage.github.io/feed.json"))
          .data['items'];
      featured = json.decode((await Dio().get(
              "https://gist.githubusercontent.com/prateekmedia/44c1ea7f7a627d284b9e50d47aa7200f/raw/gistfile1.txt"))
          .data);
    } catch (e) {
      debugPrint("$e");
      setState(() => _isConnected = false);
      return;
    }
    categories = (await compute<List, Map>(getSimplifiedCategories, allItems!));
    setState(() {});
  }

  Map? categories;
  List? allItems;
  Map? featured;
  late FlapController _flapController;

  @override
  void initState() {
    getData();
    super.initState();
    _flapController = FlapController();

    _flapController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final navrailIndex = useState<int>(0);
    final searchedTerm = useState<String>("");
    final _currentViewIndex = useState<int>(0);
    final toggleSearch = useState<bool>(false);
    final _controller = PageController();

    List<DropdownMenuItem> items = [
      DropdownMenuItem(
          value: 0,
          child: Text(
            AppLocalizations.of(context)!.grid,
          )),
      DropdownMenuItem(
          value: 1,
          child: Text(
            AppLocalizations.of(context)!.list,
          )),
    ];

    var currentlyDownloading = ref
        .watch(downloadProvider)
        .downloadList
        .where((element) => element.actualBytes != element.totalBytes)
        .length;

    void switchSearchBar([bool? value]) {
      if (categories == null && _currentViewIndex.value == 0) return;
      searchedTerm.value = '';
      toggleSearch.value = value ?? !toggleSearch.value;
    }

    return AdwScaffold(
      actions: AdwActions().windowManager,
      headerBarStyle: const HeaderBarStyle(
        titlebarSpace: 0,
      ),
      start: [
        AdwHeaderButton(
          icon: Icon(
            !toggleSearch.value ? Icons.search : LucideIcons.chevronLeft,
          ),
          onPressed: switchSearchBar,
        ),
      ],
      title: toggleSearch.value
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              color: Theme.of(context).appBarTheme.backgroundColor,
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event.runtimeType == RawKeyDownEvent &&
                      event.logicalKey.keyId == 4294967323) {
                    switchSearchBar(false);
                  }
                },
              ),
            )
          : null,
      end: !toggleSearch.value
          ? [
              GtkPopupMenu(
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdwButton.flat(
                      padding: AdwButton.defaultButtonPadding.copyWith(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.preferences,
                        style: context.textTheme.bodyText1,
                      ),
                      onPressed: () {
                        context.back();
                        showDialog(
                          context: context,
                          builder: (ctx) => const PrefsDialog(),
                        );
                      },
                    ),
                    const Divider(height: 4),
                    AdwButton.flat(
                      padding: AdwButton.defaultButtonPadding.copyWith(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.aboutApp,
                        style: context.textTheme.bodyText1,
                      ),
                      onPressed: () {
                        context.back();
                        showDialog(
                          context: context,
                          builder: (ctx) => AdwAboutWindow(
                            actions: AdwActions(
                              onDoubleTap:
                                  AdwActions().windowManager.onDoubleTap,
                              onHeaderDrag:
                                  AdwActions().windowManager.onHeaderDrag,
                              onClose: context.back,
                            ),
                            headerBarStyle: const HeaderBarStyle(
                              isTransparent: true,
                            ),
                            appName: appName,
                            credits: [
                              AdwPreferencesGroup.creditsBuilder(
                                title: AppLocalizations.of(context)!.authors,
                                itemCount: developers.length,
                                itemBuilder: (_, index) {
                                  var entry = developers[index];
                                  return AdwActionRow(
                                    title: entry.name,
                                    onActivated: entry.url.launchIt,
                                  );
                                },
                              ),
                              AdwPreferencesGroup.creditsBuilder(
                                title: "Translators",
                                itemCount: translators.length,
                                itemBuilder: (_, index) {
                                  var entry = translators[index];
                                  return AdwActionRow(
                                    title: entry.name,
                                    onActivated: entry.url.launchIt,
                                  );
                                },
                              ),
                            ],
                            appIcon: SvgPicture.network(
                              'https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/appimagepool.svg',
                              width: 70,
                              height: 70,
                            ),
                            issueTrackerLink: "$projectUrl/issues",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ]
          : [],
      flapController: _flapController,
      flap: (drawer) => buildSidebar(context, ref, navrailIndex, drawer),
      flapOptions: FlapOptions(
        visible: _currentViewIndex.value == 0,
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent &&
              event.isControlPressed &&
              event.logicalKey.keyId == 102) {
            switchSearchBar();
          }
        },
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            _currentViewIndex.value = index;
            if (_currentViewIndex.value != 0) {
              _flapController.close();
            } else {
              _flapController.isOpen = true;
            }
          },
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return AdwHeaderButton(
                          isActive: _flapController.isOpen,
                          icon: const Icon(LucideIcons.sidebar, size: 17),
                          onPressed: _flapController.toggle,
                        );
                      }),
                      Container(
                        height: 39,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: GtkToggleButton(
                          children: items,
                          onPressed: (value) =>
                              ref.read(viewTypeProvider.notifier).update(),
                          isSelected: List.generate(items.length,
                              (idx) => idx == ref.watch(viewTypeProvider)),
                        ),
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
            InstalledViewScreen(searchedTerm: searchedTerm),
            DownloadsView(searchedTerm: searchedTerm),
          ],
        ),
      ),
      viewSwitcher: !toggleSearch.value
          ? AdwViewSwitcher(
              currentIndex: _currentViewIndex.value,
              onViewChanged: _controller.jumpToPage,
              tabs: [
                ViewSwitcherData(
                  title: AppLocalizations.of(context)!.browse,
                  icon: Icons.web,
                ),
                ViewSwitcherData(
                  title: AppLocalizations.of(context)!.installed,
                  icon: Icons.view_list,
                ),
                ViewSwitcherData(
                  title: AppLocalizations.of(context)!.downloads,
                  badge:
                      currentlyDownloading > 0 ? '$currentlyDownloading' : null,
                  icon: Icons.download,
                ),
              ],
            )
          : null,
    );
  }

  AdwSidebar buildSidebar(
      BuildContext context, WidgetRef ref, ValueNotifier<int> navrailIndex,
      [bool isSidebar = false]) {
    return AdwSidebar(
      currentIndex: navrailIndex.value,
      onSelected: (index) {
        navrailIndex.value = index;
        if (isSidebar) {
          _flapController.toggle();
        }
      },
      width: 270,
      children: [
        AdwSidebarItem(
          label: AppLocalizations.of(context)!.explore,
          leading: const Icon(LucideIcons.trendingUp, size: 17),
        ),
        for (var category
            in (categories ?? {}).entries.toList().asMap().entries)
          AdwSidebarItem(
            label: categoryName(context, category.value.key),
            leading: Icon(
              categoryIcons.containsKey(category.value.key)
                  ? categoryIcons[category.value.key]!
                  : LucideIcons.helpCircle,
              size: 19,
            ),
          ),
      ],
    );
  }
}
