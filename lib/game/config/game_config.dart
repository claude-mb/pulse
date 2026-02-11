import 'dart:ui';

class GameConfig {
  // Prevent instantiation
  GameConfig._();

  // Game world dimensions (virtual resolution)
  static const double worldWidth = 400;
  static const double worldHeight = 800;

  // Colors
  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color playerColor = Color(0xFFE94560);
  static const Color obstacleColor = Color(0xFF0F3460);
  static const Color accentColor = Color(0xFF16213E);
  static const Color textColor = Color(0xFFFFFFFF);

  // Tap indicator
  static const double tapIndicatorRadius = 15.0;
  static const double tapIndicatorDuration = 0.3;

  // Player
  static const double playerSize = 40.0;
  static const double playerSpeed = 300.0;
  static const double playerStartY = 720.0;
  static const double playerDodgeDistance = 120.0;
  static const double playerMinX = 40.0;
  static const double playerMaxX = 360.0;

  // Obstacles (tuned in Plan 02-05 for satisfying feel)
  static const double obstacleSpeed = 280.0;
  static const double spawnInterval = 1.1;
  static const double obstacleWidth = 60.0;
  static const double obstacleMinWidth = 50.0;
  static const double obstacleMaxWidth = 80.0;
  static const double obstacleHeight = 20.0;
  static const double obstacleSpawnY = -30.0;
  static const double obstacleMinSpawnSeparation = 80.0;

  // Pattern constraints
  static const double minGapWidth = 80.0;

  // Difficulty escalation
  static const List<double> difficultyThresholds = [0, 10, 25, 45, 70];
  static const double maxSpeedMultiplier = 1.6;
  static const double minIntervalMultiplier = 0.55;
}
