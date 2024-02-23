import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/components/basket.dart';
import 'package:urchin/worlds/game_engine/components/exit.dart';
import 'package:urchin/worlds/game_engine/components/itemsType.dart';
import 'package:urchin/worlds/game_engine/components/urchin.dart';
import '../first_world.dart';
import 'get_angle.dart';

class Items extends PositionComponent with CollisionCallbacks {
  bool collideWithTrueExit = false;
  int itemType;
  int animationFrameCount = 4;
  Vector2 animationFrameSize = Vector2(160, 160);
  late SpriteAnimationComponent itemSpriteComponent;
  String imagePath = 'items/itemApple.png';
  PositionComponent? itemHolder;
  double speed = 300;
  double inventorySpeed = 3000;
  double urchinRotationSpeed = 80;
  int currentCheckpoint = 0;
  Vector2 direction = Vector2(0, 1);
  FirstWorld world = GetIt.I.get<FirstWorld>();
  bool flyAnimation = false;

  Items({required this.itemType, this.itemHolder}) {
    priority = 15;
    if (itemType == ItemsType.apple.index) {
      imagePath = 'items/itemApple.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == ItemsType.cherry.index) {
      imagePath = 'items/itemCherry.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == ItemsType.flower.index) {
      imagePath = 'items/itemFlower.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == ItemsType.mushroom.index) {
      imagePath = 'items/itemMushroom.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    if (itemType == ItemsType.pear.index) {
      imagePath = 'items/itemPear.png';
      animationFrameCount = 4;
      animationFrameSize = Vector2(160, 160);
    }
    size = animationFrameSize;
    anchor = Anchor.center;
    priority = 15;
    add(CircleHitbox(radius: 100, anchor: Anchor.center)..debugMode=world.debugMode);
  }

