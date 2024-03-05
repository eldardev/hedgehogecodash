import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class LevelDoneFlowerComponent extends SpriteAnimationComponent {
  LevelDoneFlowerComponent()
      : super(
            size: Vector2.all(160),
            position: Vector2(160, 650),
            anchor: Anchor.center,
            scale: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    final image = Flame.images.fromCache('menu/item_flower.png');
    //SpriteAnimation
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2.all(160),
        stepTime: 0.70,
      ),
    );

    if (animation != null) {
      final animationTicker = SpriteAnimationTicker(animation!);
    }

    add(RectangleHitbox(collisionType: CollisionType.passive));

    final effectFirst =
        ScaleEffect.to(Vector2(1.1, 1.1), EffectController(duration: 0.5));

    final effectSecond =
        ScaleEffect.to(Vector2(0.9, 0.9), EffectController(duration: 0.5));

    final effect = SequenceEffect([effectFirst, effectSecond], infinite: true);

    add(effect);
  }
}
