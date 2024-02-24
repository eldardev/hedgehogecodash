import 'package:json_annotation/json_annotation.dart';

part 'scenario.g.dart';

@JsonSerializable(createToJson: false)
class Scenario {
  Scenario({
    required this.kind,
    required this.sound,
    required this.startFrom,
    required this.loud,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);

  String? kind;
  String? sound;

  @JsonKey(name: 'startfrom')
  String? startFrom;
  String? loud;
}
