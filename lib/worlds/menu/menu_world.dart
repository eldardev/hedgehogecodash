import 'package:flame/flame.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/menu/components/flower_component.dart';
import 'package:urchin/worlds/menu/components/level_builder_button.dart';
import 'package:urchin/worlds/menu/components/menu_background.dart';
import 'package:urchin/worlds/menu/components/menu_button.dart';

@singleton
class MenuWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    await Flame.images.load("menu/bg.png");
    await Flame.images.load("menu/item_flower.png");

    add(MenuBackground());
    add(FlowerComponent());
    addAll([PlayButton(), LevelBuilderButton()]);
  }
}
