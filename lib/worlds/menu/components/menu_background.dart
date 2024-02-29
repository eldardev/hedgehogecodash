import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class MenuBackground extends SpriteComponent with CollisionCallbacks {
  MenuBackground() {
    // size = Vector2(2400, 1080);
    sprite = Sprite(Flame.images.fromCache('menu/bg.png'));
    position = Vector2(size.x / 2, size.y / 2);
    anchor = Anchor.center;
    add(RectangleHitbox(
        position: position, anchor: anchor, size: size, isSolid: true));
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}