  @override
  Future<void> onLoad() async {
    final itemSize = animationFrameSize;
    final data = SpriteAnimationData.sequenced(
      textureSize: itemSize,
      amount: animationFrameCount,
      stepTime: 20 / speed,
    );
    itemSpriteComponent = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache(imagePath),
      data,
    );
    itemSpriteComponent.anchor = Anchor.center;
    itemSpriteComponent.priority = 10;
    add(itemSpriteComponent);
    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    if (dt > world.maxDeltaTime) {
      dt = world.maxDeltaTime;
    }
    if (itemHolder != null && flyAnimation) {
      // print('itemHolder != null && flyAnimation');
      if (itemHolder != null) {
        var normalVec = (itemHolder!.center - center).normalized();
        var stepLen = Vector2(normalVec.x * inventorySpeed * dt,
            normalVec.y * inventorySpeed * dt);
        if ((itemHolder!.center - center).length > 3 * stepLen.length) {
          print('center=' + itemHolder!.center.toString());
          position += stepLen;
        } else {
          print('start add');
          flyAnimation = false;

          var newPosition = Vector2(
            itemHolder!.size.x / 2 + size.x / 2,
            itemHolder!.size.y / 2 + size.y / 2,
          );

          // Добавляем this к itemHolder
          itemHolder?.add(this);
          anchor = Anchor.center;
          angle = 0;
          await Future.delayed(Duration.zero);
          // Устанавливаем новую позицию для this
          position = newPosition;
          priority = 15;
          //anchor = Anchor.center;

          //   final effect = MoveToEffect(
          //   Vector2(itemHolder!.size.x / 2 + size.x / 2,
          //       itemHolder!.size.y / 2 + size.y / 2),
          //   EffectController(duration: 0.5),
          // );
          // add(effect);
        }
      }
    }
    // if(!flyAnimation && itemHolder!=null){
    //   var newPos = itemHolder?.position ?? Vector2(0, 0);
    //   var vecSize = itemHolder?.size ?? Vector2(0, 0);
    //   //position = newPos+Vector2(size.x/2, size.y/2);//+Vector2(vecSize.x/2, vecSize.y/2);
    //   position=itemHolder?.position ?? Vector2(1000, 1000);
    //   itemHolder?.anchor=Anchor.center;
    //   anchor = Anchor.center;
    //   angle = itemHolder?.angle ?? 0;
    // }
    //  print('DT='+dt.toString());
    super.update(dt);
  }

  void setNewHolder(PositionComponent itemHolder) {
    world.add(this);
    flyAnimation = true;
    PositionComponent? lastPositionComponent = this.itemHolder;
    this.itemHolder = itemHolder;
    flyAnimation = true;
    anchor = Anchor.center;
    // add(
    //     RotateEffect.to(
    //       itemHolder.angle,
    //       EffectController(duration: 0.01),
    //     )
    // );

    priority = 15;
    if (lastPositionComponent != null) {
      position = Vector2(
          lastPositionComponent.position.x + lastPositionComponent.size.x / 2,
          (lastPositionComponent.position.y) +
              (lastPositionComponent.size.y) / 2);

      // final effect = MoveToEffect(
      //   Vector2(itemHolder.position.x+itemHolder.size.x / 2,
      //       itemHolder.position.y+ itemHolder.size.y / 2),
      //   EffectController(duration: 0.5),
      // )..onComplete =  (){
      //   pastToHolder();
      // };
      // add(effect);}
    }
    // Vector2(
    // itemHolder.size.x / 2 + size.x / 2, itemHolder.size.y / 2 + size.y / 2);
    anchor = Anchor.center;
    //    // add(this);
    print('Item holder=' + this.itemHolder.toString());
  }

  void pastToHolder() {
    print('p1=' + position.toString());
    // position=toLocal(point) position-(itemHolder?.position ??Vector2(0, 0));
    var pos2 =
        (itemHolder?.position ?? Vector2(0, 0)) - position; //toLocal(position);
    itemHolder?.add(this);
    position = pos2;
    print('p2=' + position.toString());
    //  this.itemHolder = itemHolder;
    //   flyAnimation = true;

    priority = 15;
    // position = Vector2(itemHolder?.size.x ?? 0 / 2 + size.x / 2,
    //     itemHolder?.size.y ?? 0 / 2 + size.y / 2);
    // anchor = Anchor.center;
    final effect = MoveToEffect(
      Vector2(itemHolder!.size.x / 2 + size.x / 2,
          itemHolder!.size.y / 2 + size.y / 2),
      EffectController(duration: 0.5),
    );
    add(effect);
  }

  static void calculateNewPosition(
      PositionComponent movingComponent, PositionComponent staticComponent) {
    // Получаем текущие координаты компонентов
    final movingX = movingComponent.x;
    final movingY = movingComponent.y;
    final staticX = staticComponent.x;
    final staticY = staticComponent.y;

    // Вычисляем смещение между компонентами
    final offsetX = movingX - staticX;
    final offsetY = movingY - staticY;

    // Вычисляем угол между компонентами
    final angle = atan2(offsetY, offsetX);

    // Вычисляем новые координаты для компонента A
    final newX = staticX + cos(angle) * offsetX - sin(angle) * offsetY;
    final newY = staticY + sin(angle) * offsetX + cos(angle) * offsetY;

    // Устанавливаем новые координаты для компонента A
    movingComponent.x = newX;
    movingComponent.y = newY;
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is Exit) {
  //     //print('COLIDE WITH EXIT');
  //     //...
  //   } else if (other is Urchin) {
  //     other.speed=0;
  //   }
  //   super.onCollision(intersectionPoints, other);
  // }
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Exit) {
      if (other.exitType == itemType) {
        collideWithTrueExit = true;
      }else{
        collideWithTrueExit=false;
      }
      print('COLIDE WITH EXIT');
      //...
    } else if (other is Urchin) {
      // if(other.birthTime>world.worldTime) {
      //   other.speed = 5;
      // }
    }
    super.onCollision(intersectionPoints, other);
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
