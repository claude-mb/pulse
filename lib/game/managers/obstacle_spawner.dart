import 'dart:math';

import 'package:flame/components.dart';

import '../components/obstacle.dart';
import '../config/game_config.dart';
import '../pulse_game.dart';

/// Spawns [Obstacle] instances at regular intervals during gameplay.
///
/// Uses an accumulator-based timer in [update] to spawn obstacles
/// at [GameConfig.spawnInterval] intervals. Obstacles are placed at
/// random x positions within the player movement bounds and at
/// [GameConfig.obstacleSpawnY] (above the visible area).
///
/// Width varies randomly between [GameConfig.obstacleMinWidth] and
/// [GameConfig.obstacleMaxWidth]. Anti-clustering logic ensures
/// consecutive obstacles are at least [GameConfig.obstacleMinSpawnSeparation]
/// apart horizontally.
///
/// Only spawns when [PulseGame.state] is [GameState.playing].
class ObstacleSpawner extends Component with HasGameReference<PulseGame> {
  final Random _random = Random();
  double _elapsed = 0;
  double? _lastSpawnX;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    _elapsed += dt;

    while (_elapsed >= GameConfig.spawnInterval) {
      _elapsed -= GameConfig.spawnInterval;

      // Randomize obstacle width for visual variety.
      final width = GameConfig.obstacleMinWidth +
          _random.nextDouble() *
              (GameConfig.obstacleMaxWidth - GameConfig.obstacleMinWidth);

      // Pick a random x position, ensuring minimum separation from last spawn.
      final randomX = _pickSpawnX();

      _lastSpawnX = randomX;

      final obstacle = Obstacle(
        position: Vector2(randomX, GameConfig.obstacleSpawnY),
        width: width,
      );

      parent?.add(obstacle);
    }
  }

  /// Pick a random x position that respects the minimum spawn separation
  /// from the last obstacle. Falls back after a few attempts to avoid
  /// infinite loops.
  double _pickSpawnX() {
    final range = GameConfig.playerMaxX - GameConfig.playerMinX;
    const maxAttempts = 10;

    for (var i = 0; i < maxAttempts; i++) {
      final x = GameConfig.playerMinX + _random.nextDouble() * range;

      if (_lastSpawnX == null ||
          (x - _lastSpawnX!).abs() >= GameConfig.obstacleMinSpawnSeparation) {
        return x;
      }
    }

    // Fallback: place on the opposite side of the play field from the last spawn.
    final midX = (GameConfig.playerMinX + GameConfig.playerMaxX) / 2;
    if (_lastSpawnX != null && _lastSpawnX! > midX) {
      return GameConfig.playerMinX + _random.nextDouble() * (range / 3);
    }
    return GameConfig.playerMaxX - _random.nextDouble() * (range / 3);
  }

  /// Reset the spawn timer and last-spawn tracking (call on game start/restart).
  void reset() {
    _elapsed = 0;
    _lastSpawnX = null;
  }
}
