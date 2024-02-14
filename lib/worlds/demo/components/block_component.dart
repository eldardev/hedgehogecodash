import 'package:flame/components.dart';

/// A component that renders the crate sprite, with a 16 x 16 size.
class BlockSpriteComponent extends SpriteComponent with HasVisibility {
  BlockSpriteComponent()
      : super(size: Vector2.all(16), priority: 1, position: Vector2(0, 0)) {
    // this.isVisible = false;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('block.png');
  }
}
