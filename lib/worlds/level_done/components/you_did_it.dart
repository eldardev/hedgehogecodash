import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class YouDidIt extends PositionComponent {
  static const double _width = 300;
  static const double _height = 100;

  YouDidIt()
      : super(
            position: Vector2(865, 260),
            size: Vector2(_width, _height),
            anchor: Anchor.center,
            scale: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    final rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.transparent);

    add(rect);

    await add(
      TextComponent(
          text: 'Yes!',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: Color.fromARGB(255, 179, 86, 26),
            ),
          ),
          position: Vector2(rect.x + 100, rect.y)),
    );

    await add(
      TextComponent(
          text: 'Well Done!',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(
                0xFF003300,
              ),
            ),
          ),
          position: Vector2(rect.x, rect.y + 100)),
    );

    await add(
      TextComponent(
          text: 'You did it!',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(
                0xFF003300,
              ),
            ),
          ),
          position: Vector2(rect.x, rect.y + 200)),
    );
    final effectComplete =
        ScaleEffect.to(Vector2(0.9, 0.9), EffectController(duration: 0.5));
    final effect =
        ScaleEffect.to(Vector2(1.1, 1.1), EffectController(duration: 0.5))
          ..onComplete = () {
            add(effectComplete);
          };

    add(effect);

    super.onLoad();
  }
}
