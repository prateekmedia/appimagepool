import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/utils.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../screens/screens.dart';

class GridOfApps extends StatefulWidget {
  final List itemList;

  const GridOfApps({Key? key, required this.itemList}) : super(key: key);

  @override
  State<GridOfApps> createState() => _GridOfAppsState();
}

class _GridOfAppsState extends State<GridOfApps> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return widget.itemList.isEmpty
          ? const Center(
              child: Text(
                "No Results Found,\nTry changing search terms.",
                textAlign: TextAlign.center,
              ),
            )
          : ref.watch(viewTypeProvider) == 1
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: widget.itemList.length,
                  padding: const EdgeInsets.all(18),
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.itemList[index];
                    var app = App.fromItem(item);
                    final isHovering = ValueNotifier<bool>(false);

                    return ValueListenableBuilder<bool>(
                        valueListenable: isHovering,
                        builder: (context, value, __) {
                          return MouseRegion(
                            onExit: (_) => isHovering.value = false,
                            onHover: (_) => isHovering.value = true,
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AppPage(app: app))),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: value ? Colors.grey.withOpacity(0.2) : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: app.iconUrl != null
                                          ? (!app.iconUrl!.endsWith('.svg'))
                                              ? CachedNetworkImage(
                                                  imageUrl: app.iconUrl!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (c, b) => Center(
                                                    child: SpinKitRipple(color: context.textTheme.bodyText1!.color),
                                                  ),
                                                  errorWidget: (c, w, i) => brokenImageWidget,
                                                )
                                              : SvgPicture.network(app.iconUrl!)
                                          : brokenImageWidget,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(
                                              app.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: context.textTheme.bodyText1!
                                                  .copyWith(color: context.isDark ? Colors.white : Colors.grey[900]),
                                            ),
                                          ),
                                          if (app.description != null)
                                            Text(
                                              app.description!
                                                  .replaceAll('\n', '')
                                                  .replaceAll(RegExp(r"<[^>]*>"), 'replace'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: context.textTheme.bodyText1!
                                                  .copyWith(color: context.isDark ? Colors.white : Colors.grey[900]),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                )
              : GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(18),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.width > 1200
                        ? 8
                        : context.width > mobileWidth + 100
                            ? 6
                            : context.width > mobileWidth - 200
                                ? 4
                                : context.width > 300
                                    ? 3
                                    : 2,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 11,
                  ),
                  itemCount: widget.itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.itemList[index];
                    var app = App.fromItem(item);
                    final isHovering = ValueNotifier<bool>(false);

                    return ValueListenableBuilder<bool>(
                      valueListenable: isHovering,
                      builder: (context, value, __) {
                        return MouseRegion(
                          onExit: (_) => isHovering.value = false,
                          onHover: (_) => isHovering.value = true,
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AppPage(app: app))),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: value ? Colors.grey.withOpacity(0.2) : null,
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
                                                        child: SpinKitRipple(color: context.textTheme.bodyText1!.color),
                                                      ),
                                                      errorWidget: (c, w, i) => brokenImageWidget,
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
                                      style: context.textTheme.bodyText1!
                                          .copyWith(color: context.isDark ? Colors.white : Colors.grey[900]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
    });
  }
}
