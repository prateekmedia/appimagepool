import 'package:gtk/gtk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final gnomeThemeProvider = ChangeNotifierProvider((_) => GnomeThemeProvider());
