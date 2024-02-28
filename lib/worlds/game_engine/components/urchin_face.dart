import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:urchin/worlds/game_engine/components/urchin.dart';

import 'garbage.dart';

class UrchinFace extends PositionComponent with CollisionCallbacks {
  Urchin faceHolder;
  List<PositionComponent> barrierList = [];

  UrchinFace({required this.faceHolder}) {
    anchor = Anchor.center;
    add(CircleHitbox(radius: 60, anchor: Anchor.center)
      ..isSolid = true
      ..debugMode = faceHolder.world.debugMode);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (((other is Urchin) && (other != faceHolder)) || (other is Garbage)) {
      faceHolder.urchinMovePause(true);
      barrierList.add(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if ((other is Urchin) || (other is Garbage)) {
      barrierList.remove(other);
      if(barrierList.isEmpty) {
        faceHolder.urchinMovePause(false);
      }
    }
    super.onCollisionEnd(other);
  }
}
