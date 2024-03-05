import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BackPhotoBackground extends SpriteComponent with CollisionCallbacks {
  final int level;
  BackPhotoBackground({required this.level}) {
    sprite =
        Sprite(Flame.images.fromCache("back_photos/BackPhoto${level - 1}.jpg"));
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
