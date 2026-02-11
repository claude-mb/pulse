import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../config/game_config.dart';

/// A falling obstacle that the player must dodge.
///
/// Extends [RectangleComponent] for built-in rectangle rendering.
/// Moves downward at [GameConfig.obstacleSpeed] and auto-removes
/// when it passes below the visible world area.
/// Width can vary between [GameConfig.obstacleMinWidth] and
/// [GameConfig.obstacleMaxWidth] for visual variety.
class Obstacle extends RectangleComponent {
  Obstacle({required Vector2 position, double? width})
      : super(
          position: position,
          size: Vector2(
            width ?? GameConfig.obstacleWidth,
            GameConfig.obstacleHeight,
          ),
          anchor: Anchor.center,
          paint: Paint()..color = GameConfig.obstacleColor,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Full-size hitbox — obstacles are the threat, no forgiveness.
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += GameConfig.obstacleSpeed * dt;

    // Remove when fully off-screen (with 50px buffer).
    if (position.y > GameConfig.worldHeight + 50) {
      removeFromParent();
    }
  }
}
