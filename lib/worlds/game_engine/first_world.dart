import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';

import 'components/urchin.dart';

@singleton
class FirstWorld extends CommonWorld with TapCallbacks {
  late SpriteAnimationComponent urchinSprite;
  Urchin? currentUrchin;
  Basket? currentBasket;
  List<Basket> basketList = [];
  List<Urchin> urchinList = [];

  //double scale = 0.1;
  SpriteComponent spriteComponentBG = SpriteComponent();
  double worldTime = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    List<Vector2> positionList1 = [
      Vector2(-150, 1500),
      Vector2(400, 1000),
      Vector2(880, 790),
      Vector2(1450, 590),
      Vector2(1705, 550),
      Vector2(1980, 580),
      Vector2(2345, 668),
      Vector2(3000, 668)
    ];
    List<Vector2> positionList2 = [
      Vector2(-150, 840),
      Vector2(1110, 440),
      Vector2(1310, 305),
      Vector2(1430, 145),
      Vector2(1580, -100),
    ];
    List<Vector2> positionList3 = [
      Vector2(-150, 900),
      Vector2(900, 500),
      Vector2(1080, 380),
      Vector2(1208, 246),
      Vector2(1371, 204),
      Vector2(1480, 231),
      Vector2(1490, 346),
      Vector2(1543, 425),
      Vector2(1649, 463),
      Vector2(2100, 516),
      Vector2(2384, 618),
      Vector2(3000, 560)
    ];

    final sprite = await Sprite.load('maps/map_01.png');
    final size = Vector2(2400, 1080);
    final bgSprite = SpriteComponent(size: size, sprite: sprite);

    add(bgSprite);
    var firstUrchin =
        Urchin(speed: 250, checkPointList: positionList1, birthTime: 0);
    var secondUrchin =
        Urchin(speed: 400, checkPointList: positionList2, birthTime: 3);
    var urchin3 =
        Urchin(speed: 400, checkPointList: positionList3, birthTime: 5);
    add(firstUrchin);
    add(secondUrchin);
    add(urchin3);
    var basket1 = Basket()..position = Vector2(600, 240);
    add(basket1);
    var basket2 = Basket()..position = Vector2(1532, 920);
    add(basket2);
    basketList.add(basket1);
    basketList.add(basket2);

    urchinList.add(firstUrchin);
    urchinList.add(secondUrchin);
    urchinList.add(urchin3);

    var item1 = Items(itemType: 4)..itemHolder = firstUrchin;
    firstUrchin.itemsList.add(item1);

    var item2 = Items(itemType: 2)..itemHolder = secondUrchin;
    secondUrchin.itemsList.add(item2);

    var item3 = Items(itemType: 1)..itemHolder = urchin3;
    urchin3.itemsList.add(item3);

    firstUrchin.add(item1);
    secondUrchin.add(item2);
    urchin3.add(item3);
    // await Future.delayed(Duration(seconds: 5));
    // add(Items(speed: 400));

    // final tiledMap = await TiledComponent()
  }

  void deactivateAllUrchin(){
    for (var urchin in urchinList) {
      urchin.deActivateUrchinLight();
    }
    currentUrchin=null;
  }
  void deactivateAllBasket(){
    for (var basket in basketList) {
      basket.deActivateBasketLight();
    }
    currentBasket=null;
  }
  void selectCurrentUrchin({Urchin? currentUrchin}) {
    if (currentUrchin != null) {
      this.currentUrchin = currentUrchin;
    }
    if (this.currentUrchin != null && currentBasket != null) {
      Items? a = currentUrchin?.itemsList.last;
      currentUrchin?.add(a as PositionComponent);
      a?.anchor=Anchor.center;
      a?.priority=15;
     // currentBasket=null;
      deactivateAllUrchin();
      deactivateAllBasket();
    }
  }
  void selectCurrentBasket({Basket? currentBasket}) {
    if (currentBasket != null) {
      this.currentBasket = currentBasket;
    }

    if (currentUrchin != null && this.currentBasket != null) {
      if (currentUrchin!.itemsList.isNotEmpty) {
        Items? a = currentUrchin?.itemsList.last;
        a?.priority=15;
        currentBasket?.add(a as Component);
        //currentUrchin?.currentItems=null;
        //currentUrchin=null;
        deactivateAllUrchin();
        deactivateAllBasket();

      }
    }
  }
  @override
  void update(double dt) {
    super.update(dt);
    worldTime+=dt;
    // urchinSprite.position+=Vector2(1, -1);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // if (!event.handled) {
    //   final touchPoint = event.localPosition;
    //   print('TouchPosition = '+touchPoint.toString());
    //   add(CircleComponent(position: touchPoint, radius: 20, anchor: Anchor.center));
    // }
  }
}