import 'package:url_launcher/url_launcher.dart';

extension UrlLauncher on String {
  launchIt() async => await launchUrl(Uri.parse(this));
}
