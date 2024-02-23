import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../first_world.dart';

class Background extends SpriteComponent with CollisionCallbacks {
  FirstWorld world = GetIt.I.get<FirstWorld>();
  Background(){
    size = Vector2(2400, 1080);
    sprite =  Sprite(Flame.images.fromCache('maps/map_01.png'));
    position=Vector2(size.x/2, size.y/2);
    anchor = Anchor.center;
    add(RectangleHitbox(position: position, anchor: anchor, size: size, isSolid: true)..debugMode=world.debugMode);
  }
  @override
  Future<void> onLoad() async {
    // final mapImages = await Flame.images.fromCache('maps/map_01.png');
    // final sprite = Sprite(mapImages);//await Sprite. load('maps/map_01.png');
    //
    // final bgSprite = SpriteComponent(size: size, sprite: sprite)..priority=0;

   // add(bgSprite);
    //add(RectangleHitbox(size: size, anchor: Anchor.center)..anchor=Anchor.center..debugMode=true..position=Vector2(size.x/2, size.y/2));
    super.onLoad();
  }
}