import 'dart:math';

import 'package:flame/components.dart';

import '../config/game_config.dart';

/// A reusable screen-shake effect that applies decaying random offsets to its
/// parent's position (typically `camera.viewfinder`).
///
/// Each frame, the viewfinder position is set to the base camera position
/// plus a random offset within the current (decaying) intensity range.
/// When the duration expires, the parent position is restored to the exact
/// base position and this component removes itself.
///
/// Usage:
/// ```dart
/// camera.viewfinder.add(ScreenShake(intensity: 8.0, duration: 0.3));
/// ```
class ScreenShake extends Component {
  /// Maximum pixel offset at the start of the shake.
  final double intensity;

  /// Total duration of the shake in seconds.
  final double duration;

  final Random _random = Random();
  double _elapsed = 0.0;

  /// The base position to restore after shaking — centre of the game world.
  static final Vector2 _basePosition = Vector2(
    GameConfig.worldWidth / 2,
    GameConfig.worldHeight / 2,
  );

  ScreenShake({
    required this.intensity,
    required this.duration,
  });

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    final positionParent = parent;
    if (positionParent is! PositionComponent) {
      removeFromParent();
      return;
    }

    if (_elapsed >= duration) {
      // Restore exact base position and clean up.
      positionParent.position.setFrom(_basePosition);
      removeFromParent();
      return;
    }

    // Decay: intensity diminishes linearly over the duration.
    final currentIntensity = intensity * (1 - _elapsed / duration);

    // Random offset in [-currentIntensity, +currentIntensity] for each axis.
    final offsetX =
        (_random.nextDouble() * 2 - 1) * currentIntensity;
    final offsetY =
        (_random.nextDouble() * 2 - 1) * currentIntensity;

    positionParent.position.setFrom(
      _basePosition + Vector2(offsetX, offsetY),
    );
  }
}
