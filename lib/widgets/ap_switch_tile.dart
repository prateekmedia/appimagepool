import 'package:appimagepool/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:libadwaita/libadwaita.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          AdwSwitch(
            value: value,
            activeColor: context.theme.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
