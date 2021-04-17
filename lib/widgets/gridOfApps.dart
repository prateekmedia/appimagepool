import 'package:appimagebrowser/pages/pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/utils.dart';

class GridOfApps extends StatelessWidget {
  final List itemList;

  GridOfApps({required this.itemList});
  @override
  Widget build(BuildContext context) {
    return itemList.length > 0
        ? GridView.builder(
            padding: EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.width > 1200
                  ? 8
                  : context.width > 1000
                      ? 6
                      : context.width > 600
                          ? 4
                          : context.width > 300
                              ? 3
                              : 2,
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
            ),
            itemCount: itemList.length,
            itemBuilder: (BuildContext context, int index) {
              var item = itemList[index];
              String name = item['name'] != null ? item['name'] : "N.A.";
              String desc =
                  item['description'] != null ? item['description'] : "";
              String logoUrl =
                  item['icons'] != null ? PREFIX_URL + item['icons'][0] : "";

              if (name.length > 12) name = name.substring(0, 12) + "...";
              Widget brokenImageWidget = SvgPicture.network(
                brokenImageUrl,
                color: context.isDark ? Colors.white : Colors.grey[800],
              );

              return Tooltip(
                message: desc,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => AppPage(app: item))),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          context.isDark ? Colors.grey[800] : Colors.grey[300],
                    ),
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
                                    ? (!logoUrl.endsWith('.svg'))
                                        ? CachedNetworkImage(
                                            imageUrl: logoUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (c, b) => Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget: (c, w, i) =>
                                                brokenImageWidget,
                                          )
                                        : SvgPicture.network(logoUrl)
                                    : brokenImageWidget),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            name,
                            style: context.textTheme.bodyText1!.copyWith(
                                color: context.isDark
                                    ? Colors.white
                                    : Colors.grey[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Text(
            "No Results Found,\nTry changing search terms.",
            textAlign: TextAlign.center,
          );
  }
}
