import 'dart:math';

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
}
