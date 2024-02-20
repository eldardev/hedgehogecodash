import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';

@singleton
class LevelBuilderWorld extends CommonWorld with TapCallbacks {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final sprite = await Sprite.load('maps/map_01.png');
    final size = Vector2(2400, 1080);
    final bgSprite = SpriteComponent(size: size, sprite: sprite);

    add(bgSprite);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!event.handled) {
      final touchPoint = event.localPosition;
      add(CircleComponent(
          position: touchPoint, radius: 12, anchor: Anchor.center));
      add(TextComponent(
          anchor: Anchor.center,
          text: 'x = ${touchPoint.x.floor()} \n y = ${touchPoint.y.floor()}',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.white,
            ),
          ),
          position: Vector2(touchPoint.x, touchPoint.y + 50)));
    }
    super.onTapDown(event);
  }
}
