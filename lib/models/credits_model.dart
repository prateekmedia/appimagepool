import 'package:appimagepool/utils/constants.dart';

class CreditsModel {
  CreditsModel({
    required this.name,
    required this.username,
    required this.description,
  });

  final String name;
  final String username;
  final String description;

  String get url => github + username;
}
