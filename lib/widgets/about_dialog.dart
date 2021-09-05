import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'widgets.dart';
import '../utils/utils.dart';
import '../screens/screens.dart';

Widget aboutDialog(BuildContext context) {
  Future<PackageInfo> _initPackageInfo() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    return Future.value(_packageInfo);
  }

  return FutureBuilder<PackageInfo>(
    future: _initPackageInfo(),
    builder: (context, snapshot) => !snapshot.hasData
        ? const SizedBox()
        : RoundedDialog(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: SelectableText(
                          appName,
                          style: context.textTheme.headline5!.copyWith(letterSpacing: 1),
                        ),
                      ),
                      SelectableText(
                        "V ${snapshot.data!.version}",
                        style: context.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 20),
                      SelectableText(
                        "Simplifying the way you browse, install and update your appimages. \n\nPowered by Flutter.",
                        style: context.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'View Source Code',
                              style: linkStyle(context),
                              recognizer: TapGestureRecognizer()..onTap = projectUrl.launchIt,
                            ),
                            const WidgetSpan(
                              child: SizedBox(
                                width: 15,
                                child: Center(
                                  child: Text('•'),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: 'View Licenses',
                              style: linkStyle(context, false),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.back();
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) => const CustomLicensePage()));
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
  );
}
