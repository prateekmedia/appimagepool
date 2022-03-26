import 'dart:io';

import 'package:appimagepool/models/models.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:appimagepool/translations/translations.dart';
import 'utils.dart';

String localShareDir = (Platform.environment["HOME"] ?? "") + "/.local/share";

String applicationsDir = localShareDir + "/applications/";

String iconsDir = localShareDir + "/icons/";

const String appName = "AppImage Pool";

const String prefixUrl =
    "https://raw.githubusercontent.com/AppImage/appimage.github.io/master/database/";

const String github = "https://github.com/";

const String projectUrl = "https://github.com/prateekmedia/appimagepool";

const String appimageWebsite = "https://appimage.org/";

List<CreditsModel> developers = [
  CreditsModel(
    name: "Prateek Sunal",
    username: "prateekmedia",
    description: "Lead Developer",
  ),
];

List<CreditsModel> translators = [
  CreditsModel(
    name: "Heimen Stoffels",
    username: "Vistaus",
    description: "Dutch",
  ),
  CreditsModel(
    name: "Luna",
    username: "Rinnray",
    description: "Swedish",
  ),
  CreditsModel(
    name: "Artem",
    username: "Sovenok-Hacker",
    description: "Russian",
  ),
  CreditsModel(
    name: "Nushan Kodikara",
    username: "nushankodikara",
    description: "Sinhala",
  ),
  CreditsModel(
    name: "那思路(なしろ)",
    username: "mnipritom",
    description: "Chinese (Simplified)",
  ),
  CreditsModel(
    name: "Git-Fal7",
    username: "Git-Fal7",
    description: "Arabic",
  ),
  CreditsModel(
    name: "Mohamed Emad",
    username: "Hulxv",
    description: "Arabic",
  ),
  CreditsModel(
    name: "p-bo",
    username: "p-bo",
    description: "Czech",
  ),
  CreditsModel(
    name: "José Vidal",
    username: "josevidalrt",
    description: "Spanish",
  ),
  CreditsModel(
    name: "Eshagh",
    username: "eshagh79",
    description: "Persian",
  ),
  CreditsModel(
    name: "rojack",
    username: "rojack96",
    description: "Italian",
  )
];

TextStyle linkStyle(BuildContext context, [bool showUnderline = true]) =>
    TextStyle(
      color: context.isDark ? Colors.lightBlue[400] : Colors.blue,
      decoration: showUnderline ? TextDecoration.underline : null,
    );

const mobileWidth = 800;
Widget brokenImageWidget = const Icon(LucideIcons.helpCircle);

const Map<String, IconData> categoryIcons = {
  'Multimedia': LucideIcons.film,
  'Video': LucideIcons.video,
  'Audio': LucideIcons.headphones,
  'Science': LucideIcons.flaskConical,
  'System': LucideIcons.monitor,
  'Utility': LucideIcons.gauge,
  'Network': LucideIcons.barChart,
  'Development': LucideIcons.code2,
  'Education': LucideIcons.graduationCap,
  'Graphics': LucideIcons.album,
  'Office': LucideIcons.printer,
  'Game': LucideIcons.gamepad2,
  'Finance': LucideIcons.currency,
};

String categoryName(BuildContext context, String name) =>
    {
      'Multimedia': AppLocalizations.of(context)!.multimedia,
      'Video': AppLocalizations.of(context)!.video,
      'Audio': AppLocalizations.of(context)!.audio,
      'Science': AppLocalizations.of(context)!.science,
      'System': AppLocalizations.of(context)!.system,
      'Utility': AppLocalizations.of(context)!.utility,
      'Network': AppLocalizations.of(context)!.network,
      'Development': AppLocalizations.of(context)!.development,
      'Education': AppLocalizations.of(context)!.education,
      'Graphics': AppLocalizations.of(context)!.graphics,
      'Office': AppLocalizations.of(context)!.office,
      'Game': AppLocalizations.of(context)!.game,
      'Finance': AppLocalizations.of(context)!.finance,
      'Others': AppLocalizations.of(context)!.others,
    }[name] ??
    name;
