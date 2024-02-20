import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';
import 'package:urchin/worlds/game_engine/first_world.dart';


class UrchinGame extends FlameGame {
  var firstWorld = GetIt.I.registerSingleton<FirstWorld>(FirstWorld());
  //var demoWorld = firstWorld;

  UrchinGame() {
    pauseWhenBackgrounded = false;
  }

  @override
  Future<void> onLoad() async {
    final cam = CameraComponent.withFixedResolution(
      world: firstWorld,
      width: 2400,
      height: 1080,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.viewfinder.position = Vector2(0, 0);

    addAll([cam, firstWorld]);
    return super.onLoad();
  }

  // @override
  // Color backgroundColor() {
  //   return Colors.green;
  // }

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
