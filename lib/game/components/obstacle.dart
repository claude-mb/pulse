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

  // Face paint objects for "Angry Blocks" theme.
  static final Paint _facePaint = Paint()
    ..color = GameConfig.faceColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round;
  static final Paint _faceDotPaint = Paint()
    ..color = GameConfig.faceColor
    ..style = PaintingStyle.fill;

  /// Reassigns static paint colors from the current [GameConfig] theme.
  ///
  /// Call after changing [GameConfig.activeTheme] so existing and future
  /// obstacles render with the new palette.
  static void refreshThemeColors() {
    _fillPaint.color = GameConfig.obstacleColor;
    _outlinePaint.color = GameConfig.obstacleOutlineColor;
    _highlightPaint.color = GameConfig.obstacleHighlightColor;
    _facePaint.color = GameConfig.faceColor;
    _faceDotPaint.color = GameConfig.faceColor;
  }

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

    // 4. Angry face overlay (theme-dependent).
    if (GameConfig.drawFace) {
      _renderAngryFace(canvas, rect);
    }
  }

  /// Draws a hand-drawn angry face centered on the obstacle.
  ///
  /// All coordinates are proportional to [rect] dimensions so the face
  /// scales with obstacle width/height. Uses round stroke caps for an
  /// organic feel.
  void _renderAngryFace(Canvas canvas, Rect rect) {
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final h = rect.height;
    final w = rect.width;

    // Eye positions — offset from center horizontally.
    final eyeSpacing = w * 0.15;
    final eyeY = cy - h * 0.05;
    final eyeRadius = h * 0.08;

    // 1. Left eye (filled dot).
    canvas.drawCircle(Offset(cx - eyeSpacing, eyeY), eyeRadius, _faceDotPaint);

    // 2. Right eye (filled dot).
    canvas.drawCircle(Offset(cx + eyeSpacing, eyeY), eyeRadius, _faceDotPaint);

    // Eyebrow dimensions — V-shape sloping inward = angry.
    final browLength = w * 0.10;
    final browY = eyeY - h * 0.20;
    final browDrop = h * 0.12;

    // 3. Left eyebrow (slopes down toward center).
    canvas.drawLine(
      Offset(cx - eyeSpacing - browLength, browY),
      Offset(cx - eyeSpacing + browLength, browY + browDrop),
      _facePaint,
    );

    // 4. Right eyebrow (slopes down toward center).
    canvas.drawLine(
      Offset(cx + eyeSpacing + browLength, browY),
      Offset(cx + eyeSpacing - browLength, browY + browDrop),
      _facePaint,
    );

    // 5. Frown — downward arc below eyes.
    final mouthY = cy + h * 0.18;
    final mouthWidth = w * 0.12;
    final mouthDepth = h * 0.10;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, mouthY + mouthDepth),
        width: mouthWidth * 2,
        height: mouthDepth * 2,
      ),
      3.6, // ~206 degrees — start past top-left
      2.1, // sweep ~120 degrees for a frown arc
      false,
      _facePaint,
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
          game.scoreManager.addNearMiss();
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
