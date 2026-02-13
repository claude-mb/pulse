import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import '../config/game_config.dart';

/// Factory for creating death explosion particle effects.
///
/// Spawns [GameConfig.deathParticleCount] small diamond-shaped fragments
/// that burst outward from the given position with random velocities,
/// slight downward gravity, and fade out over their lifespan.
///
/// Usage:
/// ```dart
/// world.add(DeathParticles.create(position: player.position));
/// ```
class DeathParticles {
  DeathParticles._();

  static final Random _random = Random();

  /// Creates a [ParticleSystemComponent] that renders a burst of diamond
  /// fragments from [position].
  static ParticleSystemComponent create({required Vector2 position}) {
    return ParticleSystemComponent(
      position: position.clone(),
      particle: Particle.generate(
        count: GameConfig.deathParticleCount,
        lifespan: GameConfig.deathParticleLifespan,
        generator: (i) {
          // Random angle in full 360 degrees.
          final angle = _random.nextDouble() * 2 * pi;
          // Random speed between 60% and 100% of configured max.
          final speed =
              GameConfig.deathParticleSpeed * (0.6 + _random.nextDouble() * 0.4);
          final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);

          // Each particle: AcceleratedParticle (physics) wrapping a
          // ComputedParticle (custom diamond rendering with fade).
          final particleLifespan =
              GameConfig.deathParticleLifespan * (0.7 + _random.nextDouble() * 0.3);

          return AcceleratedParticle(
            speed: velocity,
            acceleration: Vector2(0, 200), // slight gravity pull
            lifespan: particleLifespan,
            child: ComputedParticle(
              lifespan: particleLifespan,
              renderer: (canvas, particle) {
                // Fade out: opacity goes from 1.0 to 0.0 over lifespan.
                final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
                final paint = Paint()
                  ..color = GameConfig.playerColor.withValues(alpha: opacity);

                // Draw a small diamond fragment.
                final size = 4.0 + _random.nextDouble() * 2.0;
                final path = Path()
                  ..moveTo(0, -size)
                  ..lineTo(size * 0.6, 0)
                  ..lineTo(0, size)
                  ..lineTo(-size * 0.6, 0)
                  ..close();
                canvas.drawPath(path, paint);
              },
            ),
          );
        },
      ),
    );
  }
}
