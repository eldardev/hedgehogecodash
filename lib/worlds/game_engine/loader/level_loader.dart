import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:urchin/worlds/game_engine/loader/level_config.dart';

class LevelLoader {
  static Future<LevelConfig> fetchLevel(int level) async {
    final data = await rootBundle.loadString('assets/levels/level_$level.json');
    return LevelConfig.fromJson(jsonDecode(data));
  }
}
