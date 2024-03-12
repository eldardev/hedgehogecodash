import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:urchin/worlds/game_engine/components/urchin.dart';

import 'garbage.dart';

class UrchinFace extends PositionComponent with CollisionCallbacks {
  Urchin faceHolder;
  List<PositionComponent> barrierList = [];
  late CircleHitbox circleHitbox;

  UrchinFace({required this.faceHolder}) {
    anchor = Anchor.center;
    circleHitbox = CircleHitbox(radius: 40, anchor: Anchor.center)
      ..isSolid = true
      ..position = Vector2(0, -(faceHolder.size.y * faceHolder.scale.y) / 6)
      ..debugMode = faceHolder.world.debugMode;
    add(circleHitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (((other is Urchin) && (other != faceHolder)) ||
        (other is Garbage && !other.flyAnimation)) {
      faceHolder.urchinMovePause(true);
      barrierList.add(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if ((other is Urchin) || (other is Garbage)) {
      barrierList.remove(other);
      if (barrierList.isEmpty) {
        faceHolder.urchinMovePause(false);
      }
    }
    super.onCollisionEnd(other);
  }

  @override
  void onRemove() {
    // barrierList.clear();
    // circleHitbox.removeFromParent();
    super.onRemove();
  }
}
