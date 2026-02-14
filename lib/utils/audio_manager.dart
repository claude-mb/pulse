import 'package:flame_audio/flame_audio.dart';

/// Central audio manager for the Pulse game.
///
/// Wraps flame_audio to provide a simple API for playing SFX and BGM.
/// Uses [AudioPool] for high-frequency sounds (dodge, spawn) to minimise
/// latency. All other SFX use one-shot [FlameAudio.play].
///
/// Usage:
/// ```dart
/// await AudioManager.instance.initialize();
/// AudioManager.instance.playSfx('dodge_whoosh.wav');
/// ```
class AudioManager {
  /// Singleton instance.
  static final AudioManager instance = AudioManager._();

  AudioManager._();

  bool _initialized = false;

  /// Whether the audio system has been initialised.
  bool get initialized => _initialized;

  // Audio pools for frequently-played SFX (low latency).
  late AudioPool _dodgePool;
  late AudioPool _spawnPool;

  // ---------------------------------------------------------------------------
  // Volume / mute state
  // ---------------------------------------------------------------------------

  /// Master SFX volume (0.0 - 1.0).
  double sfxVolume = 1.0;

  /// Master BGM volume (0.0 - 1.0).
  double bgmVolume = 0.7;

  /// Whether SFX are muted.
  bool sfxMuted = false;

  /// Whether BGM is muted.
  bool bgmMuted = false;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Preloads all audio assets and creates pools.
  ///
  /// Must be called once before any audio playback. Safe to call multiple
  /// times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;

    // Preload all WAV files into the shared audio cache.
    await FlameAudio.audioCache.loadAll([
      'dodge_whoosh.wav',
      'death_impact.wav',
      'near_miss.wav',
      'restart_chime.wav',
      'spawn_cue.wav',
      'menu_select.wav',
      'ambient_loop.wav',
    ]);

    // Create pools for high-frequency SFX.
    _dodgePool = await FlameAudio.createPool(
      'dodge_whoosh.wav',
      maxPlayers: 4,
    );
    _spawnPool = await FlameAudio.createPool(
      'spawn_cue.wav',
      maxPlayers: 4,
    );

    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // SFX
  // ---------------------------------------------------------------------------

  /// Plays a one-shot sound effect.
  ///
  /// Uses the pre-created [AudioPool] for dodge_whoosh and spawn_cue for
  /// lower latency. All other sounds use [FlameAudio.play].
  ///
  /// [volume] is multiplied by [sfxVolume]. If [sfxMuted] is true, this is
  /// a no-op.
  void playSfx(String name, {double volume = 1.0}) {
    if (!_initialized || sfxMuted) return;

    final effectiveVolume = (volume * sfxVolume).clamp(0.0, 1.0);

    if (name == 'dodge_whoosh.wav') {
      _dodgePool.start(volume: effectiveVolume);
      return;
    }
    if (name == 'spawn_cue.wav') {
      _spawnPool.start(volume: effectiveVolume);
      return;
    }

    FlameAudio.play(name, volume: effectiveVolume);
  }

  // ---------------------------------------------------------------------------
  // BGM
  // ---------------------------------------------------------------------------

  /// Starts playing a looping background music track.
  ///
  /// If BGM is already playing, stops it first to avoid overlap.
  /// If [bgmMuted] is true, this is a no-op.
  Future<void> playBgm(String name) async {
    if (!_initialized || bgmMuted) return;
    // Guard: stop any currently playing BGM before starting a new track.
    FlameAudio.bgm.stop();
    await FlameAudio.bgm.play(name, volume: bgmVolume);
  }

  /// Stops the currently playing BGM track.
  void stopBgm() {
    if (!_initialized) return;
    FlameAudio.bgm.stop();
  }

  /// Pauses the BGM without unloading it.
  void pauseBgm() {
    if (!_initialized) return;
    FlameAudio.bgm.pause();
  }

  /// Resumes a previously paused BGM track.
  void resumeBgm() {
    if (!_initialized) return;
    FlameAudio.bgm.resume();
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  /// Releases audio resources.
  ///
  /// After calling this, [initialize] must be called again before playback.
  void dispose() {
    if (!_initialized) return;
    _dodgePool.dispose();
    _spawnPool.dispose();
    FlameAudio.bgm.dispose();
    _initialized = false;
  }
}
