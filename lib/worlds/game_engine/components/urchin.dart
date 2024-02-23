import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/background.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/first_world.dart';
import 'get_angle.dart';

class Urchin extends PositionComponent with TapCallbacks, CollisionCallbacks{
  List<Vector2> checkPointList;
  late SpriteAnimationComponent urchinSprite, urchinLightSprite;
  double speed;
  List<Items> itemList = [];
  double urchinRotationSpeed = 80;
  int currentCheckpointNumber = 0;
  Vector2 direction = Vector2(0, 1);
  double birthTime = 0;
  FirstWorld world = GetIt.I.get<FirstWorld>();
  double maxStepLenght = 10;

  Urchin(
      {required this.speed,
      required this.checkPointList,
      required this.birthTime})
      : super(size: Vector2(210, 280), anchor: Anchor.center){
    double bigSide = (width>height) ? width : height;
    add(CircleHitbox(radius: bigSide/2, anchor: Anchor.center, isSolid: true, position: Vector2(size.x/2, size.y/2))..debugMode=world.debugMode);
  }

  @override
  Future<void> onLoad() async {
    final dataLight = SpriteAnimationData.sequenced(
      textureSize: Vector2(260, 320),
      amount: 4,
      stepTime: 20 / speed,
    );
    urchinLightSprite = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache('lightUrchin.png'),
      dataLight,
    );
    urchinLightSprite.anchor = Anchor.center;
    urchinLightSprite.position = Vector2(size.x / 2, size.y / 2);
    add(urchinLightSprite);
    deActivateUrchinLight();

    final dataUrchin = SpriteAnimationData.sequenced(
      textureSize: size,
      amount: 4,
      stepTime: 20 / speed,
    );
      urchinSprite = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache('urchin.png'),
      dataUrchin,
    );
    urchinSprite.position =
        Vector2(urchinSprite.size.x / 2, urchinSprite.size.y / 2);
    urchinSprite.anchor = Anchor.center;
    position = checkPointList[currentCheckpointNumber];
    if (currentCheckpointNumber + 1 < checkPointList.length) {
      angle = getAngle(position, checkPointList[currentCheckpointNumber + 1]);
      angle = getShortAngle(urchinSprite.angle, angle);
    }
    urchinSprite.priority = 2;
    add(urchinSprite);
    super.onLoad();
  }

  @override
  void update(double dt) {
    if(dt>world.maxDeltaTime){
      dt=world.maxDeltaTime;
    }
    maxStepLenght=position.distanceTo(checkPointList[currentCheckpointNumber+1]);
    if (world.worldTime >= birthTime) {
      var normalDirectionVec = ((checkPointList[currentCheckpointNumber + 1] -
              checkPointList[currentCheckpointNumber])
          .normalized());
      var currentStep = (dt < world.maxDeltaTime)
          ? Vector2(normalDirectionVec.x * speed * dt,
              normalDirectionVec.y * speed * dt)
          : Vector2(normalDirectionVec.x * speed * world.maxDeltaTime,
              normalDirectionVec.y * speed * world.maxDeltaTime);
     // print('currentStepLenght='+currentStep.length.toString());
      if(currentStep.length>maxStepLenght){
        currentStep=currentStep.normalized();
      }

      position += currentStep;
      if (position.distanceTo(checkPointList[currentCheckpointNumber + 1]) <
          currentStep.length) {
        currentCheckpointNumber += 1;
        if (currentCheckpointNumber < checkPointList.length - 2) {
          double angle2 =
              getAngle(position, checkPointList[currentCheckpointNumber + 1]);
          add(
            RotateEffect.to(
              getShortAngle(urchinSprite.angle, angle2),
              EffectController(duration: urchinRotationSpeed / speed),
            ),
          );
        }
        if ((currentCheckpointNumber == checkPointList.length - 1) ||
            position.length > 3000) {
          pastUrchinToStartPosition();
          // urchinSprite.angle=45;
        }
      }
    }
    super.update(dt);
  }

  void activateUrchinLight() {
    //  if (urchinLightSprite.isRemoved) {
    // add(urchinLightSprite);
    urchinLightSprite.scale=Vector2.all(1);
    urchinSprite.priority = 2;
    urchinLightSprite.priority = 1;

    // }
  }

  void deActivateUrchinLight() {
  //   if (urchinLightSprite.isMounted) {
  //     remove(urchinLightSprite);
    // }
    urchinLightSprite.scale=Vector2.all(0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // for (var urchin in world!.urchinList) {
    //   urchin.deActivateUrchinLight();
    // }
    // world.deactivateAllUrchin();
    // print('TAP DOWN');
    // if (!contains(urchinLightSprite)) {
    //   activateUrchinLight();
    // } else {
    //   deActivateUrchinLight();
    // }
    world.selectCurrentUrchin(currentUrchin: this);
    super.onTapDown(event);
  }


  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Background) {
      if(itemList.isNotEmpty){
        if( itemList.last.collideWithTrueExit) {
          world.score += world.scoreWhenTrueExit;
        }else if(world.score>=world.scoreWhenFalseExit){

          world.score-=world.scoreWhenFalseExit;
        }
        world.setScore(world.score);
      }
      print("SCORE="+world.score.toString());
      print('COLLISION END');



      pastUrchinToStartPosition();


    }
    super.onCollisionEnd(other);
  }

  void pastUrchinToStartPosition() {
    deActivateUrchinLight();
    currentCheckpointNumber = 0;
    position = checkPointList.first;
    if (currentCheckpointNumber + 1 < checkPointList.length) {
      angle =
          getAngle(position, checkPointList[currentCheckpointNumber + 1]);
      angle = getShortAngle(urchinSprite.angle, angle);
    }
  }

}
