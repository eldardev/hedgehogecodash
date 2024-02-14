import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'get_angle.dart';

class Urchin extends PositionComponent with TapCallbacks {

  List<Vector2> positionList1;
  late SpriteAnimationComponent urchinSprite;
  double speed;
  double urchinRotationSpeed = 80;
  int currentCheckpoint = 0;
  Vector2 direction = Vector2(0, 1);

  Urchin({required this.speed, required this.positionList1}):super(size: Vector2(210, 280), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final size2 = Vector2(210.0, 280.0);
    final data = SpriteAnimationData.sequenced(
      textureSize: size2,
      amount: 4,
      stepTime: 20 / speed,
    );
    urchinSprite = SpriteAnimationComponent.fromFrameData(
      await Flame.images.load('urchin.png'),
      data,
    );
    urchinSprite.position=Vector2(urchinSprite.size.x/2, urchinSprite.size.y/2);
    // urchinSprite.angle=45;
    //anchor = Anchor.center;
    urchinSprite.anchor = Anchor.center;

    position = positionList1[currentCheckpoint];
    //scale = Vector2(0.5, 0.5);
    if (currentCheckpoint + 1 < positionList1.length) {
      angle = getAngle(position, positionList1[currentCheckpoint + 1]);
      angle = getShortAngle(urchinSprite.angle, angle);
    }
    add(urchinSprite);
    super.onLoad();
  }

  @override
  void update(double dt) {
    var normalDirectionVec = ((positionList1[currentCheckpoint + 1] -
        positionList1[currentCheckpoint]).normalized());
    var currentStep = dt < 0.1
        ? Vector2(
        normalDirectionVec.x * speed * dt, normalDirectionVec.y * speed * dt)
        : Vector2(
        normalDirectionVec.x * speed * 0.1, normalDirectionVec.y * speed * 0.1);
    position += currentStep;
    if (position.distanceTo(positionList1[currentCheckpoint + 1]) <=
        currentStep.length) {
      // if(position.x>positionList1[currentCheckpoint+1].x){
      currentCheckpoint += 1;
      if (currentCheckpoint + 1 < positionList1.length) {
        double angle2 = getAngle(
            position, positionList1[currentCheckpoint + 1]);
        // angle = getShortAngle(urchinSprite.angle, angle2);
        add(
          RotateEffect.to(
            getShortAngle(urchinSprite.angle, angle2),
            EffectController(duration: urchinRotationSpeed / speed),
          ),);
      }
      if (currentCheckpoint == positionList1.length - 1) {
        currentCheckpoint = 0;
        position = positionList1.first;
        if (currentCheckpoint + 1 < positionList1.length) {
          angle = getAngle(position, positionList1[currentCheckpoint + 1]);
          angle = getShortAngle(urchinSprite.angle, angle);
        }
        // urchinSprite.angle=45;
      }
    }
    super.update(dt);
  }
@override
  void onTapDown(TapDownEvent event) {
    print('TAP DOWN');
    // TODO: implement onTapDown
    super.onTapDown(event);
  }
}