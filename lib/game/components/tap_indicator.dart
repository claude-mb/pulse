import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../config/game_config.dart';

/// A visual indicator that appears at tap positions.
///
/// Renders a small circle that fades out and then removes itself from the game.
class TapIndicator extends CircleComponent {
  TapIndicator({required Vector2 position})
      : super(
          position: position,
          radius: GameConfig.tapIndicatorRadius,
          anchor: Anchor.center,
          paint: Paint()..color = GameConfig.textColor,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: GameConfig.tapIndicatorDuration),
        onComplete: removeFromParent,
      ),
    );
  }
}
