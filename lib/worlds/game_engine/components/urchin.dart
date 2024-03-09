import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/background.dart';
import 'package:urchin/worlds/game_engine/components/items.dart';
import 'package:urchin/worlds/game_engine/components/urchin_face.dart';
import 'package:urchin/worlds/game_engine/first_world.dart';
import 'get_angle.dart';

class Urchin extends PositionComponent with TapCallbacks, CollisionCallbacks {
  bool isActive = true;
  List<Vector2> checkPointList;
  late SpriteAnimationComponent urchinSprite, urchinLightSprite;
  double minSpeed = 80;
  double currentSpeed;
  double maxSpeed = 80;
  bool isPause = false;
  List<Items> itemList = [];
  double urchinRotationSpeed = 80;
  int currentCheckpointNumber = 0;
  Vector2 direction = Vector2(0, 1);
  double birthTime = 0;
  FirstWorld world = GetIt.I.get<FirstWorld>();
  double maxStepLength = 10;
  late SpriteAnimationData dataUrchin;

  Urchin(
      {required this.currentSpeed,
      required this.checkPointList,
      required this.birthTime})
      : super(size: Vector2(210, 280), anchor: Anchor.center) {
    maxSpeed = currentSpeed;
    // double bigSide = (width > height) ? width : height;
    add(CircleHitbox(
        radius: ((width) / 2),
        anchor: Anchor.center,
        isSolid: true,
        position: Vector2(size.x / 2, size.y / 2))
      ..debugMode = world.debugMode);
    add(UrchinFace(faceHolder: this)..position = Vector2(size.x / 2, 100));
  }

  void updateAnimation(double speed) {
    urchinSprite.animation?.stepTime = 20 / speed;
    urchinLightSprite.animation?.stepTime = 20 / speed;
    if (itemList.isNotEmpty) {
      itemList.last.itemSpriteComponent.animation?.stepTime = 20 / speed;
    }
  }

  @override
  Future<void> onLoad() async {
    final dataLight = SpriteAnimationData.sequenced(
      textureSize: Vector2(260, 320),
      amount: 4,
      stepTime: 20 / currentSpeed,
    );
    urchinLightSprite = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache('lightUrchin.png'),
      dataLight,
    );
    urchinLightSprite.anchor = Anchor.center;
    urchinLightSprite.position = Vector2(size.x / 2, size.y / 2);
    add(urchinLightSprite);
    deActivateUrchinLight();

    dataUrchin = SpriteAnimationData.sequenced(
      textureSize: size,
      amount: 4,
      stepTime: 20 / currentSpeed,
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

    updateAnimation(currentSpeed);
    super.onLoad();
  }

  @override
  void update(double dt) {
    if (isPause || !isActive) {
      return;
    }
    if (dt > world.maxDeltaTime) {
      dt = world.maxDeltaTime;
    }
    maxStepLength =
        position.distanceTo(checkPointList[currentCheckpointNumber + 1]);
    if (world.worldTime >= birthTime) {
      var normalDirectionVec = ((checkPointList[currentCheckpointNumber + 1] -
              checkPointList[currentCheckpointNumber])
          .normalized());
      var currentStep = (dt < world.maxDeltaTime)
          ? Vector2(normalDirectionVec.x * currentSpeed * dt,
              normalDirectionVec.y * currentSpeed * dt)
          : Vector2(normalDirectionVec.x * currentSpeed * world.maxDeltaTime,
              normalDirectionVec.y * currentSpeed * world.maxDeltaTime);
      // if (currentStep.length >= maxStepLength) {
      //   currentStep = currentStep.normalized();
      //   print('CURRENT STEM NORMALIZED');
      // }

      if (position.distanceTo(checkPointList[currentCheckpointNumber + 1]) <=
          currentStep.length) {
        position = checkPointList[currentCheckpointNumber + 1];
        currentCheckpointNumber += 1;
        if (currentCheckpointNumber < checkPointList.length - 1) {
          //angle = getRotation(checkPointList[currentCheckpointNumber + 1], this);

          double angle2 =
              getAngle(position, checkPointList[currentCheckpointNumber + 1]);
          //angle= getShortAngle(urchinSprite.angle, angle2);
          // angle=checkPointList[currentCheckpointNumber+1].angleTo(position);
          // double shortAngle = getShortAngle(this.angle, angle2);
          // print('angle='+angle.toString());
          // print('angle2='+angle2.toString());
          // print('shortAngle='+shortAngle.toString());

          angle = getShortAngle(this.angle, angle2);
          // add(
          //   RotateEffect.to(
          //     getShortAngle(this.angle, angle2),
          //     EffectController(duration: urchinRotationSpeed / currentSpeed, ),
          //   ),
          // );
        }
        // if ((currentCheckpointNumber == checkPointList.length - 1)) {
        //   // pastUrchinToStartPosition();
        //   position = Vector2(-3000, -3000);
        //   //world.remove(this);
        // }
        return;
      }
      position += currentStep;
    }
    if (currentSpeed < maxSpeed) {
      currentSpeed += maxSpeed / 300;
      updateAnimation(currentSpeed);
    }
    super.update(dt);
  }

