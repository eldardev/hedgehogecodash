import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:urchin/worlds/common/common_world.dart';

@singleton
class MenuWorld extends CommonWorld {
  @override
  Future<void> onLoad() async {
    await add(RectangleComponent(
        position: Vector2(0, 100),
        size: Vector2.all(100),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.green));
  }
}
