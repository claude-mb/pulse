import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import '../config/game_config.dart';

/// Direction of the dodge — sparkles drift in the opposite direction.
enum DodgeDirection { left, right }

/// Factory for creating subtle dodge sparkle particle effects.
///
/// Spawns [GameConfig.dodgeSparkleCount] tiny bright circles that drift
/// in the direction opposite to the dodge, creating a quick sparkle accent.
///
/// Usage:
/// ```dart
/// world.add(DodgeSparkle.create(
///   position: player.position,
///   direction: DodgeDirection.left,
/// ));
/// ```
class DodgeSparkle {
  DodgeSparkle._();

  static final Random _random = Random();

  /// Creates a [ParticleSystemComponent] that renders a small sparkle burst
  /// at [position], drifting opposite to [direction].
  static ParticleSystemComponent create({
    required Vector2 position,
    required DodgeDirection direction,
  }) {
    // Sparkles drift opposite to dodge direction.
    final driftX = direction == DodgeDirection.left ? 1.0 : -1.0;

    return ParticleSystemComponent(
      position: position.clone(),
      particle: Particle.generate(
        count: GameConfig.dodgeSparkleCount,
        lifespan: GameConfig.dodgeSparkleLifespan,
        generator: (i) {
          // Base horizontal velocity in the opposite direction + random spread.
          final vx = driftX * (80 + _random.nextDouble() * 60) +
              (_random.nextDouble() * 40 - 20);
          // Slight upward bias with random vertical spread.
          final vy = -30 + _random.nextDouble() * 60 - 30;
          final velocity = Vector2(vx, vy);

          final particleLifespan =
              GameConfig.dodgeSparkleLifespan *
              (0.6 + _random.nextDouble() * 0.4);

          return AcceleratedParticle(
            speed: velocity,
            acceleration: Vector2.zero(),
            lifespan: particleLifespan,
            child: ComputedParticle(
              lifespan: particleLifespan,
              renderer: (canvas, particle) {
                // Fade out over lifespan.
                final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
                final paint = Paint()
                  ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity);
                // Small bright circle — subtle sparkle.
                final radius = 1.5 + _random.nextDouble() * 1.5;
                canvas.drawCircle(Offset.zero, radius, paint);
              },
            ),
          );
        },
      ),
    );
  }
}
