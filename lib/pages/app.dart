import 'dart:io';

import 'package:appimagebrowser/widgets/customdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:simple_html_css/simple_html_css.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AppPage extends HookWidget {
  AppPage({required this.app});

  final Map app;

  @override
  Widget build(BuildContext context) {
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
    var prefixNameUrl =
        app['icons'] != null && app['icons'][0].startsWith('http')
            ? ""
            : PREFIX_URL;
    var appIcon = app['icons'] != null
        ? app['icons'][0].endsWith('.svg')
            ? SvgPicture.network(
                prefixNameUrl + app['icons'][0],
              )
            : CachedNetworkImage(
                imageUrl: prefixNameUrl + app['icons'][0],
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
    final _current = useState<int>(0);
    final downloading = useState<bool?>(null);
    final listDownloads = useState<Map<String, List<int>>>({});
    _showPopupMenu(Offset offset) async {
      double left = offset.dx;
      double top = offset.dy;
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, 0, 0),
        items: [
          for (var i in listDownloads.value.entries)
            PopupMenuItem<String>(
                child: Text(
                    "${i.key} ${i.value[0].getFileSize()}/${i.value[1].getFileSize()}"),
                value: i.key),
        ],
        elevation: 8.0,
      );
    }

    print(app);
    return Scaffold(
      body: aibAppBar(
        context,
        trailing: [
          if (downloading.value != null)
            GestureDetector(
              onTapDown: (details) {
                _showPopupMenu(details.globalPosition);
              },
              child: Icon(downloading.value!
                  ? Icons.download_outlined
                  : Icons.download_done_outlined),
            ),
        ],
        body: ListView(
          children: [
            Container(
              color: context.isDark ? Colors.grey[800] : Colors.grey[300],
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      Row(
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
                                  child: appIcon),
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
                                                  response, appIcon,
                                                  (checkmap) async {
                                                // print(checkmap.value);
                                                var location = "/" +
                                                    (await getApplicationDocumentsDirectory())
                                                        .toString()
                                                        .split('/')
                                                        .toList()
                                                        .sublist(1, 3)
                                                        .join("/") +
                                                    "/Applications/";
                                                if (!Directory(location)
                                                    .existsSync())
                                                  Directory(location)
                                                      .createSync();
                                                if (checkmap.length > 0) {
                                                  var fileurl =
                                                      checkmap.keys.toList()[0];
                                                  String filename = checkmap
                                                      .values
                                                      .toList()[0];
                                                  print(location);
                                                  downloading.value = true;
                                                  listDownloads.value
                                                      .putIfAbsent(filename,
                                                          () => [0, 0]);
                                                  await Dio().download(fileurl,
                                                      location + filename,
                                                      onReceiveProgress:
                                                          (r, t) {
                                                    listDownloads.value[
                                                        filename]![0] = r;
                                                    listDownloads.value[
                                                        filename]![1] = t;
                                                  });
                                                  downloading.value = false;
                                                  var shell =
                                                      Shell().cd(location);
                                                  shell.run(
                                                      'chmod +x ' + filename);
                                                }
                                              });
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
                constraints: BoxConstraints(maxWidth: 1200),
                child: Column(children: [
                  if (app['screenshots'] != null &&
                      app['screenshots'].length > 0)
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
                          onPageChanged: (idx, rsn) {
                            _current.value = idx;
                          }),
                    ),
                  SizedBox(height: 5),
                  if (app['screenshots'] != null &&
                      app['screenshots'].length > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(app['screenshots'].length, (index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current.value == index
                                ? (context.isDark ? Colors.white : Colors.black)
                                    .withOpacity(0.9)
                                : (context.isDark ? Colors.white : Colors.black)
                                    .withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    child: RichText(
                        text: HTML.toTextSpan(
                            context,
                            (app['description'] != null &&
                                    app['description']
                                            .toString()
                                            .trim()
                                            .length >
                                        0)
                                ? app['description']
                                : "No Description Found",
                            defaultTextStyle: context.textTheme.bodyText1!)),
                  ),
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
                        ? "${app['authors'].map((e) => '<a href="${e['url']}" >${e['name']}</a>').join(', ')}"
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
  final void Function(Map<String, String>)? onEndPressed;

  DownloadDialog(this.response, this.appIcon, this.onEndPressed);

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
            subtitle: Text((g[idx]['size'] as int).getFileSize()),
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
          onPressed: () async {
            if (widget.onEndPressed != null)
              widget.onEndPressed!(checkmap.value);
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
