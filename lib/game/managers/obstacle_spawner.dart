import 'dart:math';

import 'package:flame/components.dart';

import '../components/obstacle.dart';
import '../config/game_config.dart';
import '../pulse_game.dart';
import 'pattern_sequencer.dart';

/// Spawns [Obstacle] formations at regular intervals during gameplay.
///
/// Uses a [PatternSequencer] to select obstacle patterns, then translates
/// each pattern's [ObstaclePlacement] list into concrete [Obstacle] instances
/// added to the game world.
///
/// Spawn timing is accumulator-based: when the timer fires, a pattern is
/// requested from the sequencer, all its obstacles are spawned, and the
/// pattern's [postDelay] is added to the timer before the next spawn.
///
/// Only spawns when [PulseGame.state] is [GameState.playing].
class ObstacleSpawner extends Component with HasGameReference<PulseGame> {
  final Random _random = Random();
  late final PatternSequencer _sequencer = PatternSequencer(random: _random);
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    // Update sequencer difficulty and gap scale from the DifficultyManager.
    _sequencer.setDifficulty(game.difficultyManager.difficultyLevel);
    _sequencer.setGapScale(game.difficultyManager.gapScale);

    _elapsed += dt;

    // Dynamic spawn interval: base interval scaled by difficulty.
    // During breather phases, multiply by the breather bonus for extra room.
    var interval =
        GameConfig.spawnInterval * game.difficultyManager.intervalMultiplier;
    if (_sequencer.isBreather) {
      interval *= GameConfig.rhythmBreatherIntervalBonus;
    }

    while (_elapsed >= interval) {
      _elapsed -= interval;

      // Select a pattern from the sequencer.
      final pattern = _sequencer.next();

      // Dynamic obstacle speed: base speed scaled by difficulty.
      final speed =
          GameConfig.obstacleSpeed * game.difficultyManager.speedMultiplier;

      // Spawn each obstacle placement in the pattern.
      for (final placement in pattern.placements) {
        // Map normalizedX (0.0-1.0) to world x within player movement bounds.
        final x = GameConfig.playerMinX +
            placement.normalizedX *
                (GameConfig.playerMaxX - GameConfig.playerMinX);

        // yOffset shifts from the spawn line (negative = further above).
        final y = GameConfig.obstacleSpawnY + placement.yOffset;

        // Use widthOverride if provided, otherwise random width.
        final width = placement.widthOverride ??
            (GameConfig.obstacleMinWidth +
                _random.nextDouble() *
                    (GameConfig.obstacleMaxWidth - GameConfig.obstacleMinWidth));

        final obstacle = Obstacle(
          position: Vector2(x, y),
          width: width,
          speed: speed,
        );

        parent?.add(obstacle);
      }

      // Add the pattern's postDelay to the timer so there's a gap
      // before the next pattern spawns.
      _elapsed -= pattern.postDelay;
    }
  }

  /// Reset the spawn timer and sequencer state (call on game start/restart).
  void reset() {
    _elapsed = 0;
    _sequencer.reset();
  }
}
