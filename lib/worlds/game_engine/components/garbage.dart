import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';

import '../first_world.dart';

class Garbage extends PositionComponent with CollisionCallbacks, TapCallbacks {
  bool collideWithTrueExit = false;
  int garbageType;
  int animationFrameCount = 4;
  Vector2 animationGarbageLightFrameSize = Vector2(160, 160);
  Vector2 garbageImageSize = Vector2(260, 120);
  late SpriteComponent garbageSprite;
  late SpriteAnimationComponent garbageLightSpriteComponent;
  String garbageImagePath = 'garbage/plasticGarbageItem.png';
  String garbageLightImagePath = 'garbage/plasticGarbageItem.png';
  PositionComponent? itemHolder;
  double speed = 200;
  double inventorySpeed = 3000;
  double urchinRotationSpeed = 80;
  int currentCheckpoint = 0;
  Vector2 direction = Vector2(0, 1);
  FirstWorld world = GetIt.I.get<FirstWorld>();
  bool flyAnimation = false;

  late SpriteComponent garbageSpriteComponent;
  late RectangleHitbox rectangleHitbox;

  Garbage({required this.garbageType, this.itemHolder}) {
    priority = 15;
    if (garbageType == GarbageType.plastic.index) {
      garbageImagePath = 'garbage/plasticGarbageItem.png';
      garbageLightImagePath = 'garbage/plasticGarbageLight.png';
      animationFrameCount = 4;
      animationGarbageLightFrameSize = Vector2(340, 180);
      garbageImageSize = Vector2(260, 120);
    }
    if (garbageType == GarbageType.organic.index) {
      garbageImagePath = 'garbage/organicGarbageItem.png';
      garbageLightImagePath = 'garbage/organicGarbageLight.png';
      animationFrameCount = 4;
      animationGarbageLightFrameSize = Vector2(140, 180);
      garbageImageSize = Vector2(100, 140);
    }
    if (garbageType == GarbageType.metallic.index) {
      garbageImagePath = 'garbage/metallicGarbageItem.png';
      garbageLightImagePath = 'garbage/metallicGarbageLight.png';
      animationFrameCount = 4;
      animationGarbageLightFrameSize = Vector2(280, 180);
      garbageImageSize = Vector2(220, 120);
    }
    if (garbageType == GarbageType.paper.index) {
      garbageImagePath = 'garbage/paperGarbageItem.png';
      garbageLightImagePath = 'garbage/paperGarbageLight.png';
      animationFrameCount = 4;
      animationGarbageLightFrameSize = Vector2(260, 220);
      garbageImageSize = Vector2(200, 200);
    }

    size = garbageImageSize;
    priority = 15;
    rectangleHitbox = RectangleHitbox(
        size: size - Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        isSolid: true);
    add(rectangleHitbox);
    // add(CircleHitbox(radius: (garbageImageSize.x+garbageImageSize.y)/4, anchor: Anchor.center)
    //   ..isSolid=true..debugMode = world.debugMode);
  }

  @override
  Future<void> onLoad() async {
    final data = SpriteAnimationData.sequenced(
      textureSize: animationGarbageLightFrameSize,
      amount: animationFrameCount,
      stepTime: 20 / speed,
    );
    garbageLightSpriteComponent = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache(garbageLightImagePath),
      data,
    )..paint.color = const Color(0x00000001).withOpacity(0.8);
    garbageLightSpriteComponent.anchor = Anchor.center;
    garbageLightSpriteComponent.position = Vector2(size.x / 2, size.y / 2);
    garbageLightSpriteComponent.priority = 9;
    add(garbageLightSpriteComponent);

    garbageSpriteComponent = SpriteComponent(
        size: garbageImageSize,
        sprite: Sprite(Flame.images.fromCache(garbageImagePath)),
        anchor: Anchor.center)
      ..anchor = Anchor.center
      ..priority = 10;
    garbageSpriteComponent.position = Vector2(size.x / 2, size.y / 2);
    add(garbageSpriteComponent);
    deActivateGarbageLight();
    anchor = Anchor.center;
    return super.onLoad();
  }

  void removeComponents() {
    garbageSpriteComponent.parent = this;
    remove(garbageSpriteComponent);
    print("garbageSpriteComponent removed");
    garbageLightSpriteComponent.parent = this;
    remove(garbageLightSpriteComponent);
    print("garbageLightSpriteComponent removed");
    rectangleHitbox.parent = this;
    remove(rectangleHitbox);
    print("rectangleHitbox removed");
  }

  @override
  Future<void> update(double dt) async {
    if (dt > world.maxDeltaTime) {
      dt = world.maxDeltaTime;
    }
    if (itemHolder != null && flyAnimation) {
      // print('itemHolder != null && flyAnimation');
      if (itemHolder != null) {
        var normalVec = (itemHolder!.center - center).normalized();
        var stepLen = Vector2(normalVec.x * inventorySpeed * dt,
            normalVec.y * inventorySpeed * dt);
        if ((itemHolder!.center - center).length > 3 * stepLen.length) {
          print('center=' + itemHolder!.center.toString());
          position += stepLen;
        } else {
          print('start add');
          flyAnimation = false;

          var newPosition = Vector2(
            itemHolder!.size.x / 2 + size.x / 2,
            itemHolder!.size.y / 2 + size.y / 2,
          );

          itemHolder?.add(this);
          anchor = Anchor.center;
          angle = 0;
          await Future.delayed(Duration.zero);
          position = newPosition;
          priority = 15;
        }
      }
    }
    super.update(dt);
  }

  void activateGarbageLight() {
    world.currentGarbage = this;
    garbageLightSpriteComponent.scale = Vector2.all(1);
  }

  void deActivateGarbageLight() {
    garbageLightSpriteComponent.scale = Vector2.all(0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    world.selectCurrentGarbage(currentGarbage: this);
    super.onTapDown(event);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
