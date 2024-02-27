import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';

class GarbageBasket extends SpriteComponent with TapCallbacks{
  int garbageType;
  double animationSpeed = 0.05;
  late SpriteAnimationComponent garbageLightSprite;
  GarbageBasket({required this.garbageType}){

  anchor=Anchor.center;
  var imageGarbagePath = '';
  var imageGarbageLightPath = '';

  if(garbageType==GarbageType.metallic.index){
    imageGarbagePath = 'garbage/metallicGarbageBasket.png';
    imageGarbageLightPath='garbage/garbageBasketLight.png';
  }
  if(garbageType==GarbageType.paper.index){
    imageGarbagePath = 'garbage/paperGarbageBasket.png';
    imageGarbageLightPath='garbage/garbageBasketLight.png';
  }
  if(garbageType==GarbageType.plastic.index){
    imageGarbagePath = 'garbage/plasticGarbageBasket.png';
    imageGarbageLightPath='garbage/garbageBasketLight.png';
  }
  if(garbageType==GarbageType.organic.index){
    imageGarbagePath = 'garbage/organicGarbageBasket.png';
    imageGarbageLightPath='garbage/garbageBasketLight.png';
  }
  sprite = Sprite( Flame.images.fromCache(imageGarbagePath));
  final dataLight = SpriteAnimationData.sequenced(
    textureSize: Vector2(124, 10),
    amount: 4,
    stepTime: animationSpeed,
  );
   garbageLightSprite = SpriteAnimationComponent.fromFrameData(
    Flame.images.fromCache(imageGarbageLightPath),
    dataLight,
  );
  garbageLightSprite.anchor = Anchor.center;
  garbageLightSprite.position = Vector2(size.x / 2, -35);
  //add(garbageLightSprite);
  // deActivateUrchinLight();
  }

  void activateGarbage(){
    add(garbageLightSprite);
  }

  void deActivateGarbage(){
    remove(garbageLightSprite);
  }





}