import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/menu/components/flower_component.dart';
import 'package:urchin/worlds/menu/components/menu_background.dart';
import 'package:urchin/worlds/menu/components/play_button.dart';

import 'components/exit_button.dart';

@singleton
class MenuWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    await Flame.images.load("menu/bg.png");
    await Flame.images.load("menu/item_flower.png");

    add(MenuBackground());
    add(FlowerComponent());
    addAll([PlayButton(), ExitButton()]);
    playBgMusic();
  }

  void playBgMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.mp3');
  }
}
