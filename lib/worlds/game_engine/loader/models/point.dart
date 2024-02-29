import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

@JsonSerializable(createToJson: false)
class Point {
  Point({
    required this.id,
    required this.x,
    required this.y,
    required this.allowedgrubs
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  String? id;
  String? x;
  String? y;
  List<String>? allowedgrubs;
}
