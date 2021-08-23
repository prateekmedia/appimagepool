import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';
import '../models/models.dart';

class CustomDialogBox extends HookConsumerWidget {
  final Widget img, endText;
  final List<Widget> Function(int index) items;
  final List<DownloadItem> downloadItems;
  final void Function(int version)? onVersionChange;

  const CustomDialogBox({
    Key? key,
    required this.items,
    required this.endText,
    required this.img,
    required this.downloadItems,
    this.onVersionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    const double padding = 20;
    const double avatarRadius = 45;

    final selectedIndex = useState(0);
    List<Widget> currentItem = items(selectedIndex.value);

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.only(
                left: padding, top: padding, right: padding, bottom: padding),
            margin: const EdgeInsets.only(top: avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: context.isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                      color: context.isDark
                          ? Colors.grey.shade900
                          : Colors.grey.shade500,
                      offset: const Offset(0, 10),
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
                  onChanged: (val) {
                    selectedIndex.value = val!;
                    if (onVersionChange != null) onVersionChange!(val);
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return downloadItems.map<Widget>((DownloadItem item) {
                      return Center(
                        child: Text(
                          item.version,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  items: downloadItems.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.value.version),
                          Text(DateFormat('MMM dd yyyy')
                              .format(entry.value.date)),
                        ],
                      ),
                      value: entry.key,
                    );
                  }).toList(),
                ),
                Text(
                  DateFormat('MMMM dd yyyy H:mm')
                      .format(downloadItems[selectedIndex.value].date),
                ),
                const SizedBox(height: 15),
                if (currentItem.isNotEmpty)
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: currentItem,
                    ),
                  )
                else
                  const Text("No AppImage Found in this Release"),
                const SizedBox(height: 22),
                endText,
              ],
            ),
          ),
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: avatarRadius,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(avatarRadius),
                  child: img),
            ),
          ),
        ],
      ),
    );
  }
}
