import 'package:flutter/material.dart';

Widget aibAppBar(
    {bool forceElevated = false, String title = "", Widget? leading}) {
  return SliverAppBar(
    forceElevated: forceElevated,
    backgroundColor: Colors.grey[800],
    floating: true,
    leading: leading,
    title: Text(title),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          width: 36,
          height: 30,
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
          child: Center(child: Icon(Icons.download_sharp)),
        ),
      )
    ],
  );
}
