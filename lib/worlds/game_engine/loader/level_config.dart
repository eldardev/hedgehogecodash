import 'package:json_annotation/json_annotation.dart';
import 'package:urchin/worlds/game_engine/loader/models/buffer.dart';

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
  @JsonKey(name: 'trashbox')
  List<Trash>? trashes;

  @JsonKey(name: 'exitmarks')
  List<Exitmark>? exitMarks;
  List<Buffer>? buffers; //basket
  List<Point>? points;
  List<UrchinPath>? paths;
  List<Scenario>? scenario;
}
