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
/// Only spawns when [PulseGame.state] is [GameState.playing].
class ObstacleSpawner extends Component with HasGameReference<PulseGame> {
  final Random _random = Random();
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    _elapsed += dt;

    while (_elapsed >= GameConfig.spawnInterval) {
      _elapsed -= GameConfig.spawnInterval;

      final randomX = GameConfig.playerMinX +
          _random.nextDouble() * (GameConfig.playerMaxX - GameConfig.playerMinX);

      final obstacle = Obstacle(
        position: Vector2(randomX, GameConfig.obstacleSpawnY),
      );

      parent?.add(obstacle);
    }
  }

  /// Reset the spawn timer (call on game start/restart).
  void reset() {
    _elapsed = 0;
  }
}
