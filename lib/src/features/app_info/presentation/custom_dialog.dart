import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/translations/translations.dart';

import '../../download/domain/download_item.dart';
import 'rounded_dialog.dart';

class CustomDialogBox extends HookConsumerWidget {
  final Widget img;
  final Widget? endItem;
  final List<Widget> Function(int index) items;
  final List<DownloadItem> downloadItems;
  final void Function(int version)? onVersionChange;

  const CustomDialogBox({
    Key? key,
    required this.items,
    required this.endItem,
    required this.img,
    required this.downloadItems,
    this.onVersionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final selectedIndex = useState(0);
    List<Widget> currentItem = items(selectedIndex.value);

    return RoundedDialog(
      width: 700,
      height: 500,
      start: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: ClipOval(child: img),
        ),
      ],
      end: [
        if (endItem != null) endItem!,
      ],
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<int>(
              isExpanded: true,
              value: selectedIndex.value,
              underline: Container(),
              icon: const Icon(
                LucideIcons.chevronsUpDown,
                size: 16,
              ),
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
                      Text(DateFormat('MMM dd yyyy').format(entry.value.date)),
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
            const Gap(15),
            if (currentItem.isNotEmpty)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: currentItem,
                ),
              )
            else
              Text(
                AppLocalizations.of(context)!.noAppImageInThisRelease,
              ),
          ],
        ),
      ],
    );
  }
}
