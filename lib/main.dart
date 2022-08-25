import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';
import 'src/utils/configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Configuration().init();

  runApp(const ProviderScope(child: MyApp()));
}
