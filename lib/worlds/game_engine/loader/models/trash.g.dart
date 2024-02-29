// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trash _$TrashFromJson(Map<String, dynamic> json) => Trash(
      x: json['x'] as String?,
      y: json['y'] as String?,
      type: json['type'] as String?,
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
