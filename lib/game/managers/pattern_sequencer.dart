import 'dart:math';

import '../config/game_config.dart';
import '../config/patterns.dart';
import '../models/obstacle_pattern.dart';

/// Selects obstacle patterns using weighted random selection with
/// anti-repetition, variety enforcement, and rhythm cycling.
///
/// Maintains a registry of pattern factory functions from [Patterns],
/// each with a weight that influences selection probability. Only patterns
/// whose difficulty level is at or below [_currentDifficulty] are eligible.
///
/// **Anti-repetition:** The last selected pattern is never repeated
/// consecutively (weight set to 0). Patterns in the last 3 history
/// entries receive a 0.3x weight penalty.
///
/// **Variety enforcement:** At difficulty 2+, if the last 3 selections
/// were all singles, single patterns are excluded to force variety.
///
/// The [gapScale] property (0.7-1.0) is passed through to pattern factories
/// so gap widths scale with difficulty.
class PatternSequencer {
  final Random _random;

  /// Factory functions that produce an [ObstaclePattern] given a [Random]
  /// and a [gapScale].
  final List<ObstaclePattern Function(Random, [double])> _factories;

  /// Pattern ids corresponding to each factory (same index).
  final List<String> _factoryIds;

  /// Minimum difficulty level required for each factory (same index).
  final List<int> _factoryDifficulties;

  /// Current weight for each pattern id (higher = more likely to be selected).
  final Map<String, double> _weights;

  /// History of the last 3 selected pattern ids.
  final List<String> _history = [];

  /// Number of consecutive 'single' selections in the most recent history.
  int _recentSingleCount = 0;

  // --- Rhythm system state ---

  /// Number of patterns spawned since the last breather ended.
  int _patternsSinceBreather = 0;

  /// Whether the sequencer is currently in a breather phase.
  bool _inBreather = false;

  /// How many breather patterns remain before resuming intense mode.
  int _breatherPatternsRemaining = 0;

  /// The intense-phase threshold — randomised each cycle for unpredictability.
  int _intenseThreshold = 0;

  /// Current difficulty level (1-5). Only patterns with
  /// difficulty <= this value are eligible for selection.
  int _currentDifficulty = 1;

  /// Gap scale factor (0.7-1.0) passed to pattern factories.
  /// Controls how wide survivable gaps are. Set by [ObstacleSpawner]
  /// from [DifficultyManager.gapScale].
  double _gapScale = 1.0;

  PatternSequencer({required Random random})
      : _random = random,
        _factories = <ObstaclePattern Function(Random, [double])>[],
        _factoryIds = <String>[],
        _factoryDifficulties = <int>[],
        _weights = <String, double>{} {
    _register('single', 1, Patterns.single);
    _register('doubleGap', 2, Patterns.doubleGap);
    _register('stagger', 2, Patterns.stagger);
    _register('wave', 3, Patterns.wave);
    _register('wallWithGap', 4, Patterns.wallWithGap);
    _intenseThreshold = _rollIntenseThreshold();
  }

  /// Whether the sequencer is currently in a breather phase.
  ///
  /// During breather, only single patterns are spawned and the
  /// [ObstacleSpawner] applies an interval bonus for extra breathing room.
  bool get isBreather => _inBreather;

  /// Register a pattern factory with its difficulty level and initial weight of 1.0.
  void _register(
      String id, int difficulty, ObstaclePattern Function(Random, [double]) factory) {
    _factoryIds.add(id);
    _factoryDifficulties.add(difficulty);
    _factories.add(factory);
    _weights[id] = 1.0;
  }

