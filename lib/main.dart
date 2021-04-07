import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'utils/utils.dart';
import 'pages/category.dart';

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
            iconTheme: IconThemeData(color: Colors.black),
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
      categories = i.groupBy(
          (m) => m['categories'] != null ? m['categories'][0] : "Unknown");
    });
    // print(categories);
    i.retainWhere((element) => i.indexOf(element) < 400);
    print(JsonEncoder.withIndent('  ').convert(i));
  }

  Map? categories;

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchAppBar(
        title: Text('AppImageBrowser'),
        transitionDuration: const Duration(milliseconds: 800),
        colorOnScroll: context.isDark
            ? Colors.grey[800]!.withOpacity(0.6)
            : Colors.grey[200],
        color: context.isDark ? Colors.grey[800] : Colors.grey[100],
        actions: [
          FloatingSearchBarAction.searchToClear(
            color: context.isDark ? Colors.white : Colors.black,
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
            : GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            category: item.key,
                            items: item.value))),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: [
                          Colors.blue,
                          Colors.indigo,
                          Colors.amber,
                          Colors.brown,
                          Colors.cyan,
                          Colors.blueGrey,
                          Colors.lightBlue,
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
                          Colors.yellow,
                          Colors.lime,
                          Colors.cyan,
                          Colors.blue,
                          Colors.indigo,
                          Colors.amber,
                          Colors.brown,
                          Colors.cyan,
                          Colors.blueGrey,
                          Colors.lightBlue,
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
                          Colors.yellow,
                          Colors.lime,
                          Colors.red,
                        ][categories!.keys.toList().indexOf(item.key)],
                        //  Colors.primaries[
                        // math.Random().nextInt(Colors.primaries.length)],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Text(
                        item.key ?? "Unknown  ",
                        style: context.textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
