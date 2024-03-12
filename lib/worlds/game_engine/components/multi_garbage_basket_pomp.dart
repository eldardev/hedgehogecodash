import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';

import 'garbage_basket.dart';

class MultiGarbageBasketPOMP extends PositionComponent {
  late GarbageBasket plastic, organic, metallic, paper;
  late SpriteComponent background;
  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
     background = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('garbage/allGarbageBasket.png')));
    background.anchor = Anchor.center;
    add(background);

    plastic = GarbageBasket(garbageType: GarbageType.plastic.index)..position=Vector2(-197, 38);
    organic = GarbageBasket(garbageType: GarbageType.organic.index)..position=Vector2(-49, 38);
    metallic = GarbageBasket(garbageType: GarbageType.metallic.index)..position=Vector2(99, 38);
    paper = GarbageBasket(garbageType: GarbageType.paper.index)..position=Vector2(247, 38);
    add(plastic);
    add(organic);
    add(metallic);
    add(paper);
    super.onLoad();
  }

  void removeComponents() {
    background.parent = this;
    remove(background);

    plastic.parent = this;
    plastic.removeComponents();
    remove(plastic);

    organic.parent = this;
    organic.removeComponents();
    remove(organic);

    metallic.parent = this;
    metallic.removeComponents();
    remove(metallic);

    paper.parent = this;
    paper.removeComponents();
    remove(paper);
  }
}
