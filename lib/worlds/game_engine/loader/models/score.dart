import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable(createToJson: false)
class Score {
  Score({
    required this.x,
    required this.y,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  String? x;
  String? y;
}
