import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// A falling obstacle that the player must dodge.
///
/// Extends [RectangleComponent] for built-in rectangle rendering.
/// Moves downward at [speed] (defaults to [GameConfig.obstacleSpeed])
/// and auto-removes when it passes below the visible world area.
/// Width can vary between [GameConfig.obstacleMinWidth] and
/// [GameConfig.obstacleMaxWidth] for visual variety.
///
/// Detects near-misses: when the obstacle passes the player zone without
/// colliding and is within [GameConfig.nearMissThreshold] pixels
/// horizontally, a subtle screen shake is triggered.
class Obstacle extends RectangleComponent
    with HasGameReference<PulseGame> {
  /// Downward speed in pixels per second.
  final double speed;

  /// Whether this obstacle has already checked the player zone for a near-miss.
  bool _passedPlayerZone = false;

  // Paint objects for styled obstacle rendering.
  static final Paint _fillPaint = Paint()..color = GameConfig.obstacleColor;
  static final Paint _outlinePaint = Paint()
    ..color = GameConfig.obstacleOutlineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  static final Paint _highlightPaint = Paint()
    ..color = GameConfig.obstacleHighlightColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  Obstacle({
    required Vector2 position,
    double? width,
    double? speed,
  })  : speed = speed ?? GameConfig.obstacleSpeed,
        super(
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
  void render(Canvas canvas) {
    // Draw manually for geometric styled look — fill, outline, highlight.
    final rect = size.toRect();

    // 1. Filled rectangle (base).
    canvas.drawRect(rect, _fillPaint);

    // 2. Stroke outline for crisp geometric edge.
    canvas.drawRect(rect, _outlinePaint);

    // 3. Top-edge highlight for depth / lit-from-above look.
    canvas.drawLine(
      rect.topLeft,
      rect.topRight,
      _highlightPaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    // Near-miss detection: check once when obstacle passes player's Y zone.
    if (!_passedPlayerZone &&
        position.y > GameConfig.playerStartY + GameConfig.playerSize / 2) {
      _passedPlayerZone = true;
      if (game.state == GameState.playing) {
        final horizontalDistance =
            (position.x - game.player.position.x).abs();
        if (horizontalDistance < GameConfig.nearMissThreshold) {
          game.triggerShake(
            GameConfig.shakeIntensityNearMiss,
            GameConfig.shakeDurationNearMiss,
          );
          // Near-miss volume scales with difficulty (0.5 at level 1, 1.0 at level 5).
          final nearMissVolume = (GameConfig.nearMissBaseVolume +
                  (game.difficultyManager.speedMultiplier - 1.0) * 0.83)
              .clamp(GameConfig.nearMissBaseVolume, GameConfig.nearMissMaxVolume);
          game.audioManager.playSfx('near_miss.wav', volume: nearMissVolume);
        }
      }
    }

    // Remove when fully off-screen (with 50px buffer).
    if (position.y > GameConfig.worldHeight + 50) {
      removeFromParent();
    }
  }
}
