import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/game_engine/components/background.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/exit.dart';
import 'package:urchin/worlds/game_engine/components/exit_mark.dart';
import 'package:urchin/worlds/game_engine/components/garbage.dart';
import 'package:urchin/worlds/game_engine/components/garbage_basket.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/components/items_type.dart';
import 'package:urchin/worlds/game_engine/components/multi_garbage_basket_pomp.dart';
import 'package:urchin/worlds/game_engine/loader/level_loader.dart';
import 'package:urchin/worlds/game_engine/loader/models/buffer.dart';
import 'package:urchin/worlds/game_engine/loader/models/exitmark.dart';
import 'package:urchin/worlds/game_engine/loader/models/path.dart';
import 'package:urchin/worlds/game_engine/loader/models/point.dart';
import 'package:urchin/worlds/game_engine/loader/models/trash.dart';

import 'components/urchin.dart';

@singleton
class FirstWorld extends CommonWorld with TapCallbacks, HasCollisionDetection {
  int score = 0;
  int scoreWhenTrueExit = 1;
  int scoreWhenFalseExit = 1;

  double maxDeltaTime = 0.025;
  Urchin? currentUrchin;
  Basket? currentBasket;
  Garbage? currentGarbage;
  GarbageBasket? currentGarbageBasket;
  List<Vector2> pointList = [];
  List<Basket> basketList = [];
  List<Urchin> urchinList = [];
  List<Garbage> garbageList = [];
  List<GarbageBasket> garbageBasketList = [];
  Map<String, List<Vector2>> urchinPathList = {};
  SpriteComponent spriteComponentBG = SpriteComponent();
  double worldTime = 0;
  late TextComponent scoreText1;
  late TextComponent scoreText2;
  Vector2 scoreTextPosition = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    final levelConfig = await LevelLoader.fetchLevel(4);
    String levelBgName = levelConfig.common?.background?.name ?? '001.png';
    Vector2 scoreTextPosition = Vector2(
        double.parse(levelConfig.common?.score?.x ?? '0'),
        double.parse(levelConfig.common?.score?.y ?? '0'));
    debugMode = false;
    score = 0;
    await Flame.images.loadAll([
      'maps/$levelBgName',
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
      'garbage/sortGarbageButton.png'
    ]);
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
      Vector2(-1000, 840),
      Vector2(1110, 440),
      Vector2(1310, 305),
      Vector2(1430, 145),
      Vector2(1580, -100),
    ];
    List<Vector2> positionList3 = [
      Vector2(-2000, 900),
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
    //-------------------BACKGROUND------------------------
    add(Background(levelBgName));
    //--------------------------------------------------
    //-------------------BASKET_(BUFFER)_ARRAY------------------------
    List<Buffer> bufferList = levelConfig.buffers ?? [];
    for (var buffer in bufferList) {
      var basket1 = Basket()
        ..position = Vector2(
            double.parse(buffer.x ?? '0'), double.parse(buffer.y ?? '0'))
        ..angle = double.parse(buffer.angle ?? '0');
      add(basket1);
      basketList.add(basket1);
    }
    //---------------------------------------------------------------
    //-------------------GARBAGE_BASKET_(TRASH)_ARRAY------------------------
    List<Trash> trashList = levelConfig.trashes ?? [];
    for (var trash in trashList) {
      MultiGarbageBasketPOMP multiGarbageBasketPOMP = MultiGarbageBasketPOMP()
        ..position =
            Vector2(double.parse(trash.x ?? '0'), double.parse(trash.y ?? '0'));
      add(multiGarbageBasketPOMP);
    }
    //------------------------------------------------------
    //-------------------POINT_ARRAY------------------------
    List<Point> pointListInJson = levelConfig.points ?? [];
    for (var point in pointListInJson) {
      Vector2 currentPosition =
          Vector2(double.parse(point.x ?? '0'), double.parse(point.y ?? '0'));
      pointList.add(currentPosition);
      List<int> exitAllowedItemsList = [];
      List<String>? currentAllowedGrubsList = point.allowedgrubs;
      if (currentAllowedGrubsList != null) {
        for (var currentItem in currentAllowedGrubsList) {
          if (currentItem == ItemsType.cherry.name) {
            exitAllowedItemsList.add(ItemsType.cherry.index);
          } else if (currentItem == ItemsType.mushroom.name) {
            exitAllowedItemsList.add(ItemsType.mushroom.index);
          } else if (currentItem == ItemsType.flower.name) {
            exitAllowedItemsList.add(ItemsType.flower.index);
          } else if (currentItem == ItemsType.apple.name) {
            exitAllowedItemsList.add(ItemsType.apple.index);
          } else if (currentItem == ItemsType.pear.name) {
            exitAllowedItemsList.add(ItemsType.pear.index);
          }
        }
      }
      if (exitAllowedItemsList.isNotEmpty) {
        add(Exit(exitType: exitAllowedItemsList)..position = currentPosition);
      }
    }
    //----------------------------------------------------------
    //-------------------PATH_ARRAY------------------------
    List<UrchinPath>? pathListInJson = levelConfig.paths ?? [];
    for (var currentPath in pathListInJson) {
      String name = currentPath.name ?? '';

      List<Vector2> currentPathVectors = [];
      List<String> pointsJson = currentPath.points ?? [];
      for (var currentPointNumber in pointsJson) {
        int i = int.parse(currentPointNumber);
        if ((i-1) > 0 && (i-1)<=pointList.length) {
          currentPathVectors.add(pointList[i-1]);
        }
      }

      urchinPathList[name] = currentPathVectors;
    }
    //----------------------------------------------------------


    var firstUrchin =
    Urchin(currentSpeed: 500, checkPointList: urchinPathList['35']??[], birthTime: 0)
      ..priority = 3
      ..scale = Vector2.all(0.8);
    // var secondUrchin =
    // Urchin(currentSpeed: 100, checkPointList: positionList2, birthTime: 3)
    //   ..priority = 3;
    // var urchin3 =
    // Urchin(currentSpeed: 500, checkPointList: positionList3, birthTime: 5)
    //   ..priority = 3
    //   ..scale = Vector2.all(0.7);

    add(firstUrchin);
    // add(secondUrchin);
    // add(urchin3);

    //-------------------EXIT_MARK_ARRAY------------------------
    List<Exitmark> exitMarkList = levelConfig.exitMarks ?? [];
    for (var exitMark in exitMarkList) {
      int exitMarkType = 0;
      if (exitMark.name?.contains(ItemsType.pear.name) ?? false) {
        exitMarkType = ItemsType.pear.index;
      } else if (exitMark.name?.contains(ItemsType.mushroom.name) ?? false) {
        exitMarkType = ItemsType.mushroom.index;
      } else if (exitMark.name?.contains(ItemsType.cherry.name) ?? false) {
        exitMarkType = ItemsType.cherry.index;
      } else if (exitMark.name?.contains(ItemsType.apple.name) ?? false) {
        exitMarkType = ItemsType.apple.index;
      } else if (exitMark.name?.contains(ItemsType.flower.name) ?? false) {
        exitMarkType = ItemsType.flower.index;
      }

      add(ExitMark(exitType: exitMarkType)
        ..position = Vector2(
            double.parse(exitMark.x ?? '0'), double.parse(exitMark.y ?? '0'))
        ..angle = double.parse(exitMark.angle ?? '0')
        ..priority = 1);
    }
    //-----------------------------------------------------------
    urchinList.add(firstUrchin);
    // urchinList.add(secondUrchin);
    // urchinList.add(urchin3);

    var item1 = Items(itemType: 4);
    var item2 = Items(itemType: 2);
    var item3 = Items(itemType: 1);
    firstUrchin.itemList.add(item1);
    // secondUrchin.itemList.add(item2);
    // urchin3.itemList.add(item3);

    item1.setNewHolder(firstUrchin);
    // item2.setNewHolder(secondUrchin);
    // item3.setNewHolder(urchin3);

    TextPaint textPaintYellow = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        color: Colors.yellow,
        fontFamily: 'Awesome Font',
        fontWeight: FontWeight.w900,
      ),
    );
    scoreText2 = TextComponent(
        text: '$score',
        position: scoreTextPosition, //Vector2(280.0, 40),
        textRenderer: textPaintYellow);
    // add(scoreText1);
    add(scoreText2);

    Garbage garbage0 = Garbage(garbageType: 2);
    garbage0.position = Vector2(1000, 500);
    add(garbage0);
    garbageList.add(garbage0);

    Garbage garbage1 = Garbage(garbageType: 3);
    garbage1.position = Vector2(905, 620);
    add(garbage1);
    garbageList.add(garbage1);

    Garbage garbage2 = Garbage(garbageType: 1);
    garbage2.position = Vector2(1205, 720);
    add(garbage2);
    garbageList.add(garbage2);

    add(Exit(exitType: [ItemsType.mushroom.index, ItemsType.cherry.index])
      ..position = Vector2(2400, 600));

    super.onLoad();
  }

  void deactivateAllUrchin() {
    for (var urchin in urchinList) {
      urchin.deActivateUrchinLight();
    }
    currentUrchin = null;
  }

  void deactivateAllGarbageBasket() {
    for (var garbageBasket in garbageBasketList) {
      garbageBasket.deActivateGarbageBasket();
    }
    currentGarbageBasket = null;
  }

  void deactivateAllBasket() {
    for (var basket in basketList) {
      basket.deActivateBasketLight();
    }
    currentBasket = null;
  }

  void deactivateAllGarbage() {
    for (var garbage in garbageList) {
      garbage.deActivateGarbageLight();
    }
    currentGarbage = null;
  }

  void selectCurrentUrchin({required Urchin currentUrchin}) {
    deactivateAllUrchin();
    this.currentUrchin = currentUrchin;
    currentUrchin.activateUrchinLight();
    if (currentBasket != null) {
      if ((currentBasket?.itemList.isNotEmpty ?? false) &&
          (currentUrchin.itemList.isEmpty)) {
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
    deactivateAllGarbage();
    deactivateAllGarbageBasket();
  }

  void selectCurrentGarbage({required Garbage currentGarbage}) {
    deactivateAllBasket();
    deactivateAllUrchin();
    deactivateAllGarbage();

    this.currentGarbage = currentGarbage;
    currentGarbage.activateGarbageLight();
    moveGarbageTooGarbageBasket();
    deactivateAllGarbageBasket();
  }

  void selectCurrentGarbageBasket(
      {required GarbageBasket currentGarbageBasket}) {
    deactivateAllBasket();
    deactivateAllUrchin();

    deactivateAllGarbageBasket();
    this.currentGarbageBasket = currentGarbageBasket;
    currentGarbageBasket.activateGarbageBasket();
    moveGarbageTooGarbageBasket();
    deactivateAllGarbage();
  }

  void moveGarbageTooGarbageBasket() {
    if (currentGarbage != null && currentGarbageBasket != null) {
      var basket = currentGarbageBasket;
      var garbage = currentGarbage;
      Vector2 position1 =
          (currentGarbageBasket?.absolutePosition ?? Vector2(0, 0)) -
              Vector2(0, 200);
      Vector2 position2 =
          (currentGarbageBasket?.absolutePosition ?? Vector2(0, 0));
      final effectScaleTo0 = ScaleEffect.to(
        Vector2.all(0),
        EffectController(duration: 0.2),
      );

      var effectMoveToo2 = MoveToEffect(
        position2,
        EffectController(duration: 0.2),
      )..onComplete = () {
          deactivateAllGarbageBasket();
          deactivateAllGarbage();
          remove(garbage!);
        };
      var effectMoveToo1 = MoveToEffect(
        position1,
        EffectController(duration: 0.5),
      )..onComplete = () {
          if (garbage?.garbageType == basket?.garbageType) {
            score += 3;
            setScore(score);
          } else {
            score += 1;
            setScore(score);
          }
          garbage?.addAll([effectMoveToo2, effectScaleTo0]);
        };
      garbage?.add(effectMoveToo1);
    }
  }

  void selectCurrentBasket({required Basket currentBasket}) {
    deactivateAllBasket();
    this.currentBasket = currentBasket;
    currentBasket.activateBasketLight();

    if (currentUrchin != null) {
      if ((currentUrchin?.itemList.isNotEmpty ?? false) &&
          (currentBasket.itemList.isEmpty)) {
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
        // if ((currentUrchin?.itemList.isEmpty ?? false))
        //   print('currentUrchin?.item = NULL');
      }
    }
    deactivateAllGarbage();
    deactivateAllGarbageBasket();
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

// @override
// void onTapDown(TapDownEvent event) {
//   super.onTapDown(event);
// }
}
