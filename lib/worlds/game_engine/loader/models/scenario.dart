import 'package:json_annotation/json_annotation.dart';

part 'scenario.g.dart';

@JsonSerializable(createToJson: false)
class Scenario {
  Scenario(
      {required this.kind,
      required this.sound,
      required this.startFrom,
      required this.loud,
      required this.actor,
      required this.path,
      required this.grub,
      required this.checkpoint,
      required this.speed,
      required this.delay,
      required this.trash,
      required this.point,
      required this.angle,
      required this.addBonuses,
      required this.scale});

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);

  String? kind;
  String? sound;

  @JsonKey(name: 'startfrom')
  String? startFrom;
  String? loud;
  String? actor;
  String? path;
  String? grub;
  String? checkpoint;
  String? speed;
  String? delay;
  String? trash;
  String? point;
  String? angle;
  @JsonKey(name: 'addbonuses')
  String? addBonuses;
  String? scale;
}
