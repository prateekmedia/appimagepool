import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../utils/utils.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class CustomDialogBox extends HookWidget {
  final Widget img, endText;
  final List<Widget> Function(int index) items;
  final List<String> versions;
  final void Function(int version)? onVersionChange;

  CustomDialogBox({
    Key? key,
    required this.items,
    required this.endText,
    required this.img,
    required this.versions,
    this.onVersionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    List<Widget> currentItem = items(selectedIndex.value);
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
                DropdownButton<int>(
                  isExpanded: true,
                  value: selectedIndex.value,
                  underline: Container(),
                  onChanged: (int) {
                    selectedIndex.value = int!;
                    if (onVersionChange != null) onVersionChange!(int);
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return versions.map<Widget>((String item) {
                      return Center(
                          child: Text(item,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600)));
                    }).toList();
                  },
                  items: versions.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      child: Text(
                        entry.value,
                      ),
                      value: entry.key,
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                if (currentItem.length > 0)
                  ...currentItem
                else
                  Text("No AppImage Found in this Release"),
                SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: endText,
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
                  child: img),
            ),
          ),
        ],
      ),
    );
  }
}
