import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// Full-screen color overlay that pulses (brightens and dims) in rhythm with
/// obstacle spawning, creating a living, breathing game world.
///
/// The pulse phase cycles based on the current spawn interval, syncing
/// naturally to gameplay rhythm. Intensity scales with difficulty level,
/// starting subtle and becoming more pronounced as the game intensifies.
///
/// Priority -5 renders above the background grid (-10) but below the danger
/// tint (-1) and all gameplay objects.
class BackgroundPulse extends Component with HasGameReference<PulseGame> {
  BackgroundPulse() : super(priority: -5);

  /// Current position within the pulse cycle (0.0 to 1.0).
  double _pulsePhase = 0.0;

  /// Current kick intensity from spawn events — decays exponentially.
  double _kickIntensity = 0.0;

  /// Pre-built paint for the pulse overlay.
  late final Paint _paint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _paint = Paint()..color = GameConfig.pulseColor;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calculate the current spawn interval the same way ObstacleSpawner does:
    // base interval * difficulty intervalMultiplier (* breather bonus if applicable).
    var currentInterval =
        GameConfig.spawnInterval * game.difficultyManager.intervalMultiplier;

    // Advance pulse phase based on the current interval rhythm.
    if (currentInterval > 0) {
      _pulsePhase += dt / currentInterval;
    }
    if (_pulsePhase >= 1.0) {
      _pulsePhase -= _pulsePhase.floor(); // Reset, preserving fractional part
    }

    // Decay kick intensity exponentially (multiply by 0.85 each frame).
    _kickIntensity *= 0.85;
    // Clamp very small values to zero to avoid floating-point noise.
    if (_kickIntensity < 0.001) {
      _kickIntensity = 0.0;
    }
  }

  @override
  void render(Canvas canvas) {
    // Calculate pulse amplitude based on difficulty level (0-indexed: 0 to 4).
    final level = game.difficultyManager.difficultyLevel; // 1-5
    final levelProgress = ((level - 1) / 4.0).clamp(0.0, 1.0);
    final amplitude = GameConfig.pulseBaseAmplitude +
        (GameConfig.pulseMaxAmplitude - GameConfig.pulseBaseAmplitude) *
            levelProgress;

    // Smooth pulse curve: sin(_pulsePhase * pi)^2 gives a gentle "breathe".
    final sinValue = sin(_pulsePhase * pi);
    final pulseOpacity = amplitude * sinValue * sinValue;

    // Total opacity = pulse + kick.
    final totalOpacity = (pulseOpacity + _kickIntensity).clamp(0.0, 1.0);

    if (totalOpacity > 0.001) {
      _paint.color = GameConfig.pulseColor.withValues(alpha: totalOpacity);
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          GameConfig.worldWidth,
          GameConfig.worldHeight,
        ),
        _paint,
      );
    }
  }

  /// Trigger a sharp brightness kick (called when obstacles spawn).
  ///
  /// Sets [_kickIntensity] to 0.15, which decays rapidly via exponential
  /// decay in [update], creating a visual heartbeat on each spawn.
  void kick() {
    _kickIntensity = 0.15;
  }
}
