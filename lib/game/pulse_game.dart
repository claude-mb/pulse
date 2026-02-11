import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class PulseGame extends FlameGame with HasCollisionDetection {
  PulseGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 400,
            height: 800,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    world.add(ScreenHitbox());
  }

  /// Start a new game session. Wired in Plan 01-04.
  void startGame() {}

  /// Handle game over state. Wired in Plan 01-04.
  void gameOver() {}

  /// Reset the game to initial state. Wired in Plan 01-04.
  void resetGame() {}
}
