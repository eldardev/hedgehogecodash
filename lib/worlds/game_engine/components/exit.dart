import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';
import '../first_world.dart';

class Exit extends PositionComponent with CollisionCallbacks{
  List<int> exitType;
  Vector2 animationFrameSize = Vector2(160, 160);
  String imageExitPath ='items/itemApple.png';
  FirstWorld world = GetIt.I.get<FirstWorld>();
 late CircleHitbox hitBox ;

  Exit({required this.exitType}){
    size = animationFrameSize;
    anchor = Anchor.center;
    priority = 1;
    hitBox = CircleHitbox(radius: size.x/2, anchor: Anchor.center, position: Vector2(size.x/2, size.y/2))..debugMode=world.debugMode;
    add(hitBox);
  }
  void removeComponents() {
    hitBox.parent = this;
    remove(hitBox);
  }

@override
  Future<void> onLoad() async {
    super.onLoad();
  }
}