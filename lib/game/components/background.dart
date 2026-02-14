import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';

/// Subtle scrolling grid background that creates depth and tron-like atmosphere.
///
/// Draws vertical and horizontal lines across the world at [GameConfig.gridSpacing]
/// intervals. The grid scrolls downward at a fraction of obstacle speed for a
/// parallax depth effect. Renders at priority -10 (behind all gameplay objects).
class GameBackground extends Component {
  GameBackground() : super(priority: -10);

  /// Accumulated vertical scroll offset for parallax movement.
  double _scrollOffset = 0.0;

  /// Pre-built paint for grid lines.
  late final Paint _gridPaint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _gridPaint = Paint()
      ..color = GameConfig.gridColor.withValues(alpha: GameConfig.gridOpacity)
      ..strokeWidth = 1.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Scroll at a fraction of obstacle speed for parallax.
    _scrollOffset += GameConfig.obstacleSpeed * GameConfig.gridScrollSpeed * dt;
    // Wrap at grid spacing to prevent unbounded growth.
    if (_scrollOffset >= GameConfig.gridSpacing) {
      _scrollOffset -= GameConfig.gridSpacing;
    }
  }

  @override
  void render(Canvas canvas) {
    final width = GameConfig.worldWidth;
    final height = GameConfig.worldHeight;
    final spacing = GameConfig.gridSpacing;

    // Vertical lines (static — no scroll needed).
    for (double x = 0; x <= width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, height),
        _gridPaint,
      );
    }

    // Horizontal lines (scrolling downward for parallax).
    // Start above the visible area by one spacing to ensure smooth entry.
    for (double y = -spacing + _scrollOffset; y <= height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(width, y),
        _gridPaint,
      );
    }
  }
}
