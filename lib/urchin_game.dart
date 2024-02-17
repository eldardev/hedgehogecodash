import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:injectable/injectable.dart';

import 'worlds/worlds.dart';

@injectable
class UrchinGame extends FlameGame {
  final DemoWorld _demoWorld;
  final MenuWorld _menuWorld;
  final FirstWorld _firstWorld;

  UrchinGame(
    this._demoWorld,
    this._menuWorld,
    this._firstWorld,
  ) {
    pauseWhenBackgrounded = false;
  }

  @override
  Future<void> onLoad() async {
    final router = RouterComponent(
      routes: {
        'demo': Route(() => _demoWorld),
        'main': Route(() => _firstWorld),
        'menu': Route(() => _menuWorld),
      },
      initialRoute: 'menu',
    );

    addAll([_demoWorld.camera, _firstWorld.camera, _menuWorld.camera, router]);
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
