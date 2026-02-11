import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// A visual indicator that appears at tap positions.
///
/// Renders a small white circle that fades out over 0.3 seconds
/// and then removes itself from the game.
class TapIndicator extends CircleComponent {
  TapIndicator({required Vector2 position})
      : super(
          position: position,
          radius: 15,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFFFFF),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.3),
        onComplete: removeFromParent,
      ),
    );
  }
}
