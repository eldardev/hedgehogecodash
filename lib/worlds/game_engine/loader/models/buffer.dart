import 'package:json_annotation/json_annotation.dart';

part 'buffer.g.dart';

@JsonSerializable(createToJson: false)
class Buffer {
  Buffer({
    required this.kind,
    required this.name,
    required this.x,
    required this.y,
    required this.angle
  });

  factory Buffer.fromJson(Map<String, dynamic> json) => _$BufferFromJson(json);

  String? kind;
  String? name;
  String? x;
  String? y;
  String? angle;
}