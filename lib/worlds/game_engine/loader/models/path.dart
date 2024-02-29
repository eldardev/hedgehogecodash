import 'package:json_annotation/json_annotation.dart';

part 'path.g.dart';

@JsonSerializable(createToJson: false)
class UrchinPath {
  UrchinPath({
    required this.name,
    required this.points,
  });

  factory UrchinPath.fromJson(Map<String, dynamic> json) => _$UrchinPathFromJson(json);

  String? name;
  List<String>? points;
}
