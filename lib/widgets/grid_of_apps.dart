import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/utils.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class GridOfApps extends StatelessWidget {
  final List itemList;

  const GridOfApps({Key? key, required this.itemList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return itemList.isNotEmpty
        ? GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
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
              var app = App.fromItem(item);

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AppPage(app: app))),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.isDark ? Colors.grey[800] : Colors.grey[300],
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
                              child: app.iconUrl != null
                                  ? (!app.iconUrl!.endsWith('.svg'))
                                      ? CachedNetworkImage(
                                          imageUrl: app.iconUrl!,
                                          fit: BoxFit.cover,
                                          placeholder: (c, b) => Center(
                                            child: SpinKitRipple(
                                                color: context.textTheme
                                                    .bodyText1!.color),
                                          ),
                                          errorWidget: (c, w, i) =>
                                              brokenImageWidget,
                                        )
                                      : SvgPicture.network(app.iconUrl!)
                                  : brokenImageWidget),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          app.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: context.textTheme.bodyText1!.copyWith(
                              color: context.isDark
                                  ? Colors.white
                                  : Colors.grey[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "No Results Found,\nTry changing search terms.",
              textAlign: TextAlign.center,
            ),
          );
  }
}
