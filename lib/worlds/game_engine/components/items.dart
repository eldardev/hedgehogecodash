import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/urchin.dart';
import 'get_angle.dart';

class Items extends PositionComponent {

  int itemType;
  int animationFrameCount = 4;
  Vector2 animationFrameSize = Vector2(160, 160);
  late SpriteAnimationComponent itemSprite;
  String imagePath = 'items/itemApple.png';
  PositionComponent? itemHolder;
  double speed = 300;
  double inventorySpeed = 3000;
  double urchinRotationSpeed = 80;
  int currentCheckpoint = 0;
  Vector2 direction = Vector2(0, 1);

  Items({required this.itemType, this.itemHolder}) {
    if (itemType == 1) {
      imagePath = 'items/itemApple.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == 2) {
      imagePath = 'items/itemCherry.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == 3) {
      imagePath = 'items/itemFlower.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == 4) {
      imagePath = 'items/itemMushroom.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == 5) {
      imagePath = 'items/itemPear.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    size = animationFrameSize;
    anchor = Anchor.center;

  }

  @override
  Future<void> onLoad() async {
    final itemSize = animationFrameSize;
    final data = SpriteAnimationData.sequenced(
      textureSize: itemSize,
      amount: animationFrameCount,
      stepTime: 20 / speed,
    );
    itemSprite = SpriteAnimationComponent.fromFrameData(
      await Flame.images.load(imagePath),
      data,
    );
    itemSprite.anchor = Anchor.center;
    itemSprite.priority = 10;
    add(itemSprite);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (itemHolder != null) {
      // var normalVec = (Vector2(0, 0) - position).normalized();
      // if ((itemUrchin!.position - position).length > 10) {
      //   position += Vector2(
      //       normalVec.x * inventorySpeed * dt, normalVec.y * inventorySpeed * dt);
      // }
      // else {

         position = Vector2(itemHolder!.size.x/2+size.x/2, itemHolder!.size.y/2+size.y/2);
         anchor=Anchor.center;
      //   angle = itemUrchin!.angle;
      //   speed = itemUrchin!.speed;
      // }
      // angle=itemUrchin!.angle;
      //speed=10;
    }
    super.update(dt);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}