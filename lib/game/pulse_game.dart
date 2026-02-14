import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/background_pulse.dart';
import 'components/danger_tint.dart';
import 'components/obstacle.dart';
import 'components/player.dart';
import 'components/tap_indicator.dart';
import 'config/game_config.dart';
import 'effects/death_particles.dart';
import 'effects/flash_overlay.dart';
import 'effects/screen_shake.dart';
import 'managers/difficulty_manager.dart';
import 'managers/obstacle_spawner.dart';
import 'managers/score_manager.dart';
import '../utils/audio_manager.dart';
import '../utils/score_repository.dart';

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
  late ObstacleSpawner obstacleSpawner;
  late DifficultyManager difficultyManager;
  late BackgroundPulse backgroundPulse;
  late ScoreManager scoreManager;
  late final AudioManager audioManager;

  GameState _state = GameState.menu;
  GameState get state => _state;

  double _survivalTime = 0.0;

  /// Time scale multiplier — 1.0 is normal speed, < 1.0 is slow motion.
  double _timeScale = 1.0;

  /// Elapsed survival time in seconds since the current game started.
  double get survivalTime => _survivalTime;

  @override
  Color backgroundColor() => GameConfig.backgroundColor;

  @override
  void update(double dt) {
    final scaledDt = dt * _timeScale;
    super.update(scaledDt);
    if (_state == GameState.playing) {
      _survivalTime += scaledDt;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Position camera so the visible area is (0,0)→(400,800) instead of
    // the default (-200,-400)→(200,400). Without this, everything is off-screen.
    camera.viewfinder.position = Vector2(
      GameConfig.worldWidth / 2,
      GameConfig.worldHeight / 2,
    );

    // Initialise audio system (preloads assets, creates pools).
    audioManager = AudioManager.instance;
    await audioManager.initialize();

    // Initialise score persistence.
    await ScoreRepository.instance.initialize();

    paused = true;
    // Background grid — renders behind everything at priority -10.
    world.add(GameBackground());

    // Background pulse — syncs to spawn rhythm at priority -5.
    backgroundPulse = BackgroundPulse();
    world.add(backgroundPulse);

    world.add(ScreenHitbox());
    world.add(_WorldTapHandler());

    player = Player();
    world.add(player);

    difficultyManager = DifficultyManager();
    world.add(difficultyManager);

    scoreManager = ScoreManager();
    world.add(scoreManager);

    // Persistent danger tint — invisible at difficulty 1, subtle red at max.
    world.add(DangerTint());

    obstacleSpawner = ObstacleSpawner();
    world.add(obstacleSpawner);
  }

  /// Start a new game session.
  void startGame() {
    _state = GameState.playing;
    _survivalTime = 0.0;
    _timeScale = 1.0;
    audioManager.playSfx('restart_chime.wav');
    audioManager.playBgm('ambient_loop.wav');
    player.resetPosition();
    player.playEntranceAnimation();
    clearObstacles();
    difficultyManager.reset();
    scoreManager.reset();
    obstacleSpawner.reset();
    _clearShake();
    overlays.remove('MainMenu');
    overlays.add('HUD');
    paused = false;
  }

  /// Pause the current game.
  void pauseGame() {
    audioManager.playSfx('menu_select.wav', volume: 0.5);
    audioManager.pauseBgm();
    _state = GameState.paused;
    overlays.add('Pause');
    paused = true;
  }

  /// Resume from pause.
  void resumeGame() {
    _state = GameState.playing;
    audioManager.resumeBgm();
    overlays.remove('Pause');
    paused = false;
  }

  /// Handle game over state.
  ///
  /// Triggers slow-motion, screen shake, death particles, flash, and player
  /// death animation. Pauses after the slow-mo window completes.
  void gameOver() {
    _state = GameState.gameOver;
    // Persist high score.
    final currentScore = scoreManager.displayScore;
    ScoreRepository.instance.saveBestScore(currentScore);
    audioManager.playSfx('death_impact.wav');
    audioManager.stopBgm();
    overlays.remove('HUD');
    overlays.add('GameOver');
    // Slow-motion for dramatic death.
    _timeScale = GameConfig.deathSlowMoScale;
    triggerShake(
      GameConfig.shakeIntensityDeath,
      GameConfig.shakeDurationDeath,
    );
    // Spawn death explosion particles at player position.
    world.add(DeathParticles.create(position: player.position));
    // Full-screen white flash for dramatic death punctuation.
    world.add(FlashOverlay());
    // Player shrinks and fades during slow-mo window.
    player.playDeathAnimation();
    // Delay pause so the death effects play out before the game freezes.
    // Extended to deathSlowMoDuration to accommodate slow-mo window.
    Future.delayed(
      Duration(
        milliseconds: (GameConfig.deathSlowMoDuration * 1000).round(),
      ),
      () {
        // Guard: only pause if still in gameOver state (user may have restarted).
        if (_state == GameState.gameOver) {
          paused = true;
        }
      },
    );
  }

  /// Trigger a screen shake on the camera viewfinder.
  ///
  /// Removes any existing [ScreenShake] children first to prevent stacking.
  void triggerShake(double intensity, double duration) {
    camera.viewfinder.children
        .whereType<ScreenShake>()
        .toList()
        .forEach((s) => s.removeFromParent());
    camera.viewfinder.add(
      ScreenShake(intensity: intensity, duration: duration),
    );
  }

  /// Remove any active screen shake and restore the viewfinder base position.
  void _clearShake() {
    camera.viewfinder.children
        .whereType<ScreenShake>()
        .toList()
        .forEach((s) => s.removeFromParent());
    camera.viewfinder.position = Vector2(
      GameConfig.worldWidth / 2,
      GameConfig.worldHeight / 2,
    );
  }

  /// Reset the game to start a new session.
  void resetGame() {
    _state = GameState.playing;
    _survivalTime = 0.0;
    _timeScale = 1.0;
    audioManager.playSfx('restart_chime.wav');
    audioManager.stopBgm();
    audioManager.playBgm('ambient_loop.wav');
    player.resetPosition();
    player.playEntranceAnimation();
    clearObstacles();
    difficultyManager.reset();
    scoreManager.reset();
    obstacleSpawner.reset();
    _clearShake();
    overlays.remove('GameOver');
    overlays.add('HUD');
    paused = false;
  }

  /// Remove all [Obstacle] children from the world.
  void clearObstacles() {
    world.children
        .whereType<Obstacle>()
        .toList()
        .forEach((o) => o.removeFromParent());
  }

  /// Return to the main menu.
  void returnToMenu() {
    audioManager.playSfx('menu_select.wav');
    audioManager.stopBgm();
    _state = GameState.menu;
    clearObstacles();
    player.resetPosition();
    obstacleSpawner.reset();
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
