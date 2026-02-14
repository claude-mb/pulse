import 'dart:ui';

import '../models/color_theme.dart';

class GameConfig {
  // Prevent instantiation
  GameConfig._();

  // Game world dimensions (virtual resolution)
  static const double worldWidth = 400;
  static const double worldHeight = 800;

  // Active color theme — drives all themed color getters below.
  static ColorTheme activeTheme = ColorThemes.neonRed;

  // Themed colors — delegate to activeTheme so all existing references
  // (GameConfig.playerColor etc.) continue to work transparently.
  static Color get backgroundColor => activeTheme.backgroundColor;
  static Color get playerColor => activeTheme.playerColor;
  static Color get obstacleColor => activeTheme.obstacleColor;
  static Color get obstacleOutlineColor => activeTheme.obstacleOutlineColor;
  static Color get obstacleHighlightColor => activeTheme.obstacleHighlightColor;
  static Color get accentColor => activeTheme.accentColor;
  static Color get gridColor => activeTheme.gridColor;
  static Color get pulseColor => activeTheme.pulseColor;

  // Non-themed colors — fixed across all themes.
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color dangerTintColor = Color(0xFFFF2020);
  static const Color highScoreColor = Color(0xFFFFD700);
  static const Color xpDisplayColor = Color(0xFF4ECDC4);

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
  static const double dangerTintMaxOpacity = 0.12;

  // Player glow and pulse
  static const double playerGlowRadius = 8.0;
  static const double playerGlowOpacity = 0.3;
  static const double playerPulseFrequency = 1.5;

  // Background grid
  static const double gridSpacing = 50.0;
  static const double gridOpacity = 0.5;
  static const double gridScrollSpeed = 0.15;

  // Death animation
  static const double deathSlowMoScale = 0.3;
  static const double deathSlowMoDuration = 0.5;
  static const double playerDeathAnimDuration = 0.4;

  // Entrance animation
  static const double entranceAnimDuration = 0.3;
  static const double entranceInvulnerabilityDuration = 0.5;

  // Background pulse
  static const double pulseBaseAmplitude = 0.03;
  static const double pulseMaxAmplitude = 0.08;

  // Screen shake
  static const double shakeIntensityDeath = 8.0;
  static const double shakeIntensityNearMiss = 3.0;
  static const double shakeDurationDeath = 0.3;
  static const double shakeDurationNearMiss = 0.15;
  static const double nearMissThreshold = 70.0;

  // Audio
  static const double defaultSfxVolume = 1.0;
  static const double defaultBgmVolume = 0.7;

  // Scoring
  static const double scorePerSecond = 10.0;
  static const int dodgeBonus = 25;
  static const int nearMissBonus = 50;
  static const double maxComboMultiplier = 3.0;
  static const double comboMultiplierStep = 0.1;
  static const double scoreEventDisplayDuration = 0.8;

  // High score celebration
  static const double highScoreFanfareVolume = 0.8;

  // Audio – difficulty-reactive volume scaling
  static const double spawnCueBaseVolume = 0.3;
  static const double spawnCueMaxVolume = 0.6;
  static const double nearMissBaseVolume = 0.5;
  static const double nearMissMaxVolume = 1.0;
  static const double pulseBassBaseVolume = 0.2;
  static const double pulseBassMaxVolume = 0.4;

  // Progression / XP
  static const int xpPerScore = 1;

  // Unlock celebration
  static const double unlockChimeVolume = 0.7;
}
