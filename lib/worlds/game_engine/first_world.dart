import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/game_engine/components/background.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/exit.dart';
import 'package:urchin/worlds/game_engine/components/exit_mark.dart';
import 'package:urchin/worlds/game_engine/components/garbage.dart';
import 'package:urchin/worlds/game_engine/components/garbage_basket.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/components/items_type.dart';
import 'package:urchin/worlds/game_engine/components/multi_garbage_basket_pomp.dart';
import 'package:urchin/worlds/game_engine/loader/level_config.dart';
import 'package:urchin/worlds/game_engine/loader/level_loader.dart';
import 'package:urchin/worlds/game_engine/loader/models/buffer.dart';
import 'package:urchin/worlds/game_engine/loader/models/exitmark.dart';
import 'package:urchin/worlds/game_engine/loader/models/path.dart';
import 'package:urchin/worlds/game_engine/loader/models/point.dart';
import 'package:urchin/worlds/game_engine/loader/models/scenario.dart';
import 'package:urchin/worlds/game_engine/loader/models/trash.dart';

import 'components/urchin.dart';

@singleton
class FirstWorld extends CommonWorld with TapCallbacks, HasCollisionDetection {
  int levelNumber = 1;
  int score = 0;
  int scoreWhenTrueExit = 1;
  int scoreWhenFalseExit = 1;
  LevelConfig? levelConfig;

  int gameScenarioStep = 0;
  double gameScenarioNextEventTime = 0;
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

  // FirstWorld({required this.levelNumber}){
  //
  // }

  @override
  Future<void> onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    levelNumber = prefs.getInt('currentLevel') ?? 4;
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(
        'music/Cute_Hedgehog_Compilation_Hedgehog_Escape_Giant_Macaron.mp3');

    levelConfig = await LevelLoader.fetchLevel(levelNumber);
    String levelBgName = levelConfig?.common?.background?.name ?? '001.png';
    Vector2 scoreTextPosition = Vector2(
        double.parse(levelConfig?.common?.score?.x ?? '0'),
        double.parse(levelConfig?.common?.score?.y ?? '0'));
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
    //-------------------BACKGROUND------------------------
    add(Background(levelBgName));
    //--------------------------------------------------
    //-------------------BASKET_(BUFFER)_ARRAY------------------------
    List<Buffer> bufferList = levelConfig?.buffers ?? [];

    print('levelConfig.scenario= ' +
        (levelConfig?.scenario?[1].actor.toString() ?? 'null'));
    for (var buffer in bufferList) {
      var currentBasket = Basket()
        ..position = Vector2(
            double.parse(buffer.x ?? '0'), double.parse(buffer.y ?? '0'))
        ..angle = double.parse(buffer.angle ?? '0');
      add(currentBasket);
      basketList.add(currentBasket);
    }
    //---------------------------------------------------------------
    //-------------------GARBAGE_BASKET_(TRASH)_ARRAY------------------------
    List<Trash> trashList = levelConfig?.trashes ?? [];
    for (var trash in trashList) {
      MultiGarbageBasketPOMP multiGarbageBasketPOMP = MultiGarbageBasketPOMP()
        ..position =
            Vector2(double.parse(trash.x ?? '0'), double.parse(trash.y ?? '0'));
      add(multiGarbageBasketPOMP);
    }
    //------------------------------------------------------
    //-------------------POINT_ARRAY------------------------
    List<Point> pointListInJson = levelConfig?.points ?? [];
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
    List<UrchinPath>? pathListInJson = levelConfig?.paths ?? [];
    for (var currentPath in pathListInJson) {
      String name = currentPath.name ?? '';

      List<Vector2> currentPathVectors = [];
      List<String> pointsJson = currentPath.points ?? [];
      for (var currentPointNumber in pointsJson) {
        int i = int.parse(currentPointNumber);
        if ((i - 1) >= 0 && (i - 1) <= pointList.length) {
          currentPathVectors.add(pointList[i - 1]);
        }
      }

      urchinPathList[name] = currentPathVectors;
    }
    //----------------------------------------------------------

    // var firstUrchin = Urchin(
    //     currentSpeed: 500,
    //     checkPointList: urchinPathList['25'] ?? [],
    //     birthTime: 0)
    //   ..priority = 3
    //   ..scale = Vector2.all(0.8);
    //
    // add(firstUrchin);
    // urchinList.add(firstUrchin);

    //-------------------EXIT_MARK_ARRAY------------------------
    List<Exitmark> exitMarkList = levelConfig?.exitMarks ?? [];
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

    // var item1 = Items(itemType: 4);
    //
    // firstUrchin.itemList.add(item1);
    // // secondUrchin.itemList.add(item2);
    // // urchin3.itemList.add(item3);
    //
    // item1.setNewHolder(itemHolder: firstUrchin, newbornHedgehog: true);
    // item2.setNewHolder(secondUrchin);
    // item3.setNewHolder(urchin3);

