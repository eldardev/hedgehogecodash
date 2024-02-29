import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';

class MenuButton extends PositionComponent
    with HasGameRef<UrchinGame>, TapCallbacks {
  static const double _width = 300;
  static const double _height = 100;

  MenuButton()
      : super(
            position: Vector2(500, 430),
            size: Vector2(_width, _height),
            anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    final rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.transparent);

    add(rect);

    await add(
      TextComponent(
          key: ComponentKey.named('play_button'),
          text: 'Play',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(0xFFFA9933),
            ),
          ),
          position: Vector2(rect.x, rect.y)),
    );

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    final playButton = gameRef.findByKeyName('play_button') as TextComponent;
    playButton.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        fontFamily: "Gogono Cocoa Mochi",
        color: const Color(0xFFFFFF02),
      ),
    );

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushReplacementNamed("main");
    super.onTapUp(event);
  }
}
