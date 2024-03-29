import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';

class LevelsButton extends PositionComponent
    with HasGameRef<UrchinGame>, TapCallbacks {
  static const double _width = 300;
  static const double _height = 100;
  late TextComponent levelsButton;

  LevelsButton()
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
    levelsButton=   TextComponent(
        key: ComponentKey.named('levels_button'),
        text: 'Levels',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 80.0,
            fontFamily: "Gogono Cocoa Mochi",
            color: const Color(0xFFFA9933),
          ),
        ),
        position: Vector2(rect.x, rect.y));

    await add(
   levelsButton,
    );

    await add(
      TextComponent(
          text: 'Levels',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color.fromARGB(80, 255, 153, 51),
            ),
          ),
          position: Vector2(rect.x + 8, rect.y + 8)),
    );

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    levelsButton.textRenderer = TextPaint(
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
    levelsButton.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        fontFamily: "Gogono Cocoa Mochi",
        color: const Color(0xFFFA9933),
      ),
    );
    gameRef.router.pushReplacementNamed("level_select");
    super.onTapUp(event);
  }
}
