import 'package:appimagepool/src/constants/constants.dart';
import 'package:appimagepool/src/utils/category_utils.dart';
import 'package:appimagepool/src/utils/extensions/category_iterable.dart';

Map getSimplifiedCategories(List value) {
  return value.groupBy((m) {
    List categori = m['categories'];
    List newList = [];
    for (var category in categori) {
      if (category != null && category.length > 0) {
        if (CategoryUtils.doesContain(category, ['AudioVideo'])) {
          newList.add('Multimedia');
        } else if (CategoryUtils.doesContain(category, ['Video'])) {
          newList.add('Video');
        } else if (CategoryUtils.doesContain(category, ['Audio', 'Music'])) {
          newList.add('Audio');
        } else if (CategoryUtils.doesContain(category, ['Photo'])) {
          newList.add('Graphics');
        } else if (CategoryUtils.doesContain(category, ['KDE'])) {
          newList.add('Qt');
        } else if (CategoryUtils.doesContain(category, ['GNOME'])) {
          newList.add('GTK');
        } else if (CategoryUtils.doesContain(category, [
          'Application',
          'AdventureGame',
          'Astronomy',
          'Chat',
          'InstantMessag',
          'Database',
          'Engineering',
          'Electronics',
          'HamRadio',
          'IDE',
          'News',
          'ProjectManagement',
          'Settings',
          'StrategyGame',
          'TextEditor',
          'TerminalEmulator',
          'Viewer',
          'WebDev',
          'WordProcessor',
          'X-Tool',
        ])) {
          newList.add('Others');
        } else {
          newList.add(category);
        }
      } else {
        newList.add("Others");
      }
    }
    return newList;
  });
}

String getScreenshotUrl(String screenshotUrl) {
  return screenshotUrl.startsWith('http')
      ? screenshotUrl
      : prefixUrl + screenshotUrl;
}
