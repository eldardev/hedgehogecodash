import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';
import 'package:urchin/worlds/common/common_world.dart';

class LevelBuilderButton extends PositionComponent
    with HasGameRef<UrchinGame>, TapCallbacks {
  static const double _width = 300;
  static const double _height = 100;
  LevelBuilderButton()
      : super(
            position:
                Vector2(CommonWorld.centerX - 150, CommonWorld.centerY + 150),
            size: Vector2(_width, _height),
            anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    final rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.red);
    add(rect);

    await add(
      TextComponent(
          text: 'Level Builder',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 48.0,
              color: Colors.white,
            ),
          ),
          position: Vector2(rect.x, rect.y)),
    );

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.router.pushReplacementNamed("level_builder");
    super.onTapDown(event);
  }
}
