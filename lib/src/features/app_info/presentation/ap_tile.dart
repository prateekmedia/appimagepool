import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

import 'package:appimagepool/src/utils/utils.dart';

class ApTile extends StatelessWidget {
  const ApTile({
    Key? key,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: SelectableText.rich(
        HTML.toTextSpan(
          context,
          trailing,
          linksCallback: (link) => link.toString().launchIt(),
          defaultTextStyle: context.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
