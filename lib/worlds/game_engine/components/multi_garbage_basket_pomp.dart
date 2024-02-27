import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';

import 'garbage_basket.dart';

class MultiGarbageBasketPOMP extends PositionComponent {
  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    SpriteComponent background = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('garbage/allGarbageBasket.png')));
    background.anchor = Anchor.center;
    add(background);

    add(GarbageBasket(garbageType: GarbageType.plastic.index)..position=Vector2(-197, 38));
    add(GarbageBasket(garbageType: GarbageType.organic.index)..position=Vector2(-49, 38));
    add(GarbageBasket(garbageType: GarbageType.metallic.index)..position=Vector2(99, 38));
    add(GarbageBasket(garbageType: GarbageType.paper.index)..position=Vector2(247, 38));
    super.onLoad();
  }
}
