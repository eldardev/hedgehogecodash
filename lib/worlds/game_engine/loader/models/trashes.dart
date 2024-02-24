import 'package:json_annotation/json_annotation.dart';

part 'trashes.g.dart';

@JsonSerializable(createToJson: false)
class Trashes {
  Trashes({
    required this.x,
    required this.y,
    required this.type,
  });

  factory Trashes.fromJson(Map<String, dynamic> json) =>
      _$TrashesFromJson(json);

  String? x;
  String? y;
  String? type;
}
