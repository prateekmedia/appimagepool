import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/translations.dart';
import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/screens/screens.dart';
import 'package:appimagepool/widgets/widgets.dart';

class BrowseView extends StatefulHookWidget {
  final BuildContext context;
  final ValueNotifier<bool> toggleSearch;
  final ValueNotifier<String> searchedTerm;
  final ValueNotifier<int> navrailIndex;
  final void Function(bool? value) switchSearchBar;
  final VoidCallback getData;
  final bool isConnected;
  final Map? categories;
  final Map? featured;
  final List? allItems;

  const BrowseView({
    Key? key,
    required this.context,
    required this.toggleSearch,
    required this.searchedTerm,
    required this.navrailIndex,
    required this.switchSearchBar,
    required this.getData,
    required this.isConnected,
    required this.categories,
    required this.featured,
    required this.allItems,
  }) : super(key: key);

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView>
    with AutomaticKeepAliveClientMixin {
  final _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final showCarouselArrows = useState<bool>(false);
    final carouselIndex = useState<int>(0);
    var itemsNew = widget.allItems != null && widget.navrailIndex.value == 0
        ? widget.allItems!
            .where((element) => element['name']
                .toLowerCase()
                .contains(widget.searchedTerm.value.toLowerCase(), 0))
            .toList()
        : widget.allItems != null &&
                widget.navrailIndex.value > 0 &&
                widget.categories != null
            ? (widget.categories!.entries
                    .toList()[widget.navrailIndex.value - 1]
                    .value as List)
                .where((element) => element['name']
                    .toLowerCase()
                    .contains(widget.searchedTerm.value.toLowerCase(), 0))
                .toList()
            : [];
    return !widget.isConnected
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.wifiOff, size: 45),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.cantConnect,
                  style: context.textTheme.headline5),
              const SizedBox(height: 12),
              Text(
                  "${AppLocalizations.of(context)!.youNeedInternetConnectionToUse} $appName.",
                  style: context.textTheme.headline6),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: widget.getData,
                  child: Text(AppLocalizations.of(context)!.retry)),
            ],
          )
        : widget.categories == null && widget.featured == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(color: context.textTheme.bodyText1!.color),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.fetchingSoftwares,
                      style: context.textTheme.headline5),
                ],
              )
            : widget.searchedTerm.value.trim().isEmpty &&
                    widget.navrailIndex.value == 0
                ? SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Text(
                            AppLocalizations.of(context)!.featuredApps,
                            style: context.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2),
                          ),
                        ),
                        MouseRegion(
                          onExit: (value) => showCarouselArrows.value = false,
                          onHover: (value) => showCarouselArrows.value = true,
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                itemCount: widget.featured!.length,
                                itemBuilder: (context, index, i) {
                                  App featuredApp = App.fromItem(
                                      widget.featured!.values.toList()[index]);
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  AppPage(app: featuredApp))),
                                      child: Stack(
                                        children: [
                                          if (featuredApp.screenshotsUrl !=
                                              null)
                                            Container(
                                                constraints:
                                                    const BoxConstraints
                                                        .expand(),
                                                child: CachedNetworkImage(
                                                  imageUrl: featuredApp
                                                          .screenshotsUrl![0]
                                                          .startsWith('http')
                                                      ? (featuredApp
                                                          .screenshotsUrl!)[0]
                                                      : prefixUrl +
                                                          featuredApp
                                                              .screenshotsUrl![0],
                                                  fit: BoxFit.cover,
                                                )),
                                          Center(
                                            child: Container(
                                              color: context.isDark
                                                  ? Colors.grey.shade900
                                                      .withOpacity(0.5)
                                                  : Colors.grey.shade300
                                                      .withOpacity(0.5),
                                              height: 400,
                                              child: ClipRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 10,
                                                    sigmaY: 10,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: featuredApp
                                                                    .iconUrl !=
                                                                null
                                                            ? featuredApp
                                                                    .iconUrl!
                                                                    .endsWith(
                                                                        '.svg')
                                                                ? SvgPicture
                                                                    .network(
                                                                    featuredApp
                                                                        .iconUrl!,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl:
                                                                        featuredApp
                                                                            .iconUrl!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (c, u) =>
                                                                            const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                    errorWidget: (c,
                                                                            w,
                                                                            i) =>
                                                                        brokenImageWidget,
                                                                  )
                                                            : brokenImageWidget,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          featuredApp.name ??
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .notAvailable,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .textTheme
                                                              .headline3,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                carouselController: _controller,
                                options: CarouselOptions(
                                    height: 400,
                                    viewportFraction: 0.75,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (idx, rsn) =>
                                        carouselIndex.value = idx),
                              ),
                              if (showCarouselArrows.value) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: 400,
                                    child: CarouselArrow(
                                      icon: Icons.chevron_left,
                                      onPressed: () =>
                                          _controller.previousPage(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 400,
                                    child: CarouselArrow(
                                      icon: Icons.chevron_right,
                                      onPressed: () => _controller.nextPage(),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(widget.featured!.length, (index) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(index),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: carouselIndex.value == index
                                      ? (context.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(0.9)
                                      : (context.isDark
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        if (widget.categories != null)
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: math.min(
                                      1200,
                                      context.width >= mobileWidth
                                          ? context.width - 300
                                          : context.width)),
                              child: Column(children: [
                                for (var category
                                    in widget.categories!.entries.toList()) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category.key,
                                          style: context.textTheme.headline6!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2),
                                        ),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            primary: context.isDark
                                                ? Colors.grey[200]
                                                : Colors.grey[800],
                                          ),
                                          onPressed: () {
                                            widget.navrailIndex.value = widget
                                                    .categories!.keys
                                                    .toList()
                                                    .indexOf(category.key) +
                                                1;
                                          },
                                          label: const Icon(Icons.chevron_right,
                                              size: 14),
                                          icon: Text(
                                              AppLocalizations.of(context)!
                                                  .seeAll),
                                        )
                                      ],
                                    ),
                                  ),
                                  GridOfApps(
                                    itemList: category.value.take(8).toList(),
                                  ),
                                ],
                              ]),
                            ),
                          )
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: math.min(
                              1400,
                              context.width >= mobileWidth
                                  ? context.width - 300
                                  : context.width)),
                      child: GridOfApps(
                          itemList: widget.searchedTerm.value.isEmpty &&
                                  widget.categories != null
                              ? widget.categories!.entries
                                  .toList()[widget.navrailIndex.value - 1]
                                  .value
                              : itemsNew),
                    ),
                  );
  }

  @override
  bool get wantKeepAlive => true;
}
