import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/player.dart';
import 'components/tap_indicator.dart';
import 'config/game_config.dart';

enum GameState { menu, playing, paused, gameOver }

class PulseGame extends FlameGame with HasCollisionDetection {
  PulseGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: GameConfig.worldWidth,
            height: GameConfig.worldHeight,
          ),
        );

  late Player player;

  GameState _state = GameState.menu;
  GameState get state => _state;

  @override
  Color backgroundColor() => GameConfig.backgroundColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paused = true;
    world.add(ScreenHitbox());
    world.add(_WorldTapHandler());

    player = Player();
    world.add(player);
  }

  /// Start a new game session.
  void startGame() {
    _state = GameState.playing;
    player.resetPosition();
    overlays.remove('MainMenu');
    overlays.add('HUD');
    paused = false;
  }

  /// Pause the current game.
  void pauseGame() {
    _state = GameState.paused;
    overlays.add('Pause');
    paused = true;
  }

  /// Resume from pause.
  void resumeGame() {
    _state = GameState.playing;
    overlays.remove('Pause');
    paused = false;
  }

  /// Handle game over state.
  void gameOver() {
    _state = GameState.gameOver;
    overlays.remove('HUD');
    overlays.add('GameOver');
    paused = true;
  }

  /// Reset the game to start a new session.
  void resetGame() {
    _state = GameState.playing;
    player.resetPosition();
    overlays.remove('GameOver');
    overlays.add('HUD');
    paused = false;
  }

  /// Return to the main menu.
  void returnToMenu() {
    _state = GameState.menu;
    overlays.remove('HUD');
    overlays.remove('Pause');
    overlays.remove('GameOver');
    overlays.add('MainMenu');
    paused = true;
  }
}

/// World-level tap handler — receives events in world coordinates.
/// Game-level TapCallbacks gives canvas coordinates which don't match
/// the world coordinate space under CameraComponent.withFixedResolution.
///
/// Tapping the left half of the screen dodges the player left; tapping
/// the right half dodges right. A [TapIndicator] is spawned for visual
/// feedback at the tap location.
class _WorldTapHandler extends Component
    with TapCallbacks, HasGameReference<PulseGame> {
  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    if (game.state == GameState.playing) {
      // Dodge based on which half of the screen was tapped.
      if (event.localPosition.x < GameConfig.worldWidth / 2) {
        game.player.dodgeLeft();
      } else {
        game.player.dodgeRight();
      }

      // Visual feedback at tap location.
      parent?.add(TapIndicator(position: event.localPosition));
    }
  }
}
