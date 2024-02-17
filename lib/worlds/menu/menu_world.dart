import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/urchin_game.dart';
import 'package:urchin/worlds/common/common_world.dart';

@singleton
class MenuWorld extends CommonWorld with HasGameRef<UrchinGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {
    await add(
      TextComponent(
          text: 'Tap anywhere',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 48.0,
              color: Colors.white,
            ),
          ),
          position: Vector2(1000, 500)),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.router.pushReplacementNamed("main");
  }
}
