import 'package:json_annotation/json_annotation.dart';

import 'background.dart';
import 'logo.dart';
import 'score.dart';

part 'common.g.dart';

@JsonSerializable(createToJson: false)
class Common {
  Common({
    required this.protocol,
    required this.created,
    required this.levelName,
    required this.width,
    required this.height,
    required this.background,
    required this.score,
    required this.logo,
  });

  factory Common.fromJson(Map<String, dynamic> json) => _$CommonFromJson(json);

  String? protocol;
  String? created;

  @JsonKey(name: 'levelname')
  String? levelName;
  String? width;
  String? height;
  Background? background;
  Score? score;
  Logo? logo;
}
