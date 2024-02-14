import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class WaterEnemyComponent extends SpriteAnimationComponent {
  WaterEnemyComponent() : super(size: Vector2.all(32));

  @override
  Future<void> onLoad() async {
    final image = Flame.images.fromCache('water_enemy.png');
    // Image image = Image.asset("assets/images/water_enemy");
    //SpriteAnimation
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );

    if (animation != null) {
      final animationTicker = SpriteAnimationTicker(animation!);
    }

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
