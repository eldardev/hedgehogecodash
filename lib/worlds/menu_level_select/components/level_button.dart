import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urchin/urchin_game.dart';

import '../menu_levels_world.dart';

class LevelButton extends PositionComponent
    with HasGameRef<UrchinGame>, TapCallbacks {
  static const double _width = 200;
  static const double _height = 200;
  late TextComponent text1, text2;
  bool textComplete=false;
  int levelNumber=1;
  late RectangleComponent rect;


  LevelButton({required this.levelNumber})
      : super(
           // position: Vector2(500, 430),
            size: Vector2(_width, _height),
  //          anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async {

    rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.transparent) .. debugMode=true;

   // add(rect);

    var spr = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('menu/button_level.png')),anchor: Anchor.topLeft);
    add(spr);


    if (MenuLevelSelectWorld.totalLevelsInGame>=levelNumber){
      text1=  TextComponent(
        // key: ComponentKey.named('1'),
          text: levelNumber.toString(),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(0xFFFA9933),
            ),
          ),
          position: Vector2(rect.x+_width/2, rect.y+height/2))..anchor=Anchor.center;

      text2=   TextComponent(
          text: levelNumber.toString(),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color.fromARGB(80, 255, 153, 51) ,
            ),
          ),
          position: Vector2(rect.x+_width/2+3, rect.y+height/2+3))..anchor=Anchor.center;

    }else{
      text1=  TextComponent(
        // key: ComponentKey.named('1'),
          text: levelNumber.toString(),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: Colors.black12,
            ),
          ),
          position: Vector2(rect.x+_width/2, rect.y+height/2))..anchor=Anchor.center;
      text2=   TextComponent(
          text: levelNumber.toString(),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color.fromARGB(80, 255, 153, 51) ,
            ),
          ),
          position: Vector2(rect.x+_width/2+3, rect.y+height/2+3))..anchor=Anchor.center;
    }

    add(text1);


    add(text2);
textComplete=true;
    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    if (MenuLevelSelectWorld.totalLevelsInGame>=levelNumber) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('currentLevel', levelNumber);
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (MenuLevelSelectWorld.totalLevelsInGame>=levelNumber) {
      gameRef.router.pushReplacementNamed("main");
    }
    super.onTapUp(event);
  }


}
