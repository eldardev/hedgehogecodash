import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class LevelDoneFlowerComponent extends SpriteAnimationComponent {
  LevelDoneFlowerComponent()
      : super(size: Vector2.all(160), position: Vector2(80, 580));

  @override
  Future<void> onLoad() async {
    final image = Flame.images.fromCache('menu/item_flower.png');
    //SpriteAnimation
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(160),
        stepTime: 0.70,
      ),
    );

    if (animation != null) {
      final animationTicker = SpriteAnimationTicker(animation!);
    }

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
