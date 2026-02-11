import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';

/// A falling obstacle that the player must dodge.
///
/// Extends [RectangleComponent] for built-in rectangle rendering.
/// Moves downward at [GameConfig.obstacleSpeed] and auto-removes
/// when it passes below the visible world area.
/// Collision hitboxes will be added in Plan 02-03.
class Obstacle extends RectangleComponent {
  Obstacle({required Vector2 position})
      : super(
          position: position,
          size: Vector2(GameConfig.obstacleWidth, GameConfig.obstacleHeight),
          anchor: Anchor.center,
          paint: Paint()..color = GameConfig.obstacleColor,
        );

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
