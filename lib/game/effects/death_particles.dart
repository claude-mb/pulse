import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import '../config/game_config.dart';
import '../../utils/progression_repository.dart';

/// Factory for creating death explosion particle effects.
///
/// Spawns [GameConfig.deathParticleCount] small fragments that burst outward
/// from the given position with random velocities, slight downward gravity,
/// and fade out over their lifespan.
///
/// Fragment shapes match the active player shape:
/// - Diamond: tall diamond slivers
/// - Circle: wide rounded-ish triangles
/// - Triangle: sharp triangular shards
/// - Hexagon: wider hex-like triangles
/// - Star: spiky narrow triangles
///
/// Usage:
/// ```dart
/// world.add(DeathParticles.create(position: player.position));
/// ```
class DeathParticles {
  DeathParticles._();

  static final Random _random = Random();

  /// Creates a [ParticleSystemComponent] that renders a burst of
  /// shape-matching fragments from [position].
  static ParticleSystemComponent create({required Vector2 position}) {
    // Read the active shape to determine fragment style.
    final shapeId = ProgressionRepository.instance.selectedShapeId;

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
          // ComputedParticle (custom fragment rendering with fade).
          final particleLifespan =
              GameConfig.deathParticleLifespan * (0.7 + _random.nextDouble() * 0.3);

          // Pre-compute the fragment path for this particle.
          final fragmentSize = 4.0 + _random.nextDouble() * 2.0;
          final fragmentPath = _buildFragment(shapeId, fragmentSize);

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

                canvas.drawPath(fragmentPath, paint);
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds a 3-vertex fragment [Path] matching the angular feel of the
  /// given [shapeId].
  ///
  /// All fragments are roughly [size] units tall/wide, centred on (0, 0).
  static Path _buildFragment(String shapeId, double size) {
    switch (shapeId) {
      case 'circle':
        // Wide, rounded-feeling triangles (wider aspect ratio).
        return Path()
          ..moveTo(0, -size * 0.7)
          ..lineTo(size * 0.8, size * 0.5)
          ..lineTo(-size * 0.8, size * 0.5)
          ..close();
      case 'triangle':
        // Sharp, narrow triangular shards.
        return Path()
          ..moveTo(0, -size)
          ..lineTo(size * 0.4, size * 0.7)
          ..lineTo(-size * 0.4, size * 0.7)
          ..close();
      case 'hexagon':
        // Wider hex-like trapezoidal fragments (as 3-vertex approximation).
        return Path()
          ..moveTo(0, -size * 0.8)
          ..lineTo(size * 0.7, size * 0.4)
          ..lineTo(-size * 0.7, size * 0.4)
          ..close();
      case 'star':
        // Spiky narrow triangles (like star points breaking off).
        return Path()
          ..moveTo(0, -size * 1.2)
          ..lineTo(size * 0.3, size * 0.3)
          ..lineTo(-size * 0.3, size * 0.3)
          ..close();
      case 'diamond':
      default:
        // Tall diamond slivers (original style).
        return Path()
          ..moveTo(0, -size)
          ..lineTo(size * 0.6, 0)
          ..lineTo(0, size)
          ..lineTo(-size * 0.6, 0)
          ..close();
    }
  }
}
