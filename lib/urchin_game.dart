import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/level_done/level_done_world.dart';

import 'worlds/worlds.dart';

@injectable
class UrchinGame extends FlameGame with HasCollisionDetection {
  final DemoWorld _demoWorld;
  final MenuWorld _menuWorld;
  final FirstWorld _firstWorld;
  final LevelBuilderWorld _levelBuilderWorld;
  final LevelDoneWorld _levelDoneWorld;

  late RouterComponent router;

  UrchinGame(this._demoWorld, this._menuWorld, this._firstWorld,
      this._levelBuilderWorld, this._levelDoneWorld) {
    pauseWhenBackgrounded = false;
  }

  @override
  Future<void> onLoad() async {
    router = RouterComponent(
      routes: {
        'demo': Route(() => _demoWorld),
        'main': Route(() => _firstWorld),
        'menu': Route(() => _menuWorld),
        'level_builder': Route(() => _levelBuilderWorld),
        'level_done': Route(() => _levelDoneWorld),
      },
      initialRoute: 'level_done',
    );

    [_demoWorld, _menuWorld, _firstWorld, _levelBuilderWorld, _levelDoneWorld]
        .forEach((e) => add(e.camera));
    add(router);

    return super.onLoad();
  }

  @override
  void onRemove() {
    // Optional based on your game needs.
    removeAll(children);
    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();
    // Any other code that you want to run when the game is removed.
  }
}
