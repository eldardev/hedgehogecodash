import 'package:json_annotation/json_annotation.dart';

part 'exitmark.g.dart';

@JsonSerializable(createToJson: false)
class Exitmark {
  Exitmark({
    required this.kind,
    required this.name,
    required this.x,
    required this.y,
    required this.angle,
  });

  factory Exitmark.fromJson(Map<String, dynamic> json) =>
      _$ExitmarkFromJson(json);

  String? kind;
  String? name;
  String? x;
  String? y;
  String? angle;
}
