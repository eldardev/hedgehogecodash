import 'package:json_annotation/json_annotation.dart';

part 'trash.g.dart';

@JsonSerializable(createToJson: false)
class Trash {
  Trash({
    required this.x,
    required this.y,
    required this.type,
    required this.items
  });

  factory Trash.fromJson(Map<String, dynamic> json) => _$TrashFromJson(json);

  String? x;
  String? y;
  String? type;
  List<String>? items;
}
