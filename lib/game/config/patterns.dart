import 'dart:math';

import '../config/game_config.dart';
import '../models/obstacle_pattern.dart';

/// Predefined obstacle patterns for the Pulse game.
///
/// Each factory method takes a [Random] instance and returns an
/// [ObstaclePattern] with randomized placement variations.
/// Difficulty levels determine when patterns become available.
class Patterns {
  // Prevent instantiation.
  Patterns._();

  /// Play area width in pixels (playerMaxX - playerMinX).
  static const double _playWidth =
      GameConfig.playerMaxX - GameConfig.playerMinX;

  /// Convert a pixel x position (within play area) to normalizedX (0.0-1.0).
  static double _toNormalized(double pixelX) {
    return ((pixelX - GameConfig.playerMinX) / _playWidth).clamp(0.0, 1.0);
  }

  /// Random width between obstacleMinWidth and obstacleMaxWidth.
  static double _randomWidth(Random random) {
    return GameConfig.obstacleMinWidth +
        random.nextDouble() *
            (GameConfig.obstacleMaxWidth - GameConfig.obstacleMinWidth);
  }

  /// Random pixel x position within play area bounds.
  static double _randomPixelX(Random random) {
    return GameConfig.playerMinX + random.nextDouble() * _playWidth;
  }

  // ---------------------------------------------------------------------------
  // Pattern factories
  // ---------------------------------------------------------------------------

  /// **single** (difficulty 1) -- One obstacle at a random x position.
  ///
  /// Width varies between 50-80px. No postDelay.
  static ObstaclePattern single(Random random) {
    final x = _randomPixelX(random);
    final width = _randomWidth(random);

    return ObstaclePattern(
      id: 'single',
      difficulty: 1,
      placements: [
        ObstaclePlacement(
          normalizedX: _toNormalized(x),
          widthOverride: width,
        ),
      ],
    );
  }

  /// **doubleGap** (difficulty 2) -- Two obstacles creating a survivable gap.
  ///
  /// A random gap center is chosen within the play area. The gap is at least
  /// [GameConfig.minGapWidth] pixels wide. Obstacles fill the space on either
  /// side of the gap with widths between 70-100px. postDelay 0.2s.
  static ObstaclePattern doubleGap(Random random) {
    const minGap = GameConfig.minGapWidth; // 80px
    const minObstacleW = 70.0;
    const maxObstacleW = 100.0;

    // Gap center must leave room for obstacles on both sides.
    final gapHalf = minGap / 2;
    final minCenter = GameConfig.playerMinX + minObstacleW / 2 + gapHalf;
    final maxCenter = GameConfig.playerMaxX - minObstacleW / 2 - gapHalf;
    final gapCenter =
        minCenter + random.nextDouble() * (maxCenter - minCenter);

    // Left obstacle: centered between playerMinX and gap left edge.
    final gapLeft = gapCenter - gapHalf;
    final leftWidth =
        (minObstacleW + random.nextDouble() * (maxObstacleW - minObstacleW))
            .clamp(minObstacleW, gapLeft - GameConfig.playerMinX);
    final leftX = (GameConfig.playerMinX + gapLeft) / 2;

    // Right obstacle: centered between gap right edge and playerMaxX.
    final gapRight = gapCenter + gapHalf;
    final rightWidth =
        (minObstacleW + random.nextDouble() * (maxObstacleW - minObstacleW))
            .clamp(minObstacleW, GameConfig.playerMaxX - gapRight);
    final rightX = (gapRight + GameConfig.playerMaxX) / 2;

    return ObstaclePattern(
      id: 'doubleGap',
      difficulty: 2,
      placements: [
        ObstaclePlacement(
          normalizedX: _toNormalized(leftX),
          widthOverride: leftWidth,
        ),
        ObstaclePlacement(
          normalizedX: _toNormalized(rightX),
          widthOverride: rightWidth,
        ),
      ],
      postDelay: 0.2,
    );
  }

  /// **stagger** (difficulty 2) -- Two obstacles at different x with y-offset.
  ///
  /// First obstacle at a random x. Second offset >= 120px horizontally with
  /// yOffset -140 (~0.5s later at speed 280). postDelay 0.3s.
  static ObstaclePattern stagger(Random random) {
    final firstX = _randomPixelX(random);
    final firstWidth = _randomWidth(random);

    // Second obstacle at least 120px away horizontally.
    const minSeparation = 120.0;
    double secondX;

    // Determine direction: prefer the side with more room.
    final spaceRight = GameConfig.playerMaxX - firstX;
    final spaceLeft = firstX - GameConfig.playerMinX;

    if (spaceRight >= minSeparation && spaceLeft >= minSeparation) {
      // Both sides have room; pick randomly.
      final goRight = random.nextBool();
      if (goRight) {
        secondX = firstX +
            minSeparation +
            random.nextDouble() * (spaceRight - minSeparation);
      } else {
        secondX = firstX -
            minSeparation -
            random.nextDouble() * (spaceLeft - minSeparation);
      }
    } else if (spaceRight >= minSeparation) {
      secondX = firstX +
          minSeparation +
          random.nextDouble() * (spaceRight - minSeparation);
    } else {
      secondX = firstX -
          minSeparation -
          random.nextDouble() * (spaceLeft - minSeparation);
    }

    secondX = secondX.clamp(GameConfig.playerMinX, GameConfig.playerMaxX);
    final secondWidth = _randomWidth(random);

    return ObstaclePattern(
      id: 'stagger',
      difficulty: 2,
      placements: [
        ObstaclePlacement(
          normalizedX: _toNormalized(firstX),
          widthOverride: firstWidth,
        ),
        ObstaclePlacement(
          normalizedX: _toNormalized(secondX),
          yOffset: -140.0,
          widthOverride: secondWidth,
        ),
      ],
      postDelay: 0.3,
    );
  }

  /// **wave** (difficulty 3) -- Three obstacles in a diagonal line.
  ///
  /// Random direction (left-to-right or right-to-left). ~100px horizontal
  /// spacing between each, -100 yOffset increments. postDelay 0.4s.
  static ObstaclePattern wave(Random random) {
    const hSpacing = 100.0;
    const vSpacing = -100.0;

    // Pick direction: true = left-to-right, false = right-to-left.
    final leftToRight = random.nextBool();
    final direction = leftToRight ? 1.0 : -1.0;

    // First obstacle x must leave room for 2 more obstacles in the direction.
    final neededRoom = hSpacing * 2;
    double startX;

    if (leftToRight) {
      // Need room to the right.
      final maxStart = GameConfig.playerMaxX - neededRoom;
      startX = GameConfig.playerMinX +
          random.nextDouble() * (maxStart - GameConfig.playerMinX);
    } else {
      // Need room to the left.
      final minStart = GameConfig.playerMinX + neededRoom;
      startX = minStart +
          random.nextDouble() * (GameConfig.playerMaxX - minStart);
    }

    final placements = <ObstaclePlacement>[];
    for (var i = 0; i < 3; i++) {
      final x = startX + direction * hSpacing * i;
      placements.add(
        ObstaclePlacement(
          normalizedX: _toNormalized(x),
          yOffset: vSpacing * i,
          widthOverride: _randomWidth(random),
        ),
      );
    }

    return ObstaclePattern(
      id: 'wave',
      difficulty: 3,
      placements: placements,
      postDelay: 0.4,
    );
  }
}
