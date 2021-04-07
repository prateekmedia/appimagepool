import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'utils/utils.dart';
import 'pages/category.dart';
import 'widgets/widgets.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: HomePage(),
      ),
    );

class HomePage extends StatefulWidget {
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
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (c, b) => [
                  aibAppBar(forceElevated: b, title: "AppImageBrowser"),
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
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => CategoryPage(
                                    category: item.key, items: item.value))),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: [
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.amber,
                              Colors.brown,
                              Colors.cyan
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
                  )));
  }
}
