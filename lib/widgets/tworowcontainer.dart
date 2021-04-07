import 'package:flutter/material.dart';
import '../utils/utils.dart';

Widget twoRowContainer(BuildContext context,
    {String primaryT = "", String secondaryT = ""}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          primaryT,
          style: context.textTheme.headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          secondaryT,
          style: context.textTheme.bodyText1!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
