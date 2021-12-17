import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:appimagepool/providers/providers.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:window_decorations/window_decorations.dart';

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
      backgroundColor: context.theme.canvasColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: appWindow.maximizeOrRestore,
                onPanStart: (v) => appWindow.startDragging(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DecoratedCloseButton(
                      onPressed: context.back,
                      type: ref.watch(themeTypeProvider),
                    ),
                  ],
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
