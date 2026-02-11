import 'dart:math';

import '../config/game_config.dart';

/// Immutable placement data for a single obstacle within a pattern.
///
/// [normalizedX] maps to the player movement area:
///   0.0 = playerMinX (40), 1.0 = playerMaxX (360).
/// [yOffset] shifts the obstacle vertically from the spawn line.
///   Negative values mean further above, so the obstacle arrives later.
/// [widthOverride] optionally overrides the default obstacle width.
class ObstaclePlacement {
  final double normalizedX;
  final double yOffset;
  final double? widthOverride;

  const ObstaclePlacement({
    required this.normalizedX,
    this.yOffset = 0.0,
    this.widthOverride,
  });
}

/// Defines a pattern of obstacles that spawn together.
///
/// Each pattern has an [id] for identification, a [difficulty] level (1-5)
/// that determines when it can appear, a list of [placements] specifying
/// obstacle positions, and an optional [postDelay] (extra seconds before
/// the next spawn after this pattern).
///
/// Use the [generate] factory to create patterns with randomized elements.
class ObstaclePattern {
  final String id;
  final int difficulty;
  final List<ObstaclePlacement> placements;
  final double postDelay;

  const ObstaclePattern({
    required this.id,
    required this.difficulty,
    required this.placements,
    this.postDelay = 0.0,
  });

  /// Factory that accepts a generator function, allowing patterns with
  /// randomized gap positions, widths, or placement variations.
  ///
  /// The [generator] receives a [Random] instance and returns a concrete
  /// [ObstaclePattern].
  static ObstaclePattern generate(
    Random random,
    ObstaclePattern Function(Random random) generator,
  ) {
    return generator(random);
  }

  /// Validates that all rows in [placements] have at least one gap
  /// of width >= [minGap] pixels that the player can pass through.
  ///
  /// Groups placements by similar yOffset (within [rowTolerance] pixels).
  /// For each row, converts normalized positions and widths to pixel
  /// coordinates and checks for gaps between obstacles and at edges.
  ///
  /// Returns true if every row has at least one survivable gap.
  static bool validateGap(
    List<ObstaclePlacement> placements,
    double minGap,
    double playAreaWidth,
  ) {
    if (placements.isEmpty) return true;

    const double rowTolerance = 20.0;

    // Group placements by similar yOffset into rows.
    final rows = <double, List<ObstaclePlacement>>{};
    for (final p in placements) {
      // Find an existing row key within tolerance.
      double? matchingKey;
      for (final key in rows.keys) {
        if ((p.yOffset - key).abs() <= rowTolerance) {
          matchingKey = key;
          break;
        }
      }
      if (matchingKey != null) {
        rows[matchingKey]!.add(p);
      } else {
        rows[p.yOffset] = [p];
      }
    }

    final leftEdge = GameConfig.playerMinX;
    final rightEdge = GameConfig.playerMaxX;

    // Check each row for a survivable gap.
    for (final row in rows.values) {
      // Convert to pixel positions: each obstacle occupies
      // [centerX - halfWidth, centerX + halfWidth].
      final segments = <_Segment>[];
      for (final p in row) {
        final centerX = leftEdge + p.normalizedX * playAreaWidth;
        final halfW = (p.widthOverride ?? GameConfig.obstacleWidth) / 2;
        segments.add(_Segment(centerX - halfW, centerX + halfW));
      }

      // Sort segments by left edge.
      segments.sort((a, b) => a.left.compareTo(b.left));

      // Check gap before first obstacle (left edge of play area).
      bool hasGap = false;
      double cursor = leftEdge;

      for (final seg in segments) {
        final gap = seg.left - cursor;
        if (gap >= minGap) {
          hasGap = true;
          break;
        }
        // Advance cursor past this obstacle (handle overlaps).
        if (seg.right > cursor) {
          cursor = seg.right;
        }
      }

      // Check gap after last obstacle (right edge of play area).
      if (!hasGap) {
        final trailingGap = rightEdge - cursor;
        if (trailingGap >= minGap) {
          hasGap = true;
        }
      }

      if (!hasGap) return false;
    }

    return true;
  }
}

/// Internal helper for gap validation — represents a horizontal segment.
class _Segment {
  final double left;
  final double right;

  const _Segment(this.left, this.right);
}
