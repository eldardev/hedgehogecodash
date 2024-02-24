import 'package:json_annotation/json_annotation.dart';

part 'exitmarks.g.dart';

@JsonSerializable(createToJson: false)
class Exitmarks {
  Exitmarks({
    required this.kind,
    required this.name,
    required this.x,
    required this.y,
    required this.angle,
  });

  factory Exitmarks.fromJson(Map<String, dynamic> json) =>
      _$ExitmarksFromJson(json);

  String? kind;
  String? name;
  String? x;
  String? y;
  String? angle;
}
