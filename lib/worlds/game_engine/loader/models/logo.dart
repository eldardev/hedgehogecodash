import 'package:json_annotation/json_annotation.dart';

part 'logo.g.dart';

@JsonSerializable(createToJson: false)
class Logo {
  Logo({
    required this.kind,
    required this.x,
    required this.y,
    required this.angle,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => _$LogoFromJson(json);

  String? kind;
  String? x;
  String? y;
  String? angle;
}
