import 'package:adwaita/adwaita.dart';
import 'package:appimagepool/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';

import 'package:appimagepool/utils/utils.dart';
import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/translations/translations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPrefs().init();
  runApp(const ProviderScope(child: MyApp()));

  doWhenWindowReady(() {
    appWindow
      ?..alignment = Alignment.center
      ..title = "Pool"
      ..show();
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      theme: AdwaitaThemeData.light(),
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (supportedLocales.contains(deviceLocale)) {
          return deviceLocale;
        }
        return const Locale('en');
      },
      darkTheme: AdwaitaThemeData.dark(),
      themeMode: ref.watch(forceDarkThemeProvider),
      home: const HomePage(),
    );
  }
}
