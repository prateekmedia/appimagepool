import 'dart:io';

import 'package:appimagepool/models/models.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/widgets/customdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:simple_html_css/simple_html_css.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AppPage extends HookConsumerWidget {
  AppPage({Key? key, required this.app}) : super(key: key);

  final App app;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context, ref) {
    String url = app.url != null
        ? (app.url as List).firstWhere((e) => e['type'] == 'Download',
            orElse: () => {'url': ''})['url']
        : '';
    debugPrint(app.url.toString());
    String proUrl = app.url != null
        ? app.url!.firstWhere((e) => e['type'].toLowerCase() == 'github',
            orElse: () => {'url': ''})['url']
        : '';

    if (!proUrl.startsWith('http') && app.url != null) proUrl = github + proUrl;

    double iconSize = context.width > 500
        ? 100
        : context.width > 400
            ? 60
            : 50;
    Widget brokenImageWidget = SvgPicture.network(
      brokenImageUrl,
      color: context.isDark ? Colors.white : Colors.grey[800],
    );
    Widget appIcon = app.iconUrl != null
        ? (!app.iconUrl!.endsWith('.svg'))
            ? CachedNetworkImage(
                imageUrl: app.iconUrl!,
                fit: BoxFit.cover,
                placeholder: (c, b) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (c, w, i) => brokenImageWidget,
              )
            : SvgPicture.network(app.iconUrl!)
        : brokenImageWidget;
    final _current = useState<int>(0);
    var downloading = ref.watch(isDownloadingProvider);
    List<QueryApp> listDownloads = ref.watch(downloadListProvider);

    debugPrint(app.toString());
    return Scaffold(
      body: aibAppBar(
        context,
        title: '',
        leading: [
          AdwaitaHeaderButton(
            icon: Icons.chevron_left,
            onTap: context.back,
          )
        ],
        trailing: [
          if (listDownloads.isNotEmpty)
            downloadButton(context, listDownloads, downloading),
        ],
        body: ListView(
          children: [
            Container(
              color: context.isDark
                  ? AdwaitaDarkColors.headerBarBackgroundTop
                  : AdwaitaLightColors.headerBarBackgroundTop,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: (app.url != null && proUrl.isNotEmpty)
                                ? proUrl
                                : "",
                            child: GestureDetector(
                              onTap: (app.url != null && proUrl.isNotEmpty)
                                  ? proUrl.launchIt
                                  : null,
                              child: SizedBox(
                                  width: iconSize,
                                  height: iconSize,
                                  child: appIcon),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.name,
                                    style: context.textTheme.headline6),
                                Text(
                                    (app.categories != null &&
                                            app.categories!.isNotEmpty
                                        ? app.categories!.join(', ')
                                        : "N.A."),
                                    style: context.textTheme.bodyText2),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (app.url != null && url.isNotEmpty)
                            Tooltip(
                              message: url,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (url.contains('github.com', 0)) {
                                      List<String> v = url.split('github.com');
                                      var u =
                                          'https://api.github.com/repos' + v[1];
                                      List response = (await Dio().get(u)).data;
                                      if (response.isNotEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DownloadDialog(
                                                  response, appIcon,
                                                  (checkmap) async {
                                                // debugPrint(checkmap.value);
                                                var location = "/" +
                                                    (await getApplicationDocumentsDirectory())
                                                        .toString()
                                                        .split('/')
                                                        .toList()
                                                        .sublist(1, 3)
                                                        .join("/") +
                                                    "/Applications/";
                                                if (!Directory(location)
                                                    .existsSync()) {
                                                  Directory(location)
                                                      .createSync();
                                                }
                                                if (checkmap.isNotEmpty) {
                                                  var fileurl =
                                                      checkmap.keys.toList()[0];
                                                  String filename = checkmap
                                                      .values
                                                      .toList()[0];
                                                  ref
                                                      .watch(
                                                          isDownloadingProvider
                                                              .notifier)
                                                      .toggleValue();
                                                  CancelToken cancelToken =
                                                      CancelToken();
                                                  listDownloads.add(
                                                    QueryApp(
                                                        name: filename,
                                                        url: url,
                                                        cancelToken:
                                                            cancelToken,
                                                        downloadLocation:
                                                            location,
                                                        actualBytes: 0,
                                                        totalBytes: 0),
                                                  );
                                                  await Dio().download(fileurl,
                                                      location + filename,
                                                      onReceiveProgress:
                                                          (recieved, total) {
                                                    var item = listDownloads[
                                                        listDownloads
                                                            .indexWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    filename)];
                                                    item.actualBytes = recieved;
                                                    item.totalBytes = total;
                                                  },
                                                      cancelToken:
                                                          cancelToken).whenComplete(
                                                      () => ref
                                                          .watch(
                                                              isDownloadingProvider
                                                                  .notifier)
                                                          .toggleValue());
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
                                  child: const Text("Download")),
                            )
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(children: [
                  if (app.screenshotsUrl != null &&
                      app.screenshotsUrl!.isNotEmpty)
                    CarouselSlider.builder(
                      carouselController: _controller,
                      itemCount: app.screenshotsUrl!.length,
                      itemBuilder: (context, index, i) {
                        String screenUrl =
                            app.screenshotsUrl![index].startsWith('http')
                                ? app.screenshotsUrl![index]
                                : prefixUrl + app.screenshotsUrl![index];
                        Widget brokenImageWidget = SvgPicture.network(
                          brokenImageUrl,
                          color: context.isDark ? Colors.white : Colors.black,
                        );
                        return Container(
                          height: 400,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: app.screenshotsUrl != null
                              ? screenUrl.endsWith('.svg')
                                  ? SvgPicture.network(screenUrl)
                                  : CachedNetworkImage(
                                      imageUrl: screenUrl,
                                      placeholder: (c, b) => const Center(
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
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (idx, rsn) {
                            _current.value = idx;
                          }),
                    ),
                  const SizedBox(height: 5),
                  if (app.screenshotsUrl != null &&
                      app.screenshotsUrl!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(app.screenshotsUrl!.length, (index) {
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
                              color: _current.value == index
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
                    child: RichText(
                        text: HTML.toTextSpan(
                            context,
                            (app.description != null &&
                                    app.description!
                                        .toString()
                                        .trim()
                                        .isNotEmpty)
                                ? app.description!
                                : "No Description Found",
                            defaultTextStyle: context.textTheme.bodyText1!)),
                  ),
                  twoRowContainer(
                    context,
                    primaryT: "License",
                    secondaryT: app.license ?? "N.A.",
                  ),
                  twoRowContainer(
                    context,
                    primaryT: "Authors",
                    secondaryT: app.authors != null
                        ? app.authors!
                            .map((e) =>
                                '<a href="${e['url']}" >${e['name']}</a>')
                            .join(', ')
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

  const DownloadDialog(this.response, this.appIcon, this.onEndPressed,
      {Key? key})
      : super(key: key);

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
              if (checkmap.value.containsKey(g[idx]['browser_download_url'])) {
                checkmap.value.removeWhere(
                    (key, value) => key == g[idx]['browser_download_url']);
              } else {
                checkmap.value.putIfAbsent(
                    g[idx]['browser_download_url'], () => g[idx]['name']);
              }
              checkedValue.value =
                  checkmap.value.containsKey(g[idx]['browser_download_url']);
            },
          );
        });
      },
      endText: TextButton(
          onPressed: () async {
            if (widget.onEndPressed != null) {
              widget.onEndPressed!(checkmap.value);
            }
            Navigator.of(context).pop();
          },
          child: const Text(
            "Download",
            style: TextStyle(fontSize: 18),
          )),
      img: widget.appIcon,
    );
  }
}
