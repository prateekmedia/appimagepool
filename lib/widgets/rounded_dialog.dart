import 'package:flutter/material.dart';
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
          Align(
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: context.back,
            ),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    ),
  );
}
