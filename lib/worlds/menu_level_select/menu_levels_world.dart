import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/level_done/components/main_menu_button.dart';
import 'package:urchin/worlds/menu/components/menu_background.dart';
import 'package:urchin/worlds/menu_level_select/components/level_button.dart';

@singleton
class MenuLevelSelectWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    await Flame.images.load("menu/bg.png");
    await Flame.images.load("menu/item_flower.png");
    await Flame.images.load("menu/button_level.png");

    add(MenuBackground());
    add(MainMenuButton()
      ..position = Vector2(400, 1010)
      ..scale = Vector2(0.8, 0.8));
Vector2 startPos = Vector2(200, 300);
Vector2 buttonSize = Vector2(200, 200);
    for(int j=0; j< 4; j++) {
      for (int i = 0; i < 5; i++) {
        add(LevelButton(levelNumber: (j*5)+i + 1)
          ..position = Vector2(startPos.x + buttonSize.x * i,
              startPos.y+buttonSize.y*j)
          ..scale = Vector2(0.8, 0.8));
      }
    }
    playBgMusic();
  }

  void playBgMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.mp3');
  }
}
