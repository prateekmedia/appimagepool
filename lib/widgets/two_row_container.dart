import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

import 'package:appimagepool/utils/utils.dart';

Widget twoRowContainer(
  BuildContext context, {
  String primaryT = "",
  String secondaryT = "",
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          primaryT,
          style: context.textTheme.headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        SelectableText.rich(HTML.toTextSpan(
          context,
          secondaryT,
          linksCallback: (link) => link.toString().launchIt(),
          defaultTextStyle: context.textTheme.bodyText1!
              .copyWith(fontWeight: FontWeight.w500),
        )),
      ],
    ),
  );
}
