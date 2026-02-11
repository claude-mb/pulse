import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// Escalates game difficulty over survival time.
///
/// Tracks [PulseGame.survivalTime] and derives smooth multipliers for
/// obstacle speed and spawn interval using lerp interpolation across
/// five difficulty levels. The spawner reads these multipliers each frame
/// to scale base values from [GameConfig].
///
/// Difficulty levels (time-based):
/// - Level 1: 0-10s (warmup, single patterns only)
/// - Level 2: 10-25s (introduce doubleGap and stagger)
/// - Level 3: 25-45s (introduce wave)
/// - Level 4: 45-70s (all patterns, faster)
/// - Level 5: 70s+ (maximum difficulty)
class DifficultyManager extends Component with HasGameReference<PulseGame> {
  double _speedMultiplier = 1.0;
  double _intervalMultiplier = 1.0;
  int _difficultyLevel = 1;

  /// Current speed multiplier (1.0 at level 1, up to [GameConfig.maxSpeedMultiplier]).
  double get speedMultiplier => _speedMultiplier;

  /// Current interval multiplier (1.0 at level 1, down to [GameConfig.minIntervalMultiplier]).
  double get intervalMultiplier => _intervalMultiplier;

  /// Current discrete difficulty level (1-5).
  int get difficultyLevel => _difficultyLevel;

  /// Gap scale factor based on difficulty level.
  ///
  /// Controls how wide survivable gaps are in obstacle patterns.
  /// Lower values = narrower gaps = harder.
  /// - Difficulty 1-2: 1.0 (80px+ gaps)
  /// - Difficulty 3: 0.9 (72px gaps)
  /// - Difficulty 4: 0.8 (64px gaps)
  /// - Difficulty 5: 0.75 (60px gaps)
  double get gapScale {
    switch (_difficultyLevel) {
      case 1:
      case 2:
        return 1.0;
      case 3:
        return 0.9;
      case 4:
        return 0.8;
      case 5:
        return 0.75;
      default:
        return 1.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    final time = game.survivalTime;
    final thresholds = GameConfig.difficultyThresholds;

    // Determine which level bracket we're in and the progress within it.
    int level = 1;
    double progress = 0.0; // 0.0-1.0 within the current bracket

    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (time >= thresholds[i]) {
        level = i + 1; // levels are 1-indexed
        if (i < thresholds.length - 1) {
          final bracketStart = thresholds[i];
          final bracketEnd = thresholds[i + 1];
          progress = ((time - bracketStart) / (bracketEnd - bracketStart))
              .clamp(0.0, 1.0);
        } else {
          // At or beyond the last threshold — max difficulty.
          progress = 1.0;
        }
        break;
      }
    }

    _difficultyLevel = level;

    // Overall progress through all levels (0.0 to 1.0).
    // level 1 at progress 0.0 = 0.0, level 5 at progress 1.0 = 1.0
    final maxLevels = thresholds.length; // 5
    final overallProgress =
        ((level - 1) + progress).clamp(0.0, maxLevels - 1) / (maxLevels - 1);

    // Lerp multipliers based on overall progress.
    _speedMultiplier = lerpDouble(1.0, GameConfig.maxSpeedMultiplier, overallProgress)!;
    _intervalMultiplier =
        lerpDouble(1.0, GameConfig.minIntervalMultiplier, overallProgress)!;
  }

  /// Reset to initial state (call on game start/restart).
  void reset() {
    _speedMultiplier = 1.0;
    _intervalMultiplier = 1.0;
    _difficultyLevel = 1;
  }
}
