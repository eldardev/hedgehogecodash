// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Common _$CommonFromJson(Map<String, dynamic> json) => Common(
      protocol: json['protocol'] as String?,
      created: json['created'] as String?,
      levelName: json['levelname'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      background: json['background'] == null
          ? null
          : Background.fromJson(json['background'] as Map<String, dynamic>),
      score: json['score'] == null
          ? null
          : Score.fromJson(json['score'] as Map<String, dynamic>),
      logo: json['logo'] == null
          ? null
          : Logo.fromJson(json['logo'] as Map<String, dynamic>),
    );
