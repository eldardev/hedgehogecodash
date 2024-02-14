import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'components/block_component.dart';
import 'components/water_enemy_component.dart';

class DemoWorld extends World {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('water_enemy.png');

    await add(PositionComponent(
        key: ComponentKey.named('player1'),
        position: Vector2(200, 50),
        children: [BlockSpriteComponent()]));

    await add(PositionComponent(
        key: ComponentKey.named('player2'),
        position: Vector2(100, 200),
        children: [BlockSpriteComponent()]));

    // final key = ComponentKey.unique();
    // flameGame.findByKey(ComponentKey.named('player'));
    // flameGame.findByKeyName('player');
    await add(PositionComponent(
        key: ComponentKey.named('player3'),
        position: Vector2(0, 120),
        children: [
          BlockSpriteComponent(),
          BlockSpriteComponent(),
        ]));

    await add(WaterEnemyComponent());

    await add(RectangleComponent(
        position: Vector2(0, 100),
        size: Vector2.all(100),
        anchor: Anchor.topLeft,
        paint: Paint()..color = Colors.red));
  }
}
