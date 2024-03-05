import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class FlowerComponent extends SpriteAnimationComponent {
  FlowerComponent()
      : super(
            size: Vector2.all(160),
            position: Vector2(410, 460),
            scale: Vector2(0, 0),
            anchor: Anchor.center);

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
