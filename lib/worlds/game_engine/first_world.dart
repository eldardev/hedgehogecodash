import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/game_engine/components/background.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/exit.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/loader/level_loader.dart';

import 'components/urchin.dart';

@singleton
class FirstWorld extends CommonWorld with TapCallbacks, HasCollisionDetection {
  int score = 0;
  int scoreWhenTrueExit = 1;
  int scoreWhenFalseExit = 1;
  late SpriteAnimationComponent urchinSprite;
  double maxDeltaTime = 0.025;
  Urchin? currentUrchin;
  Basket? currentBasket;
  List<Basket> basketList = [];
  List<Urchin> urchinList = [];

  //double scale = 0.1;
  SpriteComponent spriteComponentBG = SpriteComponent();
  double worldTime = 0;
  late TextComponent scoreText1;
  late TextComponent scoreText2;

  @override
  Future<void> onLoad() async {
    //final levelConfig = await LevelLoader.fetchLevel(1);

    debugMode = false;
    score = 0;
    await Flame.images.loadAll([
      'maps/map_01.png',
      'stump.png',
      'lightStump.png',
      'lightUrchin.png',
      'urchin.png',
      'items/itemApple.png',
      'items/itemCherry.png',
      'items/itemFlower.png',
      'items/itemMushroom.png',
      'items/itemPear.png',
      'items/itemAppleMarker.png',
      'items/itemCherryMarker.png',
      'items/itemFlowerMarker.png',
      'items/itemMushroomMarker.png',
      'items/itemPearMarker.png',
      'garbage/allGarbageBasket.png',
      'garbage/garbageBasketLight.png',
      'garbage/metallicGarbageBasket.png',
      'garbage/metallicGarbageItem.png',
      'garbage/metallicGarbageLight.png',
      'garbage/organicGarbageBasket.png',
      'garbage/organicGarbageItem.png',
      'garbage/organicGarbageLight.png',
      'garbage/paperGarbageBasket.png',
      'garbage/paperGarbageItem.png',
      'garbage/paperGarbageLight.png',
      'garbage/plasticGarbageItem.png',
      'garbage/plasticGarbageLight.png',
      'garbage/plasticGarbageBasket.png',
      'garbage/sortGarbageBasket.png'
    ]);
    // var a= Flame.images.fromCache(name)
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

    add(Background());
    var firstUrchin =
        Urchin(speed: 100, checkPointList: positionList1, birthTime: 0)
          ..priority = 3;
    var secondUrchin =
        Urchin(speed: 100, checkPointList: positionList2, birthTime: 3)
          ..priority = 3;
    var urchin3 =
        Urchin(speed: 500, checkPointList: positionList3, birthTime: 5)
          ..priority = 3;

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

    var item1 = Items(itemType: 4);
    var item2 = Items(itemType: 2);
    var item3 = Items(itemType: 1);
    firstUrchin.itemList.add(item1);
    secondUrchin.itemList.add(item2);
    urchin3.itemList.add(item3);

    item1.setNewHolder(firstUrchin);
    item2.setNewHolder(secondUrchin);
    item3.setNewHolder(urchin3);

    add(Exit(exitType: 1)
      ..position = Vector2(1437, 100)
      ..priority = 1);
    add(Exit(exitType: 2)
      ..position = Vector2(2300, 567)
      ..priority = 1);

    TextPaint textPaintOrange = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        color: Colors.orange,
        fontFamily: 'Awesome Font',
        fontWeight: FontWeight.w900,
      ),
    );
    TextPaint textPaintYellow = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        color: Colors.yellow,
        fontFamily: 'Awesome Font',
        fontWeight: FontWeight.w900,
      ),
    );
    scoreText1 = TextComponent(
        text: 'Score : ',
        position: Vector2.all(16.0),
        textRenderer: textPaintOrange);
    scoreText2 = TextComponent(
        text: '${score}',
        position: Vector2(290.0, 16),
        textRenderer: textPaintYellow);
    add(scoreText1);
    add(scoreText2);

    super.onLoad();
  }

  void deactivateAllUrchin() {
    for (var urchin in urchinList) {
      urchin.deActivateUrchinLight();
    }
    currentUrchin = null;
  }

  void deactivateAllBasket() {
    for (var basket in basketList) {
      basket.deActivateBasketLight();
    }
    currentBasket = null;
  }

  void selectCurrentUrchin({required Urchin currentUrchin}) {
    deactivateAllUrchin();
    this.currentUrchin = currentUrchin;
    currentUrchin.activateUrchinLight();
    if (currentBasket != null) {
      if ((currentBasket?.itemList.isNotEmpty ?? false) &&
          (currentUrchin.itemList.isEmpty ?? false)) {
        Items? currentItem = currentBasket?.itemList.last;
        if (currentItem != null) {
          currentItem.itemSpriteComponent.playing = true;
          currentItem.setNewHolder(currentUrchin);
          currentUrchin.itemList.add(currentItem);
          currentBasket?.itemList.clear();
        }
        deactivateAllBasket();
        deactivateAllUrchin();
      } else {
        deactivateAllBasket();
        deactivateAllUrchin();
        if (currentBasket?.itemList.isNotEmpty ?? false) {
          print('currentBasket?.item = NULL');
        }
      }
    }
  }

  void selectCurrentBasket({required Basket currentBasket}) {
    deactivateAllBasket();
    this.currentBasket = currentBasket;
    currentBasket.activateBasketLight();

    if (currentUrchin != null) {
      if ((currentUrchin?.itemList.isNotEmpty ?? false) &&
          (currentBasket.itemList.isEmpty ?? false)) {
        Items? currentItem = currentUrchin?.itemList.last;
        if (currentItem != null) {
          currentItem.itemSpriteComponent.playing = false;
          currentItem.setNewHolder(currentBasket);
          currentBasket.itemList.add(currentItem);
          currentUrchin?.itemList.clear();
        }
        deactivateAllBasket();
        deactivateAllUrchin();
      } else {
        deactivateAllBasket();
        deactivateAllUrchin();
        if ((currentUrchin?.itemList.isEmpty ?? false))
          print('currentUrchin?.item = NULL');
      }
    }
  }

  void setScore(int score) {
    this.score = score;
    scoreText2.text = '$score';
  }

  @override
  void update(double dt) {
    if (dt > maxDeltaTime) {
      dt = maxDeltaTime;
    }
    super.update(dt);
    worldTime += dt;
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
