// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Point _$PointFromJson(Map<String, dynamic> json) => Point(
      id: json['id'] as String?,
      x: json['x'] as String?,
      y: json['y'] as String?,
      allowedgrubs: (json['allowedgrubs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
