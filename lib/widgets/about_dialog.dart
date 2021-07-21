import 'package:appimagepool/screens/screens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/utils.dart';
import 'widgets.dart';

Widget aboutDialog(BuildContext context) {
  Future<PackageInfo> _initPackageInfo() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    return Future.value(_packageInfo);
  }

  return FutureBuilder<PackageInfo>(
    future: _initPackageInfo(),
    builder: (context, snapshot) => !snapshot.hasData
        ? Container()
        : roundedDialog(context, children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: CachedNetworkImageProvider(
                            'https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/appimagepool.png',
                          ),
                        ),
                      ),
                      width: 70,
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        "AppImage Pool",
                        style: context.textTheme.headline5!
                            .copyWith(letterSpacing: 1),
                      ),
                    ),
                    Text(
                      "V ${snapshot.data!.version}",
                      style: context.textTheme.bodyText2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Simplifying the way you browse, install and update your appimages. \n\nPowered by Flutter.",
                      style: context.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Tooltip(
                      message: projectUrl,
                      child: MaterialButton(
                        child: Text(
                          "View Source Code",
                          style: context.textTheme.bodyText2!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        color: Colors.blue[600],
                        onPressed: () {
                          projectUrl.launchIt();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: context.textTheme.bodyText1!.color),
                onPressed: () {
                  context.back();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const CustomLicensePage()));
                },
                child: const Text("View Licenses"),
              ),
              alignment: const Alignment(-0.95, 0.98),
            ),
          ]),
  );
}
