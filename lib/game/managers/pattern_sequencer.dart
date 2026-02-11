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

  /// Current weight for each pattern id (higher = more likely to be selected).
  final Map<String, double> _weights;

  /// History of the last 3 selected pattern ids.
  final List<String> _history = [];

  /// Number of consecutive 'single' selections in the most recent history.
  int _recentSingleCount = 0;

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
        _weights = <String, double>{} {
    _register('single', Patterns.single);
    _register('doubleGap', Patterns.doubleGap);
    _register('stagger', Patterns.stagger);
    _register('wave', Patterns.wave);
    _register('wallWithGap', Patterns.wallWithGap);
  }

  /// Register a pattern factory with an initial weight of 1.0.
  void _register(
      String id, ObstaclePattern Function(Random, [double]) factory) {
    _factoryIds.add(id);
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
    // Build list of eligible (index, pattern) pairs with base weights.
    final eligible = <_EligiblePattern>[];

    for (var i = 0; i < _factories.length; i++) {
      final pattern = _factories[i](_random, _gapScale);
      if (pattern.difficulty <= _currentDifficulty) {
        eligible.add(_EligiblePattern(
          index: i,
          pattern: pattern,
          weight: _weights[_factoryIds[i]] ?? 1.0,
        ));
      }
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
        return entry.pattern;
      }
    }

    // Floating-point edge case: return the last eligible pattern.
    final last = selection.last;
    _addToHistory(last.pattern.id);
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

  /// Clear history and reset difficulty to 1 and gapScale to 1.0.
  void reset() {
    _history.clear();
    _recentSingleCount = 0;
    _currentDifficulty = 1;
    _gapScale = 1.0;
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
