import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../config/game_config.dart';

/// Full-screen white flash overlay triggered on death.
///
/// Renders as a white rectangle at [GameConfig.flashOpacity] that rapidly
/// fades out over [GameConfig.flashDuration] seconds, then auto-removes.
/// The flash fires simultaneously with screen shake and death particles
/// for maximum impact.
///
/// Usage:
/// ```dart
/// world.add(FlashOverlay());
/// ```
class FlashOverlay extends RectangleComponent {
  FlashOverlay()
      : super(
          size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight),
          position: Vector2.zero(),
          paint: Paint()..color = const Color(0xFFFFFFFF),
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Start at configured flash opacity and fade to fully transparent.
    opacity = GameConfig.flashOpacity;
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: GameConfig.flashDuration),
      )..onComplete = removeFromParent,
    );
  }
}
