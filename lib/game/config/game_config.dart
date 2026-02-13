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
  static const Color obstacleOutlineColor = Color(0xFF1A5276);
  static const Color obstacleHighlightColor = Color(0xFF2471A3);
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
  static const double minSurvivableGap = 55.0;

  // Difficulty escalation
  static const List<double> difficultyThresholds = [0, 10, 25, 45, 70];
  static const double maxSpeedMultiplier = 1.6;
  static const double minIntervalMultiplier = 0.55;

  // Pattern variety
  static const int maxConsecutiveSimple = 3;

  // Rhythm system (intense/breather cycles)
  static const int rhythmIntenseMin = 4;
  static const int rhythmIntenseMax = 6;
  static const int rhythmBreatherLength = 2;
  static const double rhythmBreatherIntervalBonus = 1.3;

  // Death particles
  static const int deathParticleCount = 18;
  static const double deathParticleSpeed = 250.0;
  static const double deathParticleLifespan = 0.5;

  // Dodge sparkle particles
  static const int dodgeSparkleCount = 6;
  static const double dodgeSparkleLifespan = 0.25;

  // Death flash overlay
  static const double flashDuration = 0.25;
  static const double flashOpacity = 0.7;

  // Danger tint overlay
  static const Color dangerTintColor = Color(0xFFFF2020);
  static const double dangerTintMaxOpacity = 0.12;

  // Player glow and pulse
  static const double playerGlowRadius = 8.0;
  static const double playerGlowOpacity = 0.3;
  static const double playerPulseFrequency = 1.5;

  // Background grid
  static const double gridSpacing = 50.0;
  static const Color gridColor = Color(0xFF16213E);
  static const double gridOpacity = 0.3;
  static const double gridScrollSpeed = 0.15;

  // Screen shake
  static const double shakeIntensityDeath = 8.0;
  static const double shakeIntensityNearMiss = 3.0;
  static const double shakeDurationDeath = 0.3;
  static const double shakeDurationNearMiss = 0.15;
  static const double nearMissThreshold = 70.0;
}
