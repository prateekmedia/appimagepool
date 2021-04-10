import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'utils/utils.dart';
import 'pages/category.dart';
import 'widgets/aibappbar.dart';

void main() {
  var theme = ValueNotifier(ThemeMode.dark);
  runApp(
    ValueListenableBuilder(
      valueListenable: theme,
      builder: (ctx, ThemeMode va, ch) => MaterialApp(
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
        themeMode: va,
        home: HomePage(theme: theme),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> theme;

  HomePage({required this.theme});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    Map response =
        (await Dio().get("https://appimage.github.io/feed.json")).data;
    List i = response['items'];
    // i.retainWhere((element) => i.indexOf(element) < 40);
    setState(() {
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
    i.retainWhere((element) => i.indexOf(element) < 40);
    print(JsonEncoder.withIndent('  ').convert(categories));
  }

  Map? categories;

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: categories == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(
                child: GridView.count(
                  padding: EdgeInsets.all(20),
                  childAspectRatio: 16 / 12,
                  crossAxisCount: context.width > 1000
                      ? 5
                      : context.width > 600
                          ? 4
                          : context.width > 500
                              ? 3
                              : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: categories!.entries.map((item) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => CategoryPage(
                              theme: widget.theme,
                              category: item.key ?? "N.A.",
                              items: item.value))),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: [
                            Colors.blue,
                            Colors.indigo,
                            Colors.amber[800],
                            Colors.brown,
                            Colors.cyan,
                            Colors.blueGrey,
                            Colors.lightGreen,
                            Colors.red,
                            Colors.orange,
                            Colors.green,
                            Colors.grey,
                            Colors.pink,
                            Colors.purple,
                            Colors.deepPurple,
                            Colors.deepOrange,
                            Colors.teal,
                            Colors.blue,
                            Colors.indigo,
                            Colors.amber[800],
                            Colors.brown,
                            Colors.cyan,
                            Colors.blueGrey,
                            Colors.lightGreen,
                            Colors.red,
                            Colors.orange,
                            Colors.green,
                            Colors.grey,
                            Colors.pink,
                            Colors.purple,
                            Colors.deepPurple,
                            Colors.deepOrange,
                            Colors.teal,
                            Colors.blue,
                            Colors.indigo,
                            Colors.amber[800],
                            Colors.brown,
                            Colors.cyan,
                            Colors.blueGrey,
                            Colors.lightGreen,
                            Colors.red,
                            Colors.orange,
                            Colors.green,
                            Colors.grey,
                            Colors.pink,
                            Colors.purple,
                            Colors.deepPurple,
                            Colors.deepOrange,
                            Colors.teal,
                          ][categories!.keys.toList().indexOf(item.key)],
                          //  Colors.primaries[
                          // math.Random().nextInt(Colors.primaries.length)],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                          "${item.key} (${item.value.length}) ",
                          style: context.textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
