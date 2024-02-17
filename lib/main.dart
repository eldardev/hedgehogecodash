import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';

import 'di/injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  configureDependencies();

  final game = diContainer<UrchinGame>();
  runApp(GameWidget(game: game));
}
