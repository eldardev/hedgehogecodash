import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';
import 'package:urchin/worlds/menu/components/level_builder_button.dart';
import 'package:urchin/worlds/menu/components/menu_button.dart';

@singleton
class MenuWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    addAll([MenuButton(), LevelBuilderButton()]);
  }
}
