import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

const String prefixUrl =
    "https://raw.githubusercontent.com/AppImage/appimage.github.io/master/database/";

const String github = "https://github.com/";

const String projectUrl = "https://github.com/prateekmedia/appimagepool";

const String appimageWebsite = "https://appimage.org/";

TextStyle linkStyle(BuildContext context) => TextStyle(
      color: context.isDark ? Colors.lightBlue[400] : Colors.blue,
      decoration: TextDecoration.underline,
    );

const mobileWidth = 700;

Widget brokenImageWidget = const AdwaitaIcon(AdwaitaIcons.question);
const Map<String, String> categoryIcons = {
  'Video': AdwaitaIcons.video_x_generic,
  'Audio': AdwaitaIcons.audio_headphones,
  'Science': AdwaitaIcons.applications_science,
  'System': AdwaitaIcons.applications_system,
  'Utility': AdwaitaIcons.applications_utilities,
  'Network': AdwaitaIcons.network_cellular,
  'Development': AdwaitaIcons.applications_engineering,
  'Education': AdwaitaIcons.note,
  'Graphics': AdwaitaIcons.applications_graphics,
  'Office': AdwaitaIcons.x_office_document,
  'Game': AdwaitaIcons.applications_games,
  'Finance': AdwaitaIcons.money,
};
