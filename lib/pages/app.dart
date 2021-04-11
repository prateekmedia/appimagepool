import 'package:appimagebrowser/widgets/customdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AppPage extends StatefulWidget {
  AppPage({required this.app});

  final Map app;

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    String removeAllHtmlTags(String htmlText) {
      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

      return htmlText.replaceAll(exp, '');
    }

    String url = widget.app['links'] != null
        ? (widget.app['links'] as List).firstWhere(
            (e) => e['type'] == 'Download',
            orElse: () => {'url': ''})['url']
        : '';
    String proUrl = widget.app['links'] != null
        ? github +
            (widget.app['links'] as List).firstWhere(
                (e) => e['type'] == 'GitHub',
                orElse: () => {'url': ''})['url']
        : '';

    double iconSize = context.width > 500
        ? 100
        : context.width > 400
            ? 60
            : 50;
    var appIcon = widget.app['icons'] != null
        ? widget.app['icons'][0].endsWith('.svg')
            ? SvgPicture.network(
                PREFIX_URL + widget.app['icons'][0],
              )
            : CachedNetworkImage(
                imageUrl: PREFIX_URL + widget.app['icons'][0],
                fit: BoxFit.cover,
                placeholder: (c, u) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (c, w, i) => SvgPicture.network(
                  brokenImageUrl,
                  color: context.isDark ? Colors.white : Colors.grey[800],
                ),
              )
        : SvgPicture.network(
            brokenImageUrl,
            color: context.isDark ? Colors.white : Colors.grey[800],
          );
    int _current = 0;
    return Scaffold(
      body: aibAppBar(
        context,
        trailing: [],
        body: ListView(
          children: [
            Container(
              color: context.isDark ? Colors.grey[800] : Colors.grey[300],
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: (widget.app['links'] != null &&
                                    proUrl.length > 0)
                                ? proUrl
                                : "",
                            child: GestureDetector(
                              onTap: (widget.app['links'] != null &&
                                      proUrl.length > 0)
                                  ? proUrl.launchIt
                                  : null,
                              child: Container(
                                  width: iconSize,
                                  height: iconSize,
                                  child: appIcon),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.app['name'] != null
                                        ? widget.app['name']
                                        : "N.A.",
                                    style: context.textTheme.headline6),
                                Text(
                                    (widget.app['categories'] != null &&
                                            widget.app['categories'][0] != null
                                        ? widget.app['categories'].join(', ')
                                        : "N.A."),
                                    style: context.textTheme.bodyText2),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          if (widget.app['links'] != null && url.length > 0)
                            Tooltip(
                              message: url,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (url.contains('github.com', 0)) {
                                      List<String> v = url.split('github.com');
                                      var u =
                                          'https://api.github.com/repos' + v[1];
                                      List response = (await Dio().get(u)).data;
                                      if (response.length > 0) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DownloadDialog(
                                                  response, appIcon);
                                            });
                                      } else {
                                        url.launchIt();
                                      }
                                    } else {
                                      url.launchIt();
                                    }
                                  },
                                  child: Text("Download")),
                            )
                        ],
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(children: [
                  if (widget.app['screenshots'] != null &&
                      widget.app['screenshots'].length > 0)
                    CarouselSlider.builder(
                      itemCount: widget.app['screenshots'].length,
                      itemBuilder: (context, index, i) {
                        String screenUrl =
                            widget.app['screenshots'][index].startsWith('http')
                                ? widget.app['screenshots'][index]
                                : PREFIX_URL + widget.app['screenshots'][index];
                        Widget brokenImageWidget = SvgPicture.network(
                          brokenImageUrl,
                          color: context.isDark ? Colors.white : Colors.black,
                        );
                        return Container(
                          height: 400,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: widget.app['screenshots'] != null
                              ? screenUrl.endsWith('.svg')
                                  ? SvgPicture.network(screenUrl)
                                  : CachedNetworkImage(
                                      imageUrl: screenUrl,
                                      placeholder: (c, b) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (c, w, i) =>
                                          brokenImageWidget,
                                    )
                              : Container(),
                        );
                      },
                      options: CarouselOptions(
                          height: 400,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (idx, rsn) => {
                                setState(() {
                                  _current = idx;
                                })
                              }),
                    ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.app['screenshots'].map<Widget>((url) {
                      int index = widget.app['screenshots'].indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? (context.isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.9)
                              : (context.isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  if (widget.app['description'] != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      child: Text(
                        removeAllHtmlTags(widget.app['description']),
                        style: context.textTheme.bodyText1,
                      ),
                    ),
                  twoRowContainer(
                    context,
                    primaryT: "License",
                    secondaryT: widget.app['license'] != null
                        ? widget.app['license']
                        : "N.A.",
                  ),
                  twoRowContainer(
                    context,
                    primaryT: "Authors",
                    secondaryT: widget.app['authors'] != null
                        ? widget.app['authors'].map((e) => e['name']).join(', ')
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

class DownloadDialog extends StatefulHookWidget {
  final List response;

  final Widget appIcon;
  DownloadDialog(this.response, this.appIcon);

  @override
  _DownloadDialogState createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  @override
  Widget build(BuildContext context) {
    final checkmap = useState<Map<String, String>>({});

    return CustomDialogBox(
      versions: List.generate(
          widget.response.length, (index) => widget.response[index]['name']),
      onVersionChange: (version) {
        checkmap.value = {};
      },
      items: (index) {
        Map i = widget.response[index];
        var g = (i['assets'] as List)
            .where((element) =>
                element['name'].toLowerCase().endsWith('.appimage'))
            .toList();
        return List.generate(g.length, (idx) {
          var checkedValue = useState(
              checkmap.value.containsKey(g[idx]['browser_download_url']));
          checkmap.addListener(() {
            checkedValue.value =
                checkmap.value.containsKey(g[idx]['browser_download_url']);
          });
          return CheckboxListTile(
            title: Text(g[idx]['name']),
            value: checkedValue.value,
            onChanged: (newValue) {
              if (checkmap.value.containsKey(g[idx]['browser_download_url']))
                checkmap.value.removeWhere(
                    (key, value) => key == g[idx]['browser_download_url']);
              else
                checkmap.value.putIfAbsent(
                    g[idx]['browser_download_url'], () => g[idx]['name']);
              checkedValue.value =
                  checkmap.value.containsKey(g[idx]['browser_download_url']);
            },
          );
        });
      },
      endText: TextButton(
          onPressed: () {
            print(checkmap);
            Navigator.of(context).pop();
          },
          child: Text(
            "Download",
            style: TextStyle(fontSize: 18),
          )),
      img: widget.appIcon,
    );
  }
}
