import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/level_done/components/back_photo_background.dart';
import 'package:urchin/worlds/level_done/components/try_again.dart';
import 'package:urchin/worlds/level_done/components/you_did_it.dart';

import 'components/level_done_background.dart';
import 'components/level_flower_component.dart';
import 'components/main_menu_button.dart';
import 'components/next_level_button.dart';

@singleton
class LevelDoneWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int levelNumber = prefs.getInt('currentLevel') ?? 4;
    bool isSuccess = prefs.getBool("isSuccess") ?? false;

    await Flame.images.load("menu/level_bg.png");
    await Flame.images.load("menu/level_bg.png");
    await Flame.images.load("menu/item_flower.png");
    await Flame.images.load("back_photos/BackPhoto${levelNumber - 1}.jpg");

    add(BackPhotoBackground(level: levelNumber));
    add(LevelDoneBackground());
    add(LevelDoneFlowerComponent());
    if (isSuccess) {
      addAll([
        NextLevelButton(isSuccess: isSuccess),
        MainMenuButton(),
        YouDidIt()
      ]);
    } else {
      addAll([
        NextLevelButton(isSuccess: isSuccess),
        MainMenuButton(),
        TryAgain()
      ]);
    }

    playBgMusic();
  }

  void playBgMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/bg_music.wav');
  }
}
