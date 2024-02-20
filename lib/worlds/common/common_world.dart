import 'package:flame/components.dart';

class CommonWorld extends World {
  CameraComponent get camera {
    return CameraComponent.withFixedResolution(
      world: this,
      width: 2400,
      height: 1080,
    )
      ..viewfinder.anchor = Anchor.topLeft
      ..viewfinder.position = Vector2(0, 0);
  }
}