  /// Select the next pattern using weighted random selection.
  ///
  /// Only considers patterns whose generated difficulty is at or below
  /// [_currentDifficulty]. Applies anti-repetition penalties and variety
  /// enforcement before performing weighted random selection.
  ///
  /// The current [_gapScale] is passed to each pattern factory.
  ObstaclePattern next() {
    // --- Rhythm system: breather/intense cycling (difficulty 2+) ---
    if (_currentDifficulty >= 2) {
      if (_inBreather) {
        if (_breatherPatternsRemaining > 0) {
          // Still in breather: force a single pattern.
          _breatherPatternsRemaining--;
          final breatherPattern = Patterns.single(_random, _gapScale);
          _addToHistory(breatherPattern.id);
          if (_breatherPatternsRemaining <= 0) {
            // Breather complete — resume intense mode.
            _inBreather = false;
            _patternsSinceBreather = 0;
            _intenseThreshold = _rollIntenseThreshold();
          }
          return breatherPattern;
        }
      } else {
        // Intense mode: check if we've hit the threshold.
        if (_patternsSinceBreather >= _intenseThreshold) {
          // Start a breather phase.
          _inBreather = true;
          _breatherPatternsRemaining = GameConfig.rhythmBreatherLength +
              _random.nextInt(2); // 2-3 patterns
          // Immediately return a breather single.
          _breatherPatternsRemaining--;
          final breatherPattern = Patterns.single(_random, _gapScale);
          _addToHistory(breatherPattern.id);
          if (_breatherPatternsRemaining <= 0) {
            _inBreather = false;
            _patternsSinceBreather = 0;
            _intenseThreshold = _rollIntenseThreshold();
          }
          return breatherPattern;
        }
      }
    }

    // Build list of eligible (index, pattern) pairs with base weights.
    final eligible = <_EligiblePattern>[];

    for (var i = 0; i < _factories.length; i++) {
      // Skip factories above current difficulty — avoids unnecessary
      // pattern generation and potential edge-case errors.
      if (_factoryDifficulties[i] > _currentDifficulty) continue;

      final pattern = _factories[i](_random, _gapScale);
      eligible.add(_EligiblePattern(
        index: i,
        pattern: pattern,
        weight: _weights[_factoryIds[i]] ?? 1.0,
      ));
    }

    // Fallback: if nothing is eligible (shouldn't happen at diff >= 1),
    // just spawn a single.
    if (eligible.isEmpty) {
      final fallback = Patterns.single(_random, _gapScale);
      _addToHistory(fallback.id);
      return fallback;
    }

    // --- Anti-repetition & variety penalties ---
    final lastPatternId = _history.isNotEmpty ? _history.last : null;

    // Apply adjusted weights based on history.
    final adjusted = <_EligiblePattern>[];
    for (final entry in eligible) {
      var w = entry.weight;

      // Rule 1: Never repeat the same pattern consecutively.
      if (entry.pattern.id == lastPatternId) {
        w = 0.0;
      }
      // Rule 2: Penalize patterns that appear in the last 3 history.
      else if (_history.contains(entry.pattern.id)) {
        w *= 0.3;
      }

      // Rule 3: Variety enforcement — at difficulty 2+, if last 3 were
      // all singles, force a non-single by zeroing single weight.
      if (entry.pattern.id == 'single' &&
          _currentDifficulty >= 2 &&
          _recentSingleCount >= GameConfig.maxConsecutiveSimple) {
        w = 0.0;
      }

      adjusted.add(_EligiblePattern(
        index: entry.index,
        pattern: entry.pattern,
        weight: w,
      ));
    }

    // If all weights are 0 (edge case), reset to base weights.
    final totalAdjusted =
        adjusted.fold<double>(0.0, (sum, e) => sum + e.weight);
    final selection = totalAdjusted > 0 ? adjusted : eligible;

    // Weighted random selection.
    final totalWeight =
        selection.fold<double>(0.0, (sum, e) => sum + e.weight);
    var roll = _random.nextDouble() * totalWeight;

    for (final entry in selection) {
      roll -= entry.weight;
      if (roll <= 0) {
        _addToHistory(entry.pattern.id);
        _patternsSinceBreather++;
        return entry.pattern;
      }
    }

    // Floating-point edge case: return the last eligible pattern.
    final last = selection.last;
    _addToHistory(last.pattern.id);
    _patternsSinceBreather++;
    return last.pattern;
  }

  /// Update the difficulty level (clamped to 1-5).
  void setDifficulty(int level) {
    _currentDifficulty = level.clamp(1, 5);
  }

  /// Update the gap scale factor (clamped to 0.7-1.0).
  void setGapScale(double scale) {
    _gapScale = scale.clamp(0.7, 1.0);
  }

  /// Current difficulty level.
  int get currentDifficulty => _currentDifficulty;

  /// Current gap scale.
  double get gapScale => _gapScale;

  /// Clear history, rhythm state, and reset difficulty to 1 and gapScale to 1.0.
  void reset() {
    _history.clear();
    _recentSingleCount = 0;
    _patternsSinceBreather = 0;
    _inBreather = false;
    _breatherPatternsRemaining = 0;
    _intenseThreshold = _rollIntenseThreshold();
    _currentDifficulty = 1;
    _gapScale = 1.0;
  }

  /// Roll a new random intense-phase threshold (4-6 patterns).
  int _rollIntenseThreshold() {
    return GameConfig.rhythmIntenseMin +
        _random.nextInt(
            GameConfig.rhythmIntenseMax - GameConfig.rhythmIntenseMin + 1);
  }

  /// Add a pattern id to the history, keeping only the last 3.
  /// Also updates [_recentSingleCount] for variety enforcement.
  void _addToHistory(String id) {
    _history.add(id);
    if (_history.length > 3) {
      _history.removeAt(0);
    }

    // Update consecutive single count from recent history.
    _recentSingleCount = 0;
    for (var i = _history.length - 1; i >= 0; i--) {
      if (_history[i] == 'single') {
        _recentSingleCount++;
      } else {
        break;
      }
    }
  }
}

/// Internal helper for weighted selection.
class _EligiblePattern {
  final int index;
  final ObstaclePattern pattern;
  final double weight;

  const _EligiblePattern({
    required this.index,
    required this.pattern,
    required this.weight,
  });
}
