import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // SharedPreferences keys for persisted mute state.
  static const String _sfxMutedKey = 'audio_sfx_muted';
  static const String _bgmMutedKey = 'audio_bgm_muted';

  AudioManager._();

  bool _initialized = false;

  /// Whether the audio system has been initialised.
  bool get initialized => _initialized;

  // Audio pools for frequently-played SFX (low latency).
  late AudioPool _dodgePool;
  late AudioPool _spawnPool;
  late AudioPool _pulseBassPool;

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

  /// The last-requested BGM track name, so unmuting can resume it.
  String? _lastRequestedBgm;

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
      'pulse_bass.wav',
      'ambient_loop.wav',
      'high_score_fanfare.wav',
      'unlock_chime.wav',
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
    _pulseBassPool = await FlameAudio.createPool(
      'pulse_bass.wav',
      maxPlayers: 4,
    );

    _initialized = true;

    // Restore persisted mute states.
    final prefs = await SharedPreferences.getInstance();
    sfxMuted = prefs.getBool(_sfxMutedKey) ?? false;
    bgmMuted = prefs.getBool(_bgmMutedKey) ?? false;
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
    if (name == 'pulse_bass.wav') {
      _pulseBassPool.start(volume: effectiveVolume);
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
  /// If [bgmMuted] is true, the request is stored so unmuting can start it.
  Future<void> playBgm(String name) async {
    if (!_initialized) return;
    // Always track the requested BGM so unmuting can resume it.
    _lastRequestedBgm = name;
    if (bgmMuted) return;
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
  // Toggle / volume controls
  // ---------------------------------------------------------------------------

  /// Toggles SFX mute state. Next [playSfx] call will respect the new state.
  ///
  /// Persists the new state to SharedPreferences (fire-and-forget).
  void toggleSfxMute() {
    sfxMuted = !sfxMuted;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_sfxMutedKey, sfxMuted);
    });
  }

  /// Toggles BGM mute state.
  ///
  /// When muting, pauses the active BGM. When unmuting, resumes the
  /// last-requested BGM track if one was stored.
  /// Persists the new state to SharedPreferences (fire-and-forget).
  void toggleBgmMute() {
    bgmMuted = !bgmMuted;
    if (!_initialized) return;
    if (bgmMuted) {
      FlameAudio.bgm.pause();
    } else if (_lastRequestedBgm != null) {
      playBgm(_lastRequestedBgm!);
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_bgmMutedKey, bgmMuted);
    });
  }

  /// Sets the SFX master volume, clamped to 0.0 - 1.0.
  void setSfxVolume(double v) {
    sfxVolume = v.clamp(0.0, 1.0);
  }

  /// Sets the BGM master volume, clamped to 0.0 - 1.0.
  ///
  /// If BGM is currently playing, updates the active player's volume
  /// immediately.
  void setBgmVolume(double v) {
    bgmVolume = v.clamp(0.0, 1.0);
    if (!_initialized) return;
    // Update the live BGM player volume if playing.
    FlameAudio.bgm.audioPlayer.setVolume(bgmVolume);
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
    _pulseBassPool.dispose();
    FlameAudio.bgm.dispose();
    _initialized = false;
  }
}
