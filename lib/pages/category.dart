import 'package:appimagebrowser/pages/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class CategoryPage extends StatelessWidget {
  final List items;
  final String category;

  CategoryPage({required this.category, required this.items});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (c, b) =>
            [aibAppBar(forceElevated: b, title: category)],
        body: GridView.count(
          padding: EdgeInsets.all(10),
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
                              ? (logoUrl.endsWith('.svg')
                                  ? SvgPicture.network(logoUrl)
                                  : Image.network(
                                      logoUrl,
                                      fit: BoxFit.cover,
                                    ))
                              : SvgPicture.network(brokenImageUrl),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        name,
                        style: context.textTheme.headline6!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
