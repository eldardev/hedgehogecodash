import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urchin/urchin_game.dart';
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
class FirstWorld extends CommonWorld
    with TapCallbacks, HasCollisionDetection, HasGameRef<UrchinGame> {
  int levelNumber = 1;
  int score = 0;
  int scoreWhenTrueExit = 1;
  int scoreWhenFalseExit = 1;
  LevelConfig? levelConfig;
  int totalUrchin = 0;
  int totalItems = 0;

  int gameScenarioStep = 0;
  double gameScenarioNextEventTime = 0;
  double maxDeltaTime = 0.1;
  List<Urchin> selectedUrchinList = [];
  List<Basket> selectedBasketList = [];
  Garbage? currentGarbage;
  GarbageBasket? currentGarbageBasket;
  List<Vector2> pointList = [];
  List<Basket> basketList = [];
  List<Urchin> urchinList = [];
  List<Garbage> garbageList = [];
  List<GarbageBasket> garbageBasketList = [];
  List<PositionComponent> selectedObject = [];
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
    playBgAudio();

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
    super.onLoad();
  }

  void deactivateAllUrchin() {
    for (var urchin in urchinList) {
      urchin.deActivateUrchinLight();
    }
    selectedUrchinList.clear();
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
    selectedBasketList.clear();
  }

  void deactivateAllGarbage() {
    for (var garbage in garbageList) {
      garbage.deActivateGarbageLight();
    }
    currentGarbage = null;
  }

  void selectCurrentUrchin({required Urchin currentUrchin}) {
    clickObjectAudio();
    // deactivateAllUrchin();
    selectedUrchinList.add(currentUrchin);
    currentUrchin.activateUrchinLight();
    if (selectedBasketList.isNotEmpty) {
      if ((selectedBasketList.last.itemList.isNotEmpty) &&
          (currentUrchin.itemList.isEmpty)) {
        Items? currentItem = selectedBasketList.last.itemList.last;
        currentItem.itemSpriteComponent.playing = true;
        currentItem.setNewHolder(itemHolder: currentUrchin);
        currentUrchin.itemList.add(currentItem);
        selectedBasketList.last.itemList.clear();
              deactivateAllBasket();
        deactivateAllUrchin();
      } else {
        deactivateAllBasket();
        deactivateAllUrchin();
      }
    } else if (selectedUrchinList.length == 2) {
      if (selectedUrchinList.first.itemList.isNotEmpty &&
          selectedUrchinList.last.itemList.isEmpty) {
        Items? currentItem = selectedUrchinList.first.itemList.last;
        currentItem.itemSpriteComponent.playing = true;
        currentItem.setNewHolder(itemHolder: selectedUrchinList.last);
        selectedUrchinList.last.itemList.add(currentItem);
        selectedUrchinList.first.itemList.clear();
        deactivateAllUrchin();
      } else if (selectedUrchinList.first.itemList.isEmpty &&
          selectedUrchinList.last.itemList.isNotEmpty) {
        selectedUrchinList.first.deActivateUrchinLight();
        selectedUrchinList.remove(selectedUrchinList.first);
      } else {
        deactivateAllUrchin();
        selectedUrchinList.clear();
        selectedUrchinList.add(currentUrchin);
        currentUrchin.activateUrchinLight();
      }
    }
    deactivateAllGarbage();
    deactivateAllGarbageBasket();
  }
  void selectCurrentBasket({required Basket currentBasket}) {
    clickObjectAudio();
    //   deactivateAllBasket();
    if(selectedBasketList.contains(currentBasket)){
      deactivateAllBasket();
      return;
    }
    selectedBasketList.add(currentBasket);
    currentBasket.activateBasketLight();

    if (selectedUrchinList.isNotEmpty) {
      if ((selectedUrchinList.last.itemList.isNotEmpty) &&
          (currentBasket.itemList.isEmpty)) {
        Items? currentItem = selectedUrchinList.last.itemList.last;
        currentItem.itemSpriteComponent.playing = false;
        currentItem.setNewHolder(itemHolder: currentBasket);
        currentBasket.itemList.add(currentItem);
        selectedUrchinList.last.itemList.clear();
        deactivateAllBasket();
        deactivateAllUrchin();
      } else{

        deactivateAllBasket();
        deactivateAllUrchin();
        // if ((currentUrchin?.itemList.isEmpty ?? false))
        //   print('currentUrchin?.item = NULL');
      }
    } else if (selectedBasketList.length == 2) {
      if (selectedBasketList.first.itemList.isNotEmpty &&
          selectedBasketList.last.itemList.isEmpty) {
        Items? currentItem = selectedBasketList.first.itemList.last;
        currentItem.itemSpriteComponent.playing = false;
        currentItem.setNewHolder(itemHolder: selectedBasketList.last);
        selectedBasketList.last.itemList.add(currentItem);
        selectedBasketList.first.itemList.clear();
        deactivateAllBasket();
      } else {
        selectedBasketList.first.deActivateBasketLight();
        selectedBasketList.remove(selectedBasketList.first);
      } }else {
        deactivateAllBasket();
        selectedBasketList.clear();
        selectedBasketList.add(currentBasket);
        currentBasket.activateBasketLight();
      }

    deactivateAllGarbage();
    deactivateAllGarbageBasket();

    currentBasket.activateBasketLight();
    selectedBasketList.add(currentBasket);
  }

  void selectCurrentGarbage({required Garbage currentGarbage}) {
    clickObjectAudio();
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
    clickObjectAudio();
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
          //----------------------------NEW URCHIN-----------------------------
          if (currentScenarioStep.actor == 'hedgehog') {
            double currentUrchinSpeed =
                double.parse(currentScenarioStep.speed ?? '100');
            double currentScale =
                double.parse(currentScenarioStep.scale ?? '100') / 100;
            String currentUrchinPathList = currentScenarioStep.path ?? 'none';
            // var currentUrchin = Urchin(
            //     currentSpeed: currentUrchinSpeed,
            //     checkPointList: urchinPathList[currentUrchinPathList] ?? [],
            //     birthTime: gameScenarioNextEventTime)
            //   ..priority = 3
            //   ..scale = Vector2.all(currentScale);
            // add(currentUrchin);
            Urchin currentUrchin = generateNewUrchin(
                currentUrchinSpeed,
                currentUrchinPathList,
                gameScenarioNextEventTime,
                gameScenarioNextEventTime,
                currentScale);

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
              totalItems++;
              print('Total Items= '+ totalItems.toString());
              var currentItem = Items(itemType: currentItemType);
              currentUrchin.itemList.add(currentItem);
              currentItem.setNewHolder(
                  itemHolder: currentUrchin, newbornHedgehog: true);
            }
          } else
          //-----------------------------Garbage-----------------------------
          if (currentScenarioStep.kind == 'throw') {
            int currentGarbageType = 0;
            if ((currentScenarioStep.trash ?? '')
                .contains(GarbageType.plastic.name)) {
              currentGarbageType = GarbageType.plastic.index;
            } else if ((currentScenarioStep.trash ?? '').contains('metal')) {
              currentGarbageType = GarbageType.metallic.index;
              metalCanAudioPlay();
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
                playGarbageAudio(currentGarbageType);
              };
            currentGarbage.add(effectMoveTooPosition);
          }
          //-----------------------------------------------------------------
          //-----------------------------Finish------------------------------
          if (currentScenarioStep.kind == 'leveldone') {
            int addbonuses = int.parse(currentScenarioStep.addBonuses ?? '0');
            score += addbonuses;
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

  void playBgAudio() {
    FlameAudio.bgm.play(
        'music/Cute_Hedgehog_Compilation_Hedgehog_Escape_Giant_Macaron.mp3');
  }

  void clickObjectAudio() {
    FlameAudio.play('sound/select.wav');
  }

  void metalCanAudioPlay() {
    FlameAudio.play('sound/metalCan.mp3');
  }

  void plasticBottleAudioPlay() {
    FlameAudio.play('sound/plasticBottle.wav');
  }

  void organicAudioPlay() {
    FlameAudio.play('sound/organicGarbage.wav');
  }

  void paperAudioPlay() {
    FlameAudio.play('sound/paperGarbage.wav');
  }

  void playGarbageAudio(int garbageType) {
    if (garbageType == GarbageType.metallic.index) {
      metalCanAudioPlay();
    }
    if (garbageType == GarbageType.plastic.index) {
      plasticBottleAudioPlay();
    }
    if (garbageType == GarbageType.organic.index) {
      organicAudioPlay();
    }
    if (garbageType == GarbageType.paper.index) {
      paperAudioPlay();
    }
  }

// @override
// void onTapDown(TapDownEvent event) {
//   super.onTapDown(event);
// }

  Urchin generateNewUrchin(
      double currentUrchinSpeed,
      String currentUrchinPathList,
      double gameScenarioNextEventTime,
      double birthTime,
      double currentScale) {
    totalUrchin++;
    Urchin? newUrchin;
    for (Urchin urchin in urchinList) {
      if (!urchin.isActive) {
        newUrchin = urchin;
        break;
      }
    }
    Future.delayed(const Duration(milliseconds: 500));

    if (newUrchin == null) {
      if(urchinList.length>6){
        finish(isSuccess: false);
      }
      newUrchin = Urchin(
          currentSpeed: currentUrchinSpeed,
          checkPointList: urchinPathList[currentUrchinPathList] ?? [],
          birthTime: birthTime)
        ..priority = 3
        ..scale = Vector2.all(currentScale);

      urchinList.add(newUrchin);
    } else {
      newUrchin.updateUrchinParameter(
          newScale: currentScale,
          newSpeed: currentUrchinSpeed,
          newBirthTime: birthTime,
          newCheckPointList: urchinPathList[currentUrchinPathList] ?? []);
    }
    add(newUrchin);
    print("Total urchin= "+totalUrchin.toString());
    print('Urchin COUNT = ' + urchinList.length.toString());
    print('Urchin currentSpeed = ' + newUrchin.currentSpeed.toString() + "maxSpeed= "+ newUrchin.maxSpeed.toString());
    return newUrchin;
  }

  void finish({required bool isSuccess}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isSuccess", isSuccess);
    gameRef.router.pushReplacementNamed("level_done");
  }
}
