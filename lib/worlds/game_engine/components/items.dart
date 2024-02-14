import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'get_angle.dart';

class Items extends PositionComponent with TapCallbacks {
  late SpriteAnimationComponent urchinSprite;
  double speed=100;
  double urchinRotationSpeed = 80;
  int currentCheckpoint = 0;
  Vector2 direction = Vector2(0, 1);
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
  add(urchinSprite);
    return super.onLoad();
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}