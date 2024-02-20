import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';

import '../first_world.dart';
import 'items.dart';

class Basket extends PositionComponent with TapCallbacks {
  late SpriteAnimationComponent lightSpriteAnim;
  FirstWorld? world;
  List<Items>? itemsList;

  Basket() : super(size: Vector2(460, 320)) {
    world = GetIt.I.get<FirstWorld>();
  }

  @override
  Future<void> onLoad() async {
    var basketSprite = await Sprite.load('stump.png');
    final basketSpriteComponent = SpriteComponent(
        size: size, sprite: basketSprite, anchor: Anchor.center);
    add(basketSpriteComponent);

    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(200),
      amount: 4,
      stepTime: 0.1,
    );
    lightSpriteAnim = SpriteAnimationComponent.fromFrameData(
      await Flame.images.load('lightStump.png'),
      data,
    )..anchor = Anchor.center.. position=Vector2(-10, -15);

    //add(stumpSpriteAnim);
    super.onLoad();
  }

  void activateBasketLight() {
    //  if (urchinLightSprite.isRemoved) {
    lightSpriteAnim.priority = 1;
    add(lightSpriteAnim);
    // }
  }

  void deActivateBasketLight() {
    if (lightSpriteAnim.isMounted) {
      remove(lightSpriteAnim);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    for (var basket in world!.basketList) {
      basket.deActivateBasketLight();
    }
    activateBasketLight();
    if (!contains(lightSpriteAnim)) {
      activateBasketLight();
    } else {
      deActivateBasketLight();
    }
    world?.selectCurrentBasket(currentBasket: this);
    super.onTapDown(event);
  }
}
