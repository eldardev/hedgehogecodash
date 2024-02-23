import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';

import '../first_world.dart';
import 'itemsType.dart';

class Exit extends PositionComponent with CollisionCallbacks{
  int exitType;
  Vector2 animationFrameSize = Vector2(160, 160);
  String imageExitPath ='items/itemApple.png';
  FirstWorld world = GetIt.I.get<FirstWorld>();

  Exit({required this.exitType}){
    if (exitType == ItemsType.apple.index) {
      imageExitPath = 'items/itemAppleMarker.png';
      animationFrameSize = Vector2(160, 160);
    }
    if (exitType == ItemsType.cherry.index) {
      imageExitPath = 'items/itemCherryMarker.png';
      animationFrameSize = Vector2(160, 160);
    }
    if (exitType == ItemsType.flower.index) {
      imageExitPath= 'items/itemFlowerMarker.png';
      animationFrameSize = Vector2(160, 160);
    }
    if (exitType == ItemsType.mushroom.index) {
      imageExitPath = 'items/itemMushroomMarker.png';
      animationFrameSize = Vector2(160, 160);
    }
    if (exitType == ItemsType.pear.index) {
      imageExitPath = 'items/itemPearMarker.png';
      animationFrameSize = Vector2(160, 160);
    }
    size = animationFrameSize;
    anchor = Anchor.center;
    priority = 15;
    add(CircleHitbox(radius: size.x/2, anchor: Anchor.center, position: Vector2(size.x/2, size.y/2))..debugMode=world.debugMode);
  }

@override
  Future<void> onLoad() async {
  var exitImages = Flame.images.fromCache(imageExitPath);
  var exitSprite =  Sprite(exitImages);
  final exitSpriteComponent = SpriteComponent(
      size: Vector2(160, 160), sprite: exitSprite, anchor: Anchor.center)
    ..anchor = Anchor.center;
  // basketSpriteComponent.position = Vector2(size.x/2 -100, size.y/2);
  add(exitSpriteComponent);
  exitSpriteComponent.position = Vector2(size.x / 2, size.y / 2);
    super.onLoad();
  }
}