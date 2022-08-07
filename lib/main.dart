import 'package:adwaita/adwaita.dart';
import 'package:appimagepool/home_page.dart';
import 'package:appimagepool/utils/configuration.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:appimagepool/providers/providers.dart';
import 'package:appimagepool/translations/translations.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Configuration().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (supportedLocales.contains(deviceLocale)) {
          return deviceLocale;
        }
        return const Locale('en');
      },
      builder: (_, child) {
        child = virtualWindowFrameBuilder(context, child);
        return child;
      },
      theme: AdwaitaThemeData.light(),
      darkTheme: AdwaitaThemeData.dark(),
      themeMode: ref.watch(forceDarkThemeProvider),
      home: const HomePage(),
    );
  }
}
