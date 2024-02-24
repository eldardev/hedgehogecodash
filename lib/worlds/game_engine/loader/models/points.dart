import 'package:json_annotation/json_annotation.dart';

part 'points.g.dart';

@JsonSerializable(createToJson: false)
class Points {
  Points({
    required this.id,
    required this.x,
    required this.y,
  });

  factory Points.fromJson(Map<String, dynamic> json) => _$PointsFromJson(json);

  String? id;
  String? x;
  String? y;
}
