import 'dart:ui';
import '../utils/utils.dart';
import 'package:flutter/material.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class CustomDialogBox extends StatefulWidget {
  final Widget img, endText;
  final List<Widget> items;
  final List<String> versions;

  const CustomDialogBox(
      {Key? key,
      required this.items,
      required this.endText,
      required this.img,
      required this.versions})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    String selectedItem = widget.versions[0];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: 700,
            ),
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: context.isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: context.isDark
                          ? Colors.grey.shade900
                          : Colors.grey.shade500,
                      offset: Offset(0, 10),
                      spreadRadius: 2,
                      blurRadius: 20),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedItem,
                  underline: Container(),
                  onChanged: (String? string) =>
                      setState(() => selectedItem = string!),
                  selectedItemBuilder: (BuildContext context) {
                    return widget.versions.map<Widget>((String item) {
                      return Center(
                          child: Text(item,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600)));
                    }).toList();
                  },
                  items: widget.versions.map((String item) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        item,
                      ),
                      value: item,
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                if (widget.items.length > 0)
                  ...widget.items
                else
                  Text("No AppImage Found in this Release"),
                SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: widget.endText,
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: widget.img),
            ),
          ),
        ],
      ),
    );
  }
}
