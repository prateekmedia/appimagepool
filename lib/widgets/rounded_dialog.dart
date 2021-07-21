import 'package:flutter/material.dart';
import '../utils/utils.dart';

Dialog roundedDialog(BuildContext context, {required List<Widget> children}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: SizedBox(
      height: 310.0,
      width: 310.0,
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
