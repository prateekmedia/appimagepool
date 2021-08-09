import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_decorations/window_decorations.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';

Dialog roundedDialog(BuildContext context,
    {required List<Widget> children, double height = 310, double width = 310}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          ...children,
          const Align(
            child: DecorCloseButton(),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    ),
  );
}

class DecorCloseButton extends HookConsumerWidget {
  const DecorCloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return DecoratedCloseButton(
      type: ref.read(themeTypeProvider),
      onPressed: context.back,
    );
  }
}
