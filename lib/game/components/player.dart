import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// The player entity — a diamond/rhombus shape at the bottom of the screen.
///
/// Controlled via dodge methods (added in Task 2). Collision hitboxes
/// will be added in Plan 02-03.
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
