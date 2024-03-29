import 'package:json_annotation/json_annotation.dart';

part 'background.g.dart';

@JsonSerializable(createToJson: false)
class Background {
  Background({
    required this.kind,
    required this.name,
  });

  factory Background.fromJson(Map<String, dynamic> json) =>
      _$BackgroundFromJson(json);

  String? kind;
  String? name;
}
