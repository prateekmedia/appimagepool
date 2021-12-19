import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/translations/translations.dart';
import 'package:appimagepool/widgets/widgets.dart';

Widget appimageAboutDialog(BuildContext context) {
  return RoundedDialog(children: [
    Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
                imageUrl:
                    'https://avatars.githubusercontent.com/u/16617932?s=80&v=4'),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
              child: SelectableText(
                "AppImage",
                style: context.textTheme.headline5!.copyWith(letterSpacing: 1),
              ),
            ),
            SelectableText(AppLocalizations.of(context)!.appimageSlogan,
                style: context.textTheme.bodyText2!.copyWith(letterSpacing: 2)),
            const SizedBox(height: 10),
            SelectableText(
              AppLocalizations.of(context)!.appimageDescription,
              style: context.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Tooltip(
              message: appimageWebsite,
              child: RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.knowMore,
                  style: linkStyle(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = appimageWebsite.launchIt,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ]);
}
