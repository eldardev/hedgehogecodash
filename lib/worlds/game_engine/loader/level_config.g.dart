// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelConfig _$LevelConfigFromJson(Map<String, dynamic> json) => LevelConfig(
      common: json['common'] == null
          ? null
          : Common.fromJson(json['common'] as Map<String, dynamic>),
      trashes: (json['trashes'] as List<dynamic>?)
          ?.map((e) => Trashes.fromJson(e as Map<String, dynamic>))
          .toList(),
      exitMarks: (json['exitmarks'] as List<dynamic>?)
          ?.map((e) => Exitmarks.fromJson(e as Map<String, dynamic>))
          .toList(),
      points: (json['points'] as List<dynamic>?)
          ?.map((e) => Points.fromJson(e as Map<String, dynamic>))
          .toList(),
      paths: (json['paths'] as List<dynamic>?)
          ?.map((e) => Paths.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenario: (json['scenario'] as List<dynamic>?)
          ?.map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
