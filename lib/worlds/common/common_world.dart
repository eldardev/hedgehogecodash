import 'package:flame/components.dart';

class CommonWorld extends World {
  static double cameraWidth = 2400;
  static double cameraHeight = 1080;

  CameraComponent get camera {
    return CameraComponent.withFixedResolution(
      world: this,
      width: CommonWorld.cameraWidth,
      height: CommonWorld.cameraHeight,
    )
      ..viewfinder.anchor = Anchor.topLeft
      ..viewfinder.position = Vector2(0, 0);
  }

  static double centerX = cameraWidth / 2;
  static double centerY = cameraHeight / 2;
}
