import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AppPage extends StatelessWidget {
  AppPage({required this.app});

  final Map app;
  @override
  Widget build(BuildContext context) {
    String removeAllHtmlTags(String htmlText) {
      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

      return htmlText.replaceAll(exp, '');
    }

    var _controller = CarouselController();
    String url = app['links'] != null
        ? (app['links'] as List).firstWhere((e) => e['type'] == 'Download',
            orElse: () => {'url': ''})['url']
        : '';
    String proUrl = app['links'] != null
        ? github +
            (app['links'] as List).firstWhere((e) => e['type'] == 'GitHub',
                orElse: () => {'url': ''})['url']
        : '';

    double iconSize = context.width > 500
        ? 100
        : context.width > 400
            ? 60
            : 50;
    print(app['categories']);
    return Scaffold(
      body: aibAppBar(
        context,
        trailing: [],
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: (app['links'] != null && proUrl.length > 0)
                        ? proUrl
                        : "",
                    child: GestureDetector(
                      onTap: (app['links'] != null && proUrl.length > 0)
                          ? proUrl.launchIt
                          : null,
                      child: Container(
                          width: iconSize,
                          height: iconSize,
                          child: app['icons'] != null
                              ? app['icons'][0].endsWith('.svg')
                                  ? SvgPicture.network(
                                      PREFIX_URL + app['icons'][0],
                                    )
                                  : Image.network(
                                      PREFIX_URL + app['icons'][0],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (c, w, i) =>
                                          LoadingIndicator(
                                        indicatorType: Indicator.orbit,
                                        color: context.isDark
                                            ? Colors.white
                                            : Colors.grey[800],
                                      ),
                                    )
                              : SvgPicture.network(
                                  brokenImageUrl,
                                  color: context.isDark
                                      ? Colors.white
                                      : Colors.grey[800],
                                )),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(app['name'] != null ? app['name'] : "N.A.",
                            style: context.textTheme.headline6),
                        Text(
                            (app['categories'] != null &&
                                    app['categories'][0] != null
                                ? app['categories'].join(', ')
                                : "N.A."),
                            style: context.textTheme.bodyText2),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  if (app['links'] != null && url.length > 0)
                    Tooltip(
                      message: url,
                      child: ElevatedButton(
                          onPressed: url.launchIt, child: Text("Download")),
                    )
                ],
              ),
            ),
            if (app['screenshots'] != null && app['screenshots'].length > 0)
              CarouselSlider.builder(
                itemCount: app['screenshots'].length,
                itemBuilder: (context, index, i) {
                  String screenUrl =
                      app['screenshots'][index].startsWith('http')
                          ? app['screenshots'][index]
                          : PREFIX_URL + app['screenshots'][index];
                  Widget brokenImageWidget = SvgPicture.network(
                    brokenImageUrl,
                    color: context.isDark ? Colors.white : Colors.black,
                  );
                  return Container(
                    height: 400,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: app['screenshots'] != null
                        ? screenUrl.endsWith('.svg')
                            ? SvgPicture.network(screenUrl)
                            : Image.network(
                                screenUrl,
                                loadingBuilder: (c, w, i) => Center(
                                  child: Container(
                                    constraints: BoxConstraints(maxHeight: 100),
                                    child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballSpinFadeLoader,
                                      color: context.isDark
                                          ? Colors.white
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                                errorBuilder: (c, w, i) => brokenImageWidget,
                              )
                        : Container(),
                  );
                },
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            if (app['screenshots'] != null && app['screenshots'].length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextButton(
                        onPressed: () => _controller.previousPage(),
                        child: Text('←'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextButton(
                        onPressed: () => _controller.nextPage(),
                        child: Text('→'),
                      ),
                    ),
                  ),
                  ...Iterable<int>.generate(app['screenshots'].length).map(
                    (int pageIndex) => Flexible(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextButton(
                          onPressed: () => _controller.animateToPage(pageIndex),
                          child: Text("$pageIndex"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            if (app['description'] != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                child: Text(
                  removeAllHtmlTags(app['description']),
                  style: context.textTheme.bodyText1,
                ),
              ),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      twoRowContainer(
                        context,
                        primaryT: "License",
                        secondaryT:
                            app['license'] != null ? app['license'] : "N.A.",
                      ),
                      twoRowContainer(
                        context,
                        primaryT: "Authors",
                        secondaryT: app['authors'] != null
                            ? app['authors'].map((e) => e['name']).join(', ')
                            : "N.A.",
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
