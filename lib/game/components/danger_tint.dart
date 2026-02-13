import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// Persistent full-screen overlay that subtly tints the screen red as
/// difficulty increases, creating subconscious tension.
///
/// Invisible at difficulty level 1 and gradually becomes visible through
/// level 5, never exceeding [GameConfig.dangerTintMaxOpacity] (0.12).
/// The effect is intentionally very subtle — players should feel increasing
/// tension without consciously noticing the tint.
///
/// Added to the world in [PulseGame.onLoad] and remains present for the
/// entire game session. Priority -1 renders behind obstacles and player
/// but above the background color.
class DangerTint extends RectangleComponent
    with HasGameReference<PulseGame> {
  DangerTint()
      : super(
          size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight),
          position: Vector2.zero(),
          paint: Paint()..color = GameConfig.dangerTintColor,
          priority: -1,
        );

  /// Opacity targets per difficulty level (1-indexed).
  /// Level 1 = invisible, level 5 = max subtle tint.
  static const List<double> _levelOpacities = [
    0.0, // level 1
    0.02, // level 2
    0.05, // level 3
    0.08, // level 4
    0.12, // level 5 (max)
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Start fully invisible.
    opacity = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final dm = game.difficultyManager;

    // Derive overall difficulty progress from speed multiplier (1.0 to max).
    // This gives smooth interpolation across all levels rather than discrete
    // jumps at level boundaries.
    final overallProgress =
        ((dm.speedMultiplier - 1.0) /
                (GameConfig.maxSpeedMultiplier - 1.0))
            .clamp(0.0, 1.0);

    // Map overall progress to opacity by interpolating between level targets.
    // overallProgress 0.0 = level 1 (invisible), 1.0 = level 5 (max tint).
    final maxLevels = _levelOpacities.length; // 5
    final levelProgress = overallProgress * (maxLevels - 1);
    final baseLevelIndex = levelProgress.floor().clamp(0, maxLevels - 2);
    final fracProgress = levelProgress - baseLevelIndex;

    final baseOpacity = _levelOpacities[baseLevelIndex];
    final targetOpacity = _levelOpacities[
        (baseLevelIndex + 1).clamp(0, maxLevels - 1)];

    opacity = lerpDouble(baseOpacity, targetOpacity, fracProgress)!
        .clamp(0.0, GameConfig.dangerTintMaxOpacity);
  }
}
