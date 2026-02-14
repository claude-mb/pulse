import 'package:shared_preferences/shared_preferences.dart';

/// Persists high-score data locally using [SharedPreferences].
///
/// Follows the same singleton pattern as [AudioManager].
///
/// Usage:
/// ```dart
/// await ScoreRepository.instance.initialize();
/// ScoreRepository.instance.saveBestScore(42);
/// print(ScoreRepository.instance.bestScore); // 42
/// ```
class ScoreRepository {
  /// Singleton instance.
  static final ScoreRepository instance = ScoreRepository._();

  ScoreRepository._();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _bestScoreKey = 'best_score';

  /// Initialises the repository by loading [SharedPreferences].
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Returns the persisted best score, or 0 if none has been saved.
  int get bestScore {
    if (!_initialized) return 0;
    return _prefs.getInt(_bestScoreKey) ?? 0;
  }

  /// Saves [score] as the new best if it exceeds the current best.
  ///
  /// Returns immediately if [score] is not higher than [bestScore].
  Future<void> saveBestScore(int score) async {
    if (!_initialized) return;
    if (score > bestScore) {
      await _prefs.setInt(_bestScoreKey, score);
    }
  }

  /// Returns `true` if [score] is strictly greater than the current best.
  bool isNewBest(int score) => score > bestScore;
}
