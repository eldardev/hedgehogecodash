import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urchin/urchin_game.dart';

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
            anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {

    rect = RectangleComponent(
        size: Vector2(_width, _height),
        anchor: Anchor.center,
        paint: Paint()..color = Colors.transparent)..debugMode=true;

    add(rect);

    var spr = SpriteComponent(
        sprite: Sprite(Flame.images.fromCache('menu/button_level.png')),anchor: Anchor.center);
    add(spr);
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
    position: Vector2(rect.x, rect.y))..anchor=Anchor.center;
    add(text1);

    text2=   TextComponent(
        text: levelNumber.toString(),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 80.0,
            fontFamily: "Gogono Cocoa Mochi",
            color: const Color.fromARGB(80, 255, 153, 51),
          ),
        ),
        position: Vector2(rect.x + 3, rect.y + 3))..anchor=Anchor.center;
    add(text2);
textComplete=true;
    super.onLoad();
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentLevel', levelNumber);
    // final playButton = gameRef.findByKeyName('play_button') as TextComponent;
    // playButton.textRenderer = TextPaint(
    //   style: const TextStyle(
    //     fontSize: 80.0,
    //     fontFamily: "Gogono Cocoa Mochi",
    //     color: const Color(0xFFFFFF02),
    //   ),
    // );

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.router.pushReplacementNamed("main");
    super.onTapUp(event);
  }

  void selectLevel({required int levelNumber}){
    this.levelNumber = levelNumber;
    if(textComplete) {
      if (contains(text1)) {
        remove(text1);
      }
      if ( contains(text2)) {
        remove(text2);
      }


      text1 = TextComponent(
        // key: ComponentKey.named('1'),
          text: levelNumber.toString(),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 80.0,
              fontFamily: "Gogono Cocoa Mochi",
              color: const Color(0xFFFA9933),
            ),
          ),
          position: Vector2(rect.x, rect.y))
        ..anchor = Anchor.center;
      add(text1);

      text2.text = 'hjkhkjh';
      // text2 = TextComponent(
      //     text: levelNumber.toString(),
      //     textRenderer: TextPaint(
      //       style: const TextStyle(
      //         fontSize: 80.0,
      //         fontFamily: "Gogono Cocoa Mochi",
      //         color: const Color.fromARGB(80, 255, 153, 51),
      //       ),
      //     ),
      //     position: Vector2(rect.x + 2, rect.y + 2))
      //   ..anchor = Anchor.center;
      // add(text2);
    }
    //text2.text=levelNumber.toString();
  }
}