    TextPaint textPaintYellow = TextPaint(
      style: const TextStyle(
        fontSize: 70.0,
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

    // Garbage garbage0 = Garbage(garbageType: 2);
    // garbage0.position = Vector2(1000, 500);
    // add(garbage0);
    // garbageList.add(garbage0);
    //
    //
    // Garbage garbage2 = Garbage(garbageType: 1);
    // garbage2.position = Vector2(1205, 720);
    // add(garbage2);
    // garbageList.add(garbage2);

    // gameScenario();

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
    clickObject();
    deactivateAllUrchin();
    this.currentUrchin = currentUrchin;
    currentUrchin.activateUrchinLight();
    if (currentBasket != null) {
      if ((currentBasket?.itemList.isNotEmpty ?? false) &&
          (currentUrchin.itemList.isEmpty)) {
        Items? currentItem = currentBasket?.itemList.last;
        if (currentItem != null) {
          currentItem.itemSpriteComponent.playing = true;
          currentItem.setNewHolder(itemHolder: currentUrchin);
          currentUrchin.itemList.add(currentItem);
          currentBasket?.itemList.clear();
        }
        deactivateAllBasket();
        deactivateAllUrchin();
      } else {
        deactivateAllBasket();
        deactivateAllUrchin();
      }
    }
    deactivateAllGarbage();
    deactivateAllGarbageBasket();
  }

  void selectCurrentGarbage({required Garbage currentGarbage}) {
    clickObject();
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
    clickObject();
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
    clickObject();
    deactivateAllBasket();
    this.currentBasket = currentBasket;
    currentBasket.activateBasketLight();

    if (currentUrchin != null) {
      if ((currentUrchin?.itemList.isNotEmpty ?? false) &&
          (currentBasket.itemList.isEmpty)) {
        Items? currentItem = currentUrchin?.itemList.last;
        if (currentItem != null) {
          currentItem.itemSpriteComponent.playing = false;
          currentItem.setNewHolder(itemHolder: currentBasket);
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

    currentBasket.activateBasketLight();
    this.currentBasket = currentBasket;
  }

  void setScore(int score) {
    this.score = score;
    scoreText2.text = '$score';
  }

  void gameScenario() {
    if (gameScenarioNextEventTime < worldTime) {
      if ((levelConfig?.scenario?.length ?? 0) > gameScenarioStep) {
        Scenario? currentScenarioStep =
            levelConfig?.scenario?[gameScenarioStep];
        if (currentScenarioStep != null) {
          if (currentScenarioStep.actor == 'hedgehog') {
            double currentUrchinSpeed =
                double.parse(currentScenarioStep.speed ?? '100');
            double currentScale =
                double.parse(currentScenarioStep.scale ?? '100') / 100;
            String currentUrchinPathList = currentScenarioStep.path ?? 'none';
            var currentUrchin = Urchin(
                currentSpeed: currentUrchinSpeed,
                checkPointList: urchinPathList[currentUrchinPathList] ?? [],
                birthTime: gameScenarioNextEventTime)
              ..priority = 3
              ..scale = Vector2.all(currentScale);
            add(currentUrchin);

            int currentItemType = 0;

            if (currentScenarioStep.grub == ItemsType.cherry.name) {
              currentItemType = ItemsType.cherry.index;
            } else if (currentScenarioStep.grub == ItemsType.mushroom.name) {
              currentItemType = ItemsType.mushroom.index;
            } else if (currentScenarioStep.grub == ItemsType.flower.name) {
              currentItemType = ItemsType.flower.index;
            } else if (currentScenarioStep.grub == ItemsType.apple.name) {
              currentItemType = ItemsType.apple.index;
            } else if (currentScenarioStep.grub == ItemsType.pear.name) {
              currentItemType = ItemsType.pear.index;
            }
            if (currentItemType > 0) {
              var currentItem = Items(itemType: currentItemType);
              currentUrchin.itemList.add(currentItem);
              currentItem.setNewHolder(
                  itemHolder: currentUrchin, newbornHedgehog: true);
            }

            urchinList.add(currentUrchin);
          } else
          //-----------------------------Garbage-----------------------------
          if (currentScenarioStep.kind == 'throw') {
            int currentGarbageType = 0;
            if ((currentScenarioStep.trash ?? '')
                .contains(GarbageType.plastic.name)) {
              currentGarbageType = GarbageType.plastic.index;
            } else if ((currentScenarioStep.trash ?? '').contains('metal')) {
              currentGarbageType = GarbageType.metallic.index;
            } else if ((currentScenarioStep.trash ?? '').contains('paper')) {
              currentGarbageType = GarbageType.paper.index;
            } else if ((currentScenarioStep.trash ?? '').contains('other')) {
              currentGarbageType = GarbageType.organic.index;
            }

            Vector2 garbagePosition =
                pointList[int.parse(currentScenarioStep.point ?? '0')];
            double currentGarbageAngle =
                double.parse(currentScenarioStep.angle ?? '0');
            Garbage currentGarbage = Garbage(garbageType: currentGarbageType)
              ..position = Vector2(garbagePosition.x, -200)
              ..angle = currentGarbageAngle;
            add(currentGarbage);
            garbageList.add(currentGarbage);

            var effectMoveTooPosition = MoveToEffect(
              garbagePosition,
              EffectController(duration: 0.5),
            )..onComplete = () {
                //audioPlay
              };
            currentGarbage.add(effectMoveTooPosition);
          }
          //-----------------------------------------------------------------
          //-----------------------------Finish------------------------------
          if (currentScenarioStep.kind == 'leveldone') {
            int addbonuses = int.parse(currentScenarioStep.addBonuses ?? '0');
            score+=addbonuses;
            setScore(score);
            finish(isSuccess: true);
          }
          gameScenarioNextEventTime =
              worldTime + (double.parse(currentScenarioStep.delay ?? '0'));
          gameScenarioStep++;
        }
      }
    }
  }

  @override
  void update(double dt) {
    if (dt > maxDeltaTime) {
      dt = maxDeltaTime;
    }
    super.update(dt);
    worldTime += dt;

    gameScenario();

    // urchinSprite.position+=Vector2(1, -1);
  }

  void clickObject() {
    FlameAudio.play('sound/select.wav');
  }

// @override
// void onTapDown(TapDownEvent event) {
//   super.onTapDown(event);
// }

  void finish({required bool isSuccess}) {
    if (isSuccess) {
      print('Victory !!! Score:  ' + score.toString());
    } else {
      print('you loose');
    }
  }
}
