import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:urchin/urchin_game.dart';

class MainMenuButton extends PositionComponent
    with HasGameRef<UrchinGame>, TapCallbacks {
  static const double _width = 300;
  static const double _height = 100;

  MainMenuButton()
      : super(
            position: Vector2(500, 530),
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
          key: ComponentKey.named('main_menu_button'),
          text: 'Main Menu',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(
                0xFF003300,
              ),
            ),
          ),
          position: Vector2(rect.x, rect.y)),
    );

    await add(
      TextComponent(
          text: 'Main Menu',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color.fromARGB(80, 0, 51, 0),
            ),
          ),
          position: Vector2(rect.x + 8, rect.y + 8)),
    );

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    final button = gameRef.findByKeyName('main_menu_button') as TextComponent;
    button.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        fontFamily: "Gogono Cocoa Mochi",
        color: const Color(
          0xFF003300,
        ),
      ),
    );

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushReplacementNamed("menu");
    super.onTapUp(event);
  }
}
