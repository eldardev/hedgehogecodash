import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/first_world.dart';
import 'get_angle.dart';

class Urchin extends PositionComponent with TapCallbacks {
  List<Vector2> checkPointList;
  late SpriteAnimationComponent urchinSprite, urchinLightSprite;
  double speed;
  List<Items> itemsList = [];
  double urchinRotationSpeed = 80;
  int currentCheckpointNumber = 0;
  Vector2 direction = Vector2(0, 1);
  double birthTime = 0;
  FirstWorld world = GetIt.I.get<FirstWorld>();

  Urchin(
      {required this.speed,
      required this.checkPointList,
      required this.birthTime})
      : super(size: Vector2(210, 280), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final dataLight = SpriteAnimationData.sequenced(
      textureSize: Vector2(260, 320),
      amount: 4,
      stepTime: 20 / speed,
    );
    urchinLightSprite = SpriteAnimationComponent.fromFrameData(
      await Flame.images.load('lightUrchin.png'),
      dataLight,
    );
    urchinLightSprite.anchor = Anchor.center;
    urchinLightSprite.position = Vector2(size.x / 2, size.y / 2);

    final dataUrchin = SpriteAnimationData.sequenced(
      textureSize: size,
      amount: 4,
      stepTime: 20 / speed,
    );
    urchinSprite = SpriteAnimationComponent.fromFrameData(
      await Flame.images.load('urchin.png'),
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
    if (world.worldTime >= birthTime) {
      var normalDirectionVec = ((checkPointList[currentCheckpointNumber + 1] -
              checkPointList[currentCheckpointNumber])
          .normalized());
      var currentStep = (dt < 0.05)
          ? Vector2(normalDirectionVec.x * speed * dt,
              normalDirectionVec.y * speed * dt)
          : Vector2(normalDirectionVec.x * speed * 0.1,
              normalDirectionVec.y * speed * 0.1);
      position += currentStep;
      if (position.distanceTo(checkPointList[currentCheckpointNumber + 1]) <=
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
          currentCheckpointNumber = 0;
          position = checkPointList.first;
          if (currentCheckpointNumber + 1 < checkPointList.length) {
            angle =
                getAngle(position, checkPointList[currentCheckpointNumber + 1]);
            angle = getShortAngle(urchinSprite.angle, angle);
          }
          // urchinSprite.angle=45;
        }
      }
    }
    super.update(dt);
  }

  void activateUrchinLight() {
    //  if (urchinLightSprite.isRemoved) {
    urchinSprite.priority = 2;
    urchinLightSprite.priority = 1;
    add(urchinLightSprite);
    // }
  }

  void deActivateUrchinLight() {
    if (urchinLightSprite.isMounted) {
      remove(urchinLightSprite);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    for (var urchin in world!.urchinList) {
      urchin.deActivateUrchinLight();
    }
    print('TAP DOWN');
    if (!contains(urchinLightSprite)) {
      activateUrchinLight();
    } else {
      deActivateUrchinLight();
    }
    world.selectCurrentUrchin(currentUrchin: this);
    super.onTapDown(event);
  }
}
