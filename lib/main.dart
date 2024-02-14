import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';

void main() {
  final game = UrchinGame();
  runApp(GameWidget(game: game));
}
