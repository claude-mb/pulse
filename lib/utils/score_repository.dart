import 'package:shared_preferences/shared_preferences.dart';

/// Persists high-score and lifetime stats locally using [SharedPreferences].
///
/// Follows the same singleton pattern as [AudioManager].
///
/// Usage:
/// ```dart
/// await ScoreRepository.instance.initialize();
/// final isNew = await ScoreRepository.instance.recordGameEnd(
///   score: 42, bestCombo: 5, totalDodges: 10, survivalTime: 30.0,
/// );
/// print(ScoreRepository.instance.bestScore); // 42
/// ```
class ScoreRepository {
  /// Singleton instance.
  static final ScoreRepository instance = ScoreRepository._();

  ScoreRepository._();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _bestScoreKey = 'best_score';
  static const String _gamesPlayedKey = 'games_played';
  static const String _bestComboKey = 'best_combo';
  static const String _totalDodgesKey = 'total_dodges';
  static const String _bestSurvivalTimeKey = 'best_survival_time';

  /// Initialises the repository by loading [SharedPreferences].
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  /// Returns the persisted best score, or 0 if none has been saved.
  int get bestScore {
    if (!_initialized) return 0;
    return _prefs.getInt(_bestScoreKey) ?? 0;
  }

  /// Total number of games completed.
  int get gamesPlayed {
    if (!_initialized) return 0;
    return _prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  /// Highest combo streak achieved across all games.
  int get allTimeBestCombo {
    if (!_initialized) return 0;
    return _prefs.getInt(_bestComboKey) ?? 0;
  }

  /// Running total of dodges across all games.
  int get allTimeTotalDodges {
    if (!_initialized) return 0;
    return _prefs.getInt(_totalDodgesKey) ?? 0;
  }

  /// Longest survival time across all games (seconds).
  double get bestSurvivalTime {
    if (!_initialized) return 0.0;
    return _prefs.getDouble(_bestSurvivalTimeKey) ?? 0.0;
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  /// Records the end of a game session, updating all lifetime stats.
  ///
  /// Returns `true` if [score] is a new personal best.
  Future<bool> recordGameEnd({
    required int score,
    required int bestCombo,
    required int totalDodges,
    required double survivalTime,
  }) async {
    if (!_initialized) return false;

    final wasNewBest = score > bestScore;

    // Increment games played.
    await _prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);

    // Update best score if this run was better.
    if (wasNewBest) {
      await _prefs.setInt(_bestScoreKey, score);
    }

    // Update all-time best combo if this run's combo was higher.
    if (bestCombo > allTimeBestCombo) {
      await _prefs.setInt(_bestComboKey, bestCombo);
    }

    // Accumulate total dodges (running sum).
    await _prefs.setInt(_totalDodgesKey, allTimeTotalDodges + totalDodges);

    // Update best survival time if this run lasted longer.
    if (survivalTime > bestSurvivalTime) {
      await _prefs.setDouble(_bestSurvivalTimeKey, survivalTime);
    }

    return wasNewBest;
  }

  /// Returns `true` if [score] is strictly greater than the current best.
  bool isNewBest(int score) => score > bestScore;
}
