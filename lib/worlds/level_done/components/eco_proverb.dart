import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EcoProverb extends PositionComponent {
  static const double _width = 300;
  static const double _height = 100;

  EcoProverb()
      : super(
            position: Vector2(300, 100),
            size: Vector2(_width, _height),
            anchor: Anchor.center,
            scale: Vector2(1, 1));

  @override
  Future<void> onLoad() async {
    final rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.transparent);

    add(rect);

    await add(
      TextComponent(
          text: 'Protect What',
          textRenderer: TextPaint(
            style: const TextStyle(
                fontSize: 80.0,
                fontFamily: "Gogono Cocoa Mochi",
                color: Colors.white),
          ),
          position: Vector2(rect.x + 100, rect.y)),
    );

    await add(
      TextComponent(
          text: 'You Love!',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: Colors.white,
            ),
          ),
          position: Vector2(rect.x + 170, rect.y + 100)),
    );
    super.onLoad();
  }
}
