import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// The player entity — a diamond/rhombus shape at the bottom of the screen.
///
/// Moves left/right via [dodgeLeft] and [dodgeRight] using [MoveEffect]
/// for smooth, snappy animation. Collision hitboxes will be added in
/// Plan 02-03.
class Player extends PositionComponent with HasGameReference<PulseGame> {
  Player()
      : super(
          size: Vector2.all(GameConfig.playerSize),
          anchor: Anchor.center,
          position: Vector2(
            GameConfig.worldWidth / 2,
            GameConfig.playerStartY,
          ),
        );

  final Paint _paint = Paint()..color = GameConfig.playerColor;

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

  @override
  void render(Canvas canvas) {
    final halfW = size.x / 2;
    final halfH = size.y / 2;

    final path = Path()
      ..moveTo(halfW, 0) // top
      ..lineTo(size.x, halfH) // right
      ..lineTo(halfW, size.y) // bottom
      ..lineTo(0, halfH) // left
      ..close();

    canvas.drawPath(path, _paint);
  }
}
