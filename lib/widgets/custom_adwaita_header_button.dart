import 'package:flutter/material.dart';
import 'package:flutter_gtk/flutter_gtk.dart';

class CustomAdwaitaHeaderButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;

  const CustomAdwaitaHeaderButton({
    Key? key,
    this.child,
    this.onTap,
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
      padding: EdgeInsets.zero,
      child: TextButton(
        style: OutlinedButton.styleFrom(
          primary: ThemePicker.of(context).pick(
            light: AdwaitaLightColors.headerButtonPrimary,
            dark: AdwaitaDarkColors.headerButtonPrimary,
          ),
          textStyle: Theme.of(context).textTheme.subtitle2,
        ),
        child: child!,
        onPressed: onTap,
      ),
    );
  }
}
