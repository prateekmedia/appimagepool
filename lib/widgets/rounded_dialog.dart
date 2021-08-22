import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:nativeshell/nativeshell.dart';
import '../utils/utils.dart';

class RoundedDialog extends HookConsumerWidget {
  final List<Widget> children;
  final double height;
  final double width;

  const RoundedDialog({
    Key? key,
    required this.children,
    this.height = 310,
    this.width = 310,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              GtkHeaderBar.nativeshell(
                window: Window.of(context),
                themeType: ref.watch(themeTypeProvider),
                onClose: context.back,
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
