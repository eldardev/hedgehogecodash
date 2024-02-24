import 'package:json_annotation/json_annotation.dart';

import 'models/common.dart';
import 'models/exitmarks.dart';
import 'models/paths.dart';
import 'models/points.dart';
import 'models/scenario.dart';
import 'models/trashes.dart';

part 'level_config.g.dart';

@JsonSerializable(createToJson: false)
class LevelConfig {
  LevelConfig({
    required this.common,
    required this.trashes,
    required this.exitMarks,
    required this.points,
    required this.paths,
    required this.scenario,
  });

  factory LevelConfig.fromJson(Map<String, dynamic> json) =>
      _$LevelConfigFromJson(json);

  Common? common;
  List<Trashes>? trashes;

  @JsonKey(name: 'exitmarks')
  List<Exitmarks>? exitMarks;
  List<Points>? points;
  List<Paths>? paths;
  List<Scenario>? scenario;
}
