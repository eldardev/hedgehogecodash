import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/menu/components/flower_component.dart';

import 'components/level_done_background.dart';
import 'components/main_menu_button.dart';
import 'components/next_level_button.dart';

@singleton
class LevelDoneWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    await Flame.images.load("menu/level_bg.png");
    await Flame.images.load("menu/item_flower.png");

    add(LevelDoneBackground());
    add(FlowerComponent());
    addAll([NextLevelButton(), MainMenuButton()]);
    playBgMusic();
  }

  void playBgMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.wav');
  }
}
