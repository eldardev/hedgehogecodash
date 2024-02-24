import 'package:json_annotation/json_annotation.dart';

part 'paths.g.dart';

@JsonSerializable(createToJson: false)
class Paths {
  Paths({
    required this.name,
    required this.points,
  });

  factory Paths.fromJson(Map<String, dynamic> json) => _$PathsFromJson(json);

  String? name;
  List<String>? points;
}
