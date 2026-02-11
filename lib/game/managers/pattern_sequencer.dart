import 'dart:math';

import '../config/patterns.dart';
import '../models/obstacle_pattern.dart';

/// Selects obstacle patterns using weighted random selection.
///
/// Maintains a registry of pattern factory functions from [Patterns],
/// each with a weight that influences selection probability. Only patterns
/// whose difficulty level is at or below [_currentDifficulty] are eligible.
///
/// Tracks the last 3 selected pattern ids in [_history] for future
/// anti-repetition logic.
class PatternSequencer {
  final Random _random;

  /// Factory functions that produce an [ObstaclePattern] given a [Random].
  final List<ObstaclePattern Function(Random)> _factories;

  /// Pattern ids corresponding to each factory (same index).
  final List<String> _factoryIds;

  /// Current weight for each pattern id (higher = more likely to be selected).
  final Map<String, double> _weights;

  /// History of the last 3 selected pattern ids.
  final List<String> _history = [];

  /// Current difficulty level (1-5). Only patterns with
  /// difficulty <= this value are eligible for selection.
  int _currentDifficulty = 1;

  PatternSequencer({required Random random}) : _random = random,
      _factories = <ObstaclePattern Function(Random)>[],
      _factoryIds = <String>[],
      _weights = <String, double>{} {
    _register('single', Patterns.single);
    _register('doubleGap', Patterns.doubleGap);
    _register('stagger', Patterns.stagger);
    _register('wave', Patterns.wave);
  }

  /// Register a pattern factory with an initial weight of 1.0.
  void _register(String id, ObstaclePattern Function(Random) factory) {
    _factoryIds.add(id);
    _factories.add(factory);
    _weights[id] = 1.0;
  }

  /// Select the next pattern using weighted random selection.
  ///
  /// Only considers patterns whose generated difficulty is at or below
  /// [_currentDifficulty]. Generates each candidate pattern, filters by
  /// difficulty, then performs standard weighted random selection.
  ObstaclePattern next() {
    // Build list of eligible (index, pattern) pairs.
    final eligible = <_EligiblePattern>[];

    for (var i = 0; i < _factories.length; i++) {
      final pattern = _factories[i](_random);
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
      final fallback = Patterns.single(_random);
      _addToHistory(fallback.id);
      return fallback;
    }

    // Weighted random selection.
    final totalWeight = eligible.fold<double>(0.0, (sum, e) => sum + e.weight);
    var roll = _random.nextDouble() * totalWeight;

    for (final entry in eligible) {
      roll -= entry.weight;
      if (roll <= 0) {
        _addToHistory(entry.pattern.id);
        return entry.pattern;
      }
    }

    // Floating-point edge case: return the last eligible pattern.
    final last = eligible.last;
    _addToHistory(last.pattern.id);
    return last.pattern;
  }

  /// Update the difficulty level (clamped to 1-5).
  void setDifficulty(int level) {
    _currentDifficulty = level.clamp(1, 5);
  }

  /// Current difficulty level.
  int get currentDifficulty => _currentDifficulty;

  /// Clear history and reset difficulty to 1.
  void reset() {
    _history.clear();
    _currentDifficulty = 1;
  }

  /// Add a pattern id to the history, keeping only the last 3.
  void _addToHistory(String id) {
    _history.add(id);
    if (_history.length > 3) {
      _history.removeAt(0);
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
