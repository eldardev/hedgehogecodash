import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/garbage_type.dart';

import '../first_world.dart';

class GarbageBasket extends PositionComponent with TapCallbacks{
  int garbageType;
  FirstWorld world = GetIt.I.get<FirstWorld>();
  double animationSpeed = 0.05;
  late SpriteAnimationComponent garbageLightSprite;
  late SpriteComponent iconGarbageBasket;
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
  size= Vector2(134, 160);

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

  iconGarbageBasket = SpriteComponent(sprite: Sprite( Flame.images.fromCache(imageGarbagePath)));
 world.garbageBasketList.add(this);
  add(iconGarbageBasket);
  add(garbageLightSprite);
  deActivateGarbageBasket();
  // deActivateUrchinLight();

  }

  void activateGarbageBasket(){
    world.currentGarbageBasket=this;
    garbageLightSprite.scale=Vector2(1, 1);
    iconGarbageBasket.scale=Vector2(1, 1);
  }

  void deActivateGarbageBasket(){
    garbageLightSprite.scale=Vector2(0, 0);
    iconGarbageBasket.scale=Vector2(0, 0);
  }
@override
  void onTapDown(TapDownEvent event) {
    world.selectCurrentGarbageBasket(currentGarbageBasket: this);
    super.onTapDown(event);
  }




}