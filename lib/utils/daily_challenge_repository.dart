import 'package:shared_preferences/shared_preferences.dart';

/// Persists daily challenge stats (best score, attempts, streak) using
/// [SharedPreferences].
///
/// Follows the same singleton pattern as [ScoreRepository].
///
/// Usage:
/// ```dart
/// await DailyChallengeRepository.instance.initialize();
/// final isNew = await DailyChallengeRepository.instance.recordDailyGame(score: 42);
/// print(DailyChallengeRepository.instance.dailyBestScore); // 42
/// ```
class DailyChallengeRepository {
  /// Singleton instance.
  static final DailyChallengeRepository instance =
      DailyChallengeRepository._();

  DailyChallengeRepository._();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _dailyDateKey = 'daily_date';
  static const String _dailyBestScoreKey = 'daily_best_score';
  static const String _dailyAttemptsKey = 'daily_attempts';
  static const String _dailyStreakKey = 'daily_streak';
  static const String _dailyLastStreakDateKey = 'daily_last_streak_date';

  /// Today's date as YYYY-MM-DD.
  String get _todayString => DateTime.now().toIso8601String().substring(0, 10);

  /// Initialises the repository by loading [SharedPreferences] and checking
  /// for a day rollover.
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    _checkDayRollover();
  }

  /// Compares the stored daily date to today. If different, resets daily stats
  /// (best score, attempts) but leaves the streak untouched — streak is updated
  /// on the first play of the new day.
  void _checkDayRollover() {
    final storedDate = _prefs.getString(_dailyDateKey);
    final today = _todayString;
    if (storedDate != today) {
      _prefs.setString(_dailyDateKey, today);
      _prefs.setInt(_dailyBestScoreKey, 0);
      _prefs.setInt(_dailyAttemptsKey, 0);
    }
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  /// Best score for today's daily challenge, or 0 if not yet played.
  int get dailyBestScore {
    if (!_initialized) return 0;
    return _prefs.getInt(_dailyBestScoreKey) ?? 0;
  }

  /// Number of daily challenge attempts today.
  int get dailyAttempts {
    if (!_initialized) return 0;
    return _prefs.getInt(_dailyAttemptsKey) ?? 0;
  }

  /// Current consecutive-day streak.
  int get streak {
    if (!_initialized) return 0;
    return _prefs.getInt(_dailyStreakKey) ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  /// Records the result of a daily challenge game.
  ///
  /// Increments [dailyAttempts], updates [dailyBestScore] if [score] is higher,
  /// and calls [_updateStreak] on the first attempt of the day.
  ///
  /// Returns `true` if [score] is a new daily best.
  Future<bool> recordDailyGame({required int score}) async {
    if (!_initialized) return false;

    final oldAttempts = dailyAttempts;
    final wasNewBest = score > dailyBestScore;

    // Increment attempts.
    _prefs.setInt(_dailyAttemptsKey, oldAttempts + 1);

    // Update best score if this run was better.
    if (wasNewBest) {
      _prefs.setInt(_dailyBestScoreKey, score);
    }

    // Update streak on the first attempt of the day.
    if (oldAttempts == 0) {
      _updateStreak();
    }

    return wasNewBest;
  }

  /// Updates the consecutive-day streak.
  ///
  /// - If last streak date was yesterday: increment streak (consecutive day).
  /// - If last streak date is not today: reset streak to 1 (new streak).
  /// - If last streak date is already today: no-op (already counted).
  void _updateStreak() {
    final today = _todayString;
    final lastStreakDate = _prefs.getString(_dailyLastStreakDateKey);
    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);

    if (lastStreakDate == yesterday) {
      // Consecutive day — extend streak.
      _prefs.setInt(_dailyStreakKey, streak + 1);
    } else if (lastStreakDate != today) {
      // New streak or first ever play.
      _prefs.setInt(_dailyStreakKey, 1);
    }
    // If lastStreakDate == today, streak is already counted — skip.

    _prefs.setString(_dailyLastStreakDateKey, today);
  }
}
