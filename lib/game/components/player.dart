import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../config/game_config.dart';
import '../effects/dodge_sparkle.dart';
import '../pulse_game.dart';
import 'obstacle.dart';

/// The player entity — a diamond/rhombus shape at the bottom of the screen.
///
/// Uses [PolygonComponent] for reliable cross-platform rendering (including web).
/// Moves left/right via [dodgeLeft] and [dodgeRight] using [MoveEffect]
/// for smooth, snappy animation. Detects collisions with [Obstacle]s and
/// triggers game over.
class Player extends PolygonComponent
    with HasGameReference<PulseGame>, CollisionCallbacks {
  Player()
      : super(
          // Diamond vertices: top, right, bottom, left
          [
            Vector2(20, 0),
            Vector2(40, 20),
            Vector2(20, 40),
            Vector2(0, 20),
          ],
          anchor: Anchor.center,
          position: Vector2(
            GameConfig.worldWidth / 2,
            GameConfig.playerStartY,
          ),
          paint: Paint()..color = GameConfig.playerColor,
        );

  /// Timer for the idle pulse animation (glow breathing effect).
  double _pulseTimer = 0.0;

  /// Paint for the glow layer behind the player diamond.
  final Paint _glowPaint = Paint()
    ..color = GameConfig.playerColor.withValues(
      alpha: GameConfig.playerGlowOpacity,
    )
    ..maskFilter = const MaskFilter.blur(
      BlurStyle.normal,
      GameConfig.playerGlowRadius,
    );

  /// Diamond path in local coordinates for the solid fill.
  late final Path _diamondPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 80% hitbox centered on the player — forgiving near-misses.
    add(
      RectangleHitbox.relative(
        Vector2(0.8, 0.8),
        parentSize: size,
        position: size * 0.1,
      ),
    );

    // Pre-build the diamond path for manual rendering.
    _diamondPath = Path()
      ..moveTo(20, 0)
      ..lineTo(40, 20)
      ..lineTo(20, 40)
      ..lineTo(0, 20)
      ..close();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    // Calculate glow scale oscillation for idle pulse breathing.
    // Oscillates between 1.2x and 1.4x for a gentle breathing effect.
    final pulse = math.sin(
      _pulseTimer * 2 * math.pi * GameConfig.playerPulseFrequency,
    );
    final glowScale = 1.3 + 0.1 * pulse; // 1.2 to 1.4

    // 1. Draw glow layer — scaled-up blurred diamond.
    canvas.save();
    // Scale around the center of the diamond (20, 20).
    canvas.translate(20, 20);
    canvas.scale(glowScale);
    canvas.translate(-20, -20);
    canvas.drawPath(_diamondPath, _glowPaint);
    canvas.restore();

    // 2. Draw solid diamond on top (using component's paint).
    canvas.drawPath(_diamondPath, paint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      // Guard: prevent multiple gameOver calls from simultaneous collisions.
      if (game.state != GameState.playing) return;
      game.gameOver();
    }
  }

  /// Dodge the player to the left by [GameConfig.playerDodgeDistance],
  /// clamped to [GameConfig.playerMinX].
  void dodgeLeft() {
    final targetX =
        (position.x - GameConfig.playerDodgeDistance).clamp(
          GameConfig.playerMinX,
          GameConfig.playerMaxX,
        );
    _moveTo(targetX);
    game.world.add(
      DodgeSparkle.create(
        position: position,
        direction: DodgeDirection.left,
      ),
    );
  }

  /// Dodge the player to the right by [GameConfig.playerDodgeDistance],
  /// clamped to [GameConfig.playerMaxX].
  void dodgeRight() {
    final targetX =
        (position.x + GameConfig.playerDodgeDistance).clamp(
          GameConfig.playerMinX,
          GameConfig.playerMaxX,
        );
    _moveTo(targetX);
    game.world.add(
      DodgeSparkle.create(
        position: position,
        direction: DodgeDirection.right,
      ),
    );
  }

  /// Reset the player to the center starting position.
  void resetPosition() {
    // Cancel any in-flight move effects.
    children.whereType<MoveEffect>().forEach((e) => e.removeFromParent());
    position = Vector2(GameConfig.worldWidth / 2, GameConfig.playerStartY);
  }

  /// Internal: cancel existing move effects and animate to [targetX].
  void _moveTo(double targetX) {
    children.whereType<MoveEffect>().forEach((e) => e.removeFromParent());
    add(
      MoveEffect.to(
        Vector2(targetX, position.y),
        EffectController(duration: 0.1),
      ),
    );
  }
}
