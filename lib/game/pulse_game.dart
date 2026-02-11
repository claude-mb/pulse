import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/tap_indicator.dart';

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
    world.add(_WorldTapHandler());
  }

  /// Start a new game session. Wired in Plan 01-04.
  void startGame() {}

  /// Handle game over state. Wired in Plan 01-04.
  void gameOver() {}

  /// Reset the game to initial state. Wired in Plan 01-04.
  void resetGame() {}
}

/// World-level tap handler — receives events in world coordinates.
/// Game-level TapCallbacks gives canvas coordinates which don't match
/// the world coordinate space under CameraComponent.withFixedResolution.
/// Phase 2 will move input to component-level TapCallbacks on Player.
class _WorldTapHandler extends Component with TapCallbacks {
  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    parent?.add(TapIndicator(position: event.localPosition));
  }
}