  void activateUrchinLight() {
    urchinLightSprite.scale = Vector2.all(1);
    urchinSprite.priority = 2;
    urchinLightSprite.priority = 1;

    // }
  }

  void deActivateUrchinLight() {
    urchinLightSprite.scale = Vector2.all(0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    world.selectCurrentUrchin(currentUrchin: this);
    super.onTapDown(event);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Background) {
      if (itemList.isNotEmpty) {
        if (itemList.last.collideWithTrueExit) {
          world.score += world.scoreWhenTrueExit;
        } else if (world.score >= world.scoreWhenFalseExit) {
          world.score -= world.scoreWhenFalseExit;
        } else {
          world.finish(isSuccess: false);
        }
        world.setScore(world.score);
      }

      // pastUrchinToStartPosition();
      if (urchinLightSprite.scale.x > 0) {
        world.deactivateAllUrchin();
      }
      clearUrchin();
      // deActivateUrchinLight();
      // position=Vector2(-3000, -3000);
      // world.remove(this);
      // world.urchinList.remove(this);
    }
    super.onCollisionEnd(other);
  }

  void pastUrchinToStartPosition() {
    deActivateUrchinLight();
    currentCheckpointNumber = 0;
    position = checkPointList.first;
    if (currentCheckpointNumber + 1 < checkPointList.length) {
      angle = getAngle(position, checkPointList[currentCheckpointNumber + 1]);
      angle = getShortAngle(urchinSprite.angle, angle);
    }
  }

  void urchinMovePause(bool pause) {
    if (pause) {
      isPause = true;
      updateAnimation(minSpeed);
    } else {
      currentSpeed = minSpeed;
      updateAnimation(currentSpeed);
      isPause = false;
    }
  }

  // double getRotation(Vector2 target, PositionComponent player) {
  //   //var heading = target.position - player.position;
  //   return player.position.angleTo(target) - 90;
  // }
  void updateUrchinParameter(
      {required double newSpeed,
      required double newScale,
        required double newBirthTime,
      required List<Vector2> newCheckPointList}) {
    currentCheckpointNumber=0;
    checkPointList = newCheckPointList;
    position = checkPointList.first;
    birthTime=newBirthTime;
    currentSpeed = newSpeed;
    maxSpeed = newSpeed;
    scale = Vector2.all(newScale);
    double angle2 =
        getAngle(position, checkPointList[currentCheckpointNumber + 1]);
    angle = getShortAngle(angle, angle2);
    updateAnimation(newSpeed);
    isActive = true;
    isPause = false;
  }

  void clearUrchin() {
    isActive = false;
    position = Vector2(-5000, -5000);
    if (itemList.isNotEmpty) {
      final effect = MoveEffect.to(itemList.last.itemHolder?.position ?? Vector2(-200, -200), EffectController(duration: 0.1));
      itemList.last.add(effect);
      itemList.last.itemHolder = null;
      if(contains(itemList.last)){
        remove(itemList.last);
      }
    }
    currentCheckpointNumber = 0;
    itemList.clear();
    deActivateUrchinLight();
  }
}
