import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';

import '../first_world.dart';
import 'items.dart';

class Basket extends PositionComponent with TapCallbacks {
  late SpriteAnimationComponent lightSpriteAnim;
  FirstWorld world = GetIt.I.get<FirstWorld>();
  List<Items> itemList = [];

  Basket() : super(size: Vector2(200, 200), anchor: Anchor.center) {
    // world = GetIt.I.get<FirstWorld>();
  }

  @override
  Future<void> onLoad() async {
    final stumpImages = Flame.images.fromCache('stump.png');
    var basketSprite =  Sprite(stumpImages);
    final basketSpriteComponent = SpriteComponent(
        size: Vector2(500, 360), sprite: basketSprite, anchor: Anchor.center)
      ..anchor = Anchor.center;
    // basketSpriteComponent.position = Vector2(size.x/2 -100, size.y/2);
    add(basketSpriteComponent);
    basketSpriteComponent.position = Vector2(size.x / 2, size.y / 2);

    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(200),
      amount: 4,
      stepTime: 0.1,
    );
    final stumpLightImages = Flame.images.fromCache('lightStump.png');
    lightSpriteAnim = SpriteAnimationComponent.fromFrameData(
     stumpLightImages,
      data,
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 2)
      ..priority = 1
      ..paint.color = const Color(0x00000001).withOpacity(0.7);
    add(lightSpriteAnim);
    deActivateBasketLight();
    //add(stumpSpriteAnim);
    super.onLoad();
  }

  void activateBasketLight() {
    //  if (urchinLightSprite.isRemoved) {
    lightSpriteAnim.scale = Vector2.all(1);
    // lightSpriteAnim.position=Vector2(size.x/2, size.y/2);
    // lightSpriteAnim.paint.color = const Color(1).withOpacity(0.7);

    // }
  }

  void deActivateBasketLight() {
    lightSpriteAnim.scale = Vector2.all(0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // for (var basket in world!.basketList) {
    //   basket.deActivateBasketLight();
    // }
    // world.deactivateAllBasket();
    // activateBasketLight();
    // if (!contains(lightSpriteAnim)) {
    //   activateBasketLight();
    // } else {
    //   deActivateBasketLight();
    // }
    world.selectCurrentBasket(currentBasket: this);
    super.onTapDown(event);
  }
}
