import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'worlds/worlds.dart';

class UrchinGame extends FlameGame {
  final demoWorld = DemoWorld();

  UrchinGame() {
    pauseWhenBackgrounded = false;
  }

  @override
  Future<void> onLoad() async {
    final cam = CameraComponent.withFixedResolution(
      world: demoWorld,
      width: 2400,
      height: 1080,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.viewfinder.position = Vector2(0, 0);

    addAll([cam, demoWorld]);
    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Colors.green;
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
