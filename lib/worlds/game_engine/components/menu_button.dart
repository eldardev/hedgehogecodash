import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import '../../../urchin_game.dart';

class MainMenuButton extends SpriteComponent with TapCallbacks, HasGameRef<UrchinGame>{
  MainMenuButton(){
    sprite=Sprite(Flame.images.fromCache('menu/menu_button.png'));
  }
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.router.pushReplacementNamed("menu");
    super.onTapDown(event);
  }
}