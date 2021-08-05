import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';

class CustomAdwaitaHeaderButton extends StatelessWidget {
  final Widget child;

  const CustomAdwaitaHeaderButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 36,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: ThemePicker.of(context).pick(
            light: AdwaitaLightColors.headerButtonBorder,
            dark: AdwaitaDarkColors.headerButtonBorder,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemePicker.of(context).pick(
              light: AdwaitaLightColors.headerButtonBackgroundTop,
              dark: AdwaitaDarkColors.headerButtonBackgroundBottom,
            ),
            ThemePicker.of(context).pick(
              light: AdwaitaLightColors.headerButtonBackgroundTop,
              dark: AdwaitaDarkColors.headerButtonBackgroundBottom,
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
