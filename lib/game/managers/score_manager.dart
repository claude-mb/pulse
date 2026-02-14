import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../pulse_game.dart';

/// Tracks score, combo streaks, dodge counts, and near-miss bonuses.
///
/// Accumulates passive time-based score each frame and awards bonus points
/// for dodges and near-misses, scaled by the current combo multiplier.
/// The combo multiplier increases with consecutive dodges/near-misses
/// and is capped at [GameConfig.maxComboMultiplier].
class ScoreManager extends Component with HasGameReference<PulseGame> {
  /// Raw score accumulator (includes fractional time-based score).
  double _score = 0.0;

  /// Current combo streak (incremented by dodges and near-misses).
  int _combo = 0;

  /// Total number of successful dodges this session.
  int _totalDodges = 0;

  /// Total number of near-misses this session.
  int _totalNearMisses = 0;

  /// Highest combo achieved this session.
  int _bestCombo = 0;

  /// Text describing the last score event (e.g. "DODGE +25").
  String? _lastScoreEvent;

  /// Countdown timer for clearing [_lastScoreEvent].
  double _lastScoreEventTimer = 0.0;

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  /// Current display score (rounded down to nearest integer).
  int get displayScore => _score.floor();

  /// Raw score value.
  double get score => _score;

  /// Current combo streak count.
  int get combo => _combo;

  /// Total dodges this session.
  int get totalDodges => _totalDodges;

  /// Total near-misses this session.
  int get totalNearMisses => _totalNearMisses;

  /// Best combo achieved this session.
  int get bestCombo => _bestCombo;

  /// The last score event text (for HUD display), or null if expired.
  String? get lastScoreEvent => _lastScoreEvent;

  /// Combo multiplier: 1.0 + (combo × step), capped at max.
  double get comboMultiplier =>
      (1.0 + _combo * GameConfig.comboMultiplierStep)
          .clamp(1.0, GameConfig.maxComboMultiplier);

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    // Passive time-based score.
    _score += GameConfig.scorePerSecond * dt;

    // Clear score event text after display duration.
    if (_lastScoreEvent != null) {
      _lastScoreEventTimer -= dt;
      if (_lastScoreEventTimer <= 0) {
        _lastScoreEvent = null;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Score events
  // ---------------------------------------------------------------------------

  /// Award points for a successful dodge.
  void addDodge() {
    _totalDodges++;
    _combo++;
    if (_combo > _bestCombo) {
      _bestCombo = _combo;
    }
    final bonus = (GameConfig.dodgeBonus * comboMultiplier).round();
    _score += bonus;
    _lastScoreEvent = 'DODGE +$bonus';
    _lastScoreEventTimer = GameConfig.scoreEventDisplayDuration;
  }

  /// Award points for a near-miss.
  void addNearMiss() {
    _totalNearMisses++;
    _combo++;
    if (_combo > _bestCombo) {
      _bestCombo = _combo;
    }
    final bonus = (GameConfig.nearMissBonus * comboMultiplier).round();
    _score += bonus;
    _lastScoreEvent = 'NEAR MISS +$bonus';
    _lastScoreEventTimer = GameConfig.scoreEventDisplayDuration;
  }

  /// Reset combo streak (e.g. on hit or game over).
  void resetCombo() {
    _combo = 0;
  }

  /// Reset all scoring state for a new game session.
  void reset() {
    _score = 0.0;
    _combo = 0;
    _totalDodges = 0;
    _totalNearMisses = 0;
    _bestCombo = 0;
    _lastScoreEvent = null;
    _lastScoreEventTimer = 0.0;
  }
}
