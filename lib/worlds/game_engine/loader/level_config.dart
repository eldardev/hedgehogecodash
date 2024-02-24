import 'package:json_annotation/json_annotation.dart';

import 'models/common.dart';
import 'models/exitmarks.dart';
import 'models/logo.dart';
import 'models/paths.dart';
import 'models/points.dart';
import 'models/scenario.dart';
import 'models/score.dart';
import 'models/trashes.dart';

@JsonSerializable(createToJson: false)
class LevelConfig {
  LevelConfig({
    Common? common,
    List<Trashes>? trashes,
    List<Exitmarks>? exitmarks,
    List<Points>? points,
    List<Paths>? paths,
    List<Scenario>? scenario,
  }) {
    _common = common;
    _trashes = trashes;
    _exitmarks = exitmarks;
    _points = points;
    _paths = paths;
    _scenario = scenario;
  }

  LevelConfig.fromJson(dynamic json) {
    _common = json['common'] != null ? Common.fromJson(json['common']) : null;
    if (json['trashes'] != null) {
      _trashes = [];
      json['trashes'].forEach((v) {
        _trashes?.add(Trashes.fromJson(v));
      });
    }
    if (json['exitmarks'] != null) {
      _exitmarks = [];
      json['exitmarks'].forEach((v) {
        _exitmarks?.add(Exitmarks.fromJson(v));
      });
    }
    if (json['points'] != null) {
      _points = [];
      json['points'].forEach((v) {
        _points?.add(Points.fromJson(v));
      });
    }
    if (json['paths'] != null) {
      _paths = [];
      json['paths'].forEach((v) {
        _paths?.add(Paths.fromJson(v));
      });
    }
    if (json['scenario'] != null) {
      _scenario = [];
      json['scenario'].forEach((v) {
        _scenario?.add(Scenario.fromJson(v));
      });
    }
  }
  Common? _common;
  List<Trashes>? _trashes;
  List<Exitmarks>? _exitmarks;
  List<Points>? _points;
  List<Paths>? _paths;
  List<Scenario>? _scenario;
  LevelConfig copyWith({
    Common? common,
    List<Trashes>? trashes,
    List<Exitmarks>? exitmarks,
    List<Points>? points,
    List<Paths>? paths,
    List<Scenario>? scenario,
  }) =>
      LevelConfig(
        common: common ?? _common,
        trashes: trashes ?? _trashes,
        exitmarks: exitmarks ?? _exitmarks,
        points: points ?? _points,
        paths: paths ?? _paths,
        scenario: scenario ?? _scenario,
      );
  Common? get common => _common;
  List<Trashes>? get trashes => _trashes;
  List<Exitmarks>? get exitmarks => _exitmarks;
  List<Points>? get points => _points;
  List<Paths>? get paths => _paths;
  List<Scenario>? get scenario => _scenario;
}
