import 'package:json_annotation/json_annotation.dart';

import 'models/common.dart';
import 'models/exitmark.dart';
import 'models/path.dart';
import 'models/point.dart';
import 'models/scenario.dart';
import 'models/trash.dart';

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
  List<Trash>? trashes;

  @JsonKey(name: 'exitmarks')
  List<Exitmark>? exitMarks;
  List<Point>? points;
  List<Path>? paths;
  List<Scenario>? scenario;
}
