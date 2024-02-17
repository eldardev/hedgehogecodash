import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';

import 'components/urchin.dart';

@singleton
class FirstWorld extends CommonWorld with TapCallbacks {
  late SpriteAnimationComponent urchinSprite;
  double scale = 0.1;
  SpriteComponent spriteComponentBG = SpriteComponent();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    List<Vector2> positionList1 = [
      Vector2(-100, 1500),
      Vector2(400, 1000),
      Vector2(880, 790),
      Vector2(1450, 590),
      Vector2(1705, 550),
      Vector2(1980, 580),
      Vector2(2345, 668),
      Vector2(3000, 668)
    ];
    List<Vector2> positionList2 = [
      Vector2(-100, 840),
      Vector2(1110, 440),
      Vector2(1310, 305),
      Vector2(1430, 145),
      Vector2(1580, -100),
    ];
    List<Vector2> positionList3 = [
      Vector2(-100, 780),
      Vector2(850, 500),
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

    final sprite = await Sprite.load('maps/map_01.png');
    final size = Vector2(2400, 1080);
    final bgSprite = SpriteComponent(size: size, sprite: sprite);

    add(bgSprite);

    add(Urchin(speed: 200, positionList1: positionList1));
    await Future.delayed(Duration(seconds: 1));
    add(Urchin(speed: 250, positionList1: positionList2));
    await Future.delayed(Duration(seconds: 5));
    add(Urchin(speed: 400, positionList1: positionList3));
    // await Future.delayed(Duration(seconds: 5));
    // add(Items(speed: 400));

    // final tiledMap = await TiledComponent()
  }

  @override
  void update(double dt) {
    super.update(dt);
    // urchinSprite.position+=Vector2(1, -1);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.localPosition;
      print('TouchPosition = ' + touchPoint.toString());
      add(CircleComponent(
          position: touchPoint, radius: 20, anchor: Anchor.center));
    }
  }
}
