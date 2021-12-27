import 'package:flutter/cupertino.dart';

import 'package:appimagepool/utils/utils.dart';

class ApSwitchTile extends StatelessWidget {
  const ApSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        CupertinoSwitch(
          value: value,
          activeColor: context.theme.primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
