import 'package:json_annotation/json_annotation.dart';

part 'path.g.dart';

@JsonSerializable(createToJson: false)
class Path {
  Path({
    required this.name,
    required this.points,
  });

  factory Path.fromJson(Map<String, dynamic> json) => _$PathFromJson(json);

  String? name;
  List<String>? points;
}
