import 'package:appimagepool/src/constants/constants.dart';

class Credits {
  Credits({
    required this.name,
    required this.username,
    required this.description,
  });

  final String name;
  final String username;
  final String description;

  String get url => github + username;
}
