import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/models/color_theme.dart';
import '../game/models/player_shape.dart';
import '../game/pulse_game.dart';
import '../utils/audio_manager.dart';
import '../utils/progression_repository.dart';

/// Collection/gallery screen for browsing and selecting unlocked shapes
/// and themes.
///
/// Displays all available player shapes and color themes with their
/// locked/unlocked/selected states. Tapping an unlocked item equips it
/// immediately.
class GalleryScreen extends StatefulWidget {
  final PulseGame game;

  const GalleryScreen({required this.game, super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  PulseGame get game => widget.game;

  ProgressionRepository get _repo => ProgressionRepository.instance;

  /// Tracks which locked item was just tapped to show brief feedback.
  String? _lockedFeedbackId;

  void _onShapeTap(PlayerShape shape) {
    final isUnlocked = _repo.isUnlocked(shape.xpCost);
    if (!isUnlocked) {
      // Brief visual feedback for locked items.
      setState(() => _lockedFeedbackId = shape.id);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _lockedFeedbackId = null);
      });
      return;
    }
    // Already selected — no-op.
    if (shape.id == _repo.selectedShapeId) return;
    game.applyShape(shape.id);
    AudioManager.instance.playSfx('menu_select.wav');
    setState(() {});
  }

  void _onThemeTap(ColorTheme theme) {
    final isUnlocked = _repo.isUnlocked(theme.xpCost);
    if (!isUnlocked) {
      // Brief visual feedback for locked items.
      setState(() => _lockedFeedbackId = theme.id);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _lockedFeedbackId = null);
      });
      return;
    }
    // Already selected — no-op.
    if (theme.id == _repo.selectedThemeId) return;
    game.applyTheme(theme.id);
    AudioManager.instance.playSfx('menu_select.wav');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalXP = _repo.totalXP;
    final selectedShape = _repo.selectedShapeId;
    final selectedTheme = _repo.selectedThemeId;

    return Container(
      color: const Color(0xCC000000),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // COLLECTION title
                const Text(
                  'COLLECTION',
                  style: TextStyle(
                    color: GameConfig.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 8),
                // Total XP display
                Text(
                  '$totalXP XP',
                  style: const TextStyle(
                    color: GameConfig.xpDisplayColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 28),
                // SHAPES section header
                Text(
                  'SHAPES',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                // Shape items
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final shape in PlayerShapes.all)
                      GestureDetector(
                        onTap: () => _onShapeTap(shape),
                        behavior: HitTestBehavior.opaque,
                        child: _buildShapeItem(
                          shape: shape,
                          isUnlocked: _repo.isUnlocked(shape.xpCost),
                          isSelected: shape.id == selectedShape,
                          showLockedFeedback: _lockedFeedbackId == shape.id,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                // THEMES section header
                Text(
                  'THEMES',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                // Theme items
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final theme in ColorThemes.all)
                      GestureDetector(
                        onTap: () => _onThemeTap(theme),
                        behavior: HitTestBehavior.opaque,
                        child: _buildThemeItem(
                          theme: theme,
                          isUnlocked: _repo.isUnlocked(theme.xpCost),
                          isSelected: theme.id == selectedTheme,
                          showLockedFeedback: _lockedFeedbackId == theme.id,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                // BACK button
                GestureDetector(
                  onTap: () => game.hideGallery(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.5),
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a single shape item card with preview, name, and state indicator.
  Widget _buildShapeItem({
    required PlayerShape shape,
    required bool isUnlocked,
    required bool isSelected,
    bool showLockedFeedback = false,
  }) {
    final Color itemColor =
        isUnlocked ? GameConfig.playerColor : Colors.white24;

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shape preview container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? GameConfig.xpDisplayColor
                    : showLockedFeedback
                        ? Colors.white38
                        : Colors.white12,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? GameConfig.xpDisplayColor.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(30, 30),
                painter: _ShapePreviewPainter(
                  shape: shape,
                  color: itemColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Shape name
          Text(
            shape.name,
            style: TextStyle(
              color: isUnlocked
                  ? GameConfig.textColor.withValues(alpha: 0.8)
                  : GameConfig.textColor.withValues(alpha: 0.3),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          // State label
          if (isSelected)
            const Text(
              'EQUIPPED',
              style: TextStyle(
                color: GameConfig.xpDisplayColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            )
          else if (!isUnlocked)
            Text(
              showLockedFeedback
                  ? '${shape.xpCost} XP NEEDED'
                  : '${shape.xpCost} XP',
              style: TextStyle(
                color: showLockedFeedback
                    ? GameConfig.textColor.withValues(alpha: 0.5)
                    : GameConfig.textColor.withValues(alpha: 0.3),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a single theme item card with color swatch, name, and state.
  Widget _buildThemeItem({
    required ColorTheme theme,
    required bool isUnlocked,
    required bool isSelected,
    bool showLockedFeedback = false,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color swatch container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? GameConfig.xpDisplayColor
                    : showLockedFeedback
                        ? Colors.white38
                        : Colors.white12,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? GameConfig.xpDisplayColor.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Center(
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? theme.backgroundColor
                      : Colors.black26,
                  border: Border.all(
                    color: isUnlocked
                        ? theme.playerColor
                        : Colors.white24,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Theme name
          Text(
            theme.name,
            style: TextStyle(
              color: isUnlocked
                  ? GameConfig.textColor.withValues(alpha: 0.8)
                  : GameConfig.textColor.withValues(alpha: 0.3),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          // State label
          if (isSelected)
            const Text(
              'EQUIPPED',
              style: TextStyle(
                color: GameConfig.xpDisplayColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            )
          else if (!isUnlocked)
            Text(
              showLockedFeedback
                  ? '${theme.xpCost} XP NEEDED'
                  : '${theme.xpCost} XP',
              style: TextStyle(
                color: showLockedFeedback
                    ? GameConfig.textColor.withValues(alpha: 0.5)
                    : GameConfig.textColor.withValues(alpha: 0.3),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }
}

/// CustomPainter that draws a scaled-down shape preview using the
/// shape's vertex path.
class _ShapePreviewPainter extends CustomPainter {
  final PlayerShape shape;
  final Color color;

  const _ShapePreviewPainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // The shape vertices are defined in a 40x40 bounding box.
    // Scale them to fit within the given size.
    final scaleX = size.width / 40;
    final scaleY = size.height / 40;

    final path = ui.Path();
    final verts = shape.vertices;
    path.moveTo(verts.first.x * scaleX, verts.first.y * scaleY);
    for (var i = 1; i < verts.length; i++) {
      path.lineTo(verts[i].x * scaleX, verts[i].y * scaleY);
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // Thin outline for definition
    final outlinePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _ShapePreviewPainter oldDelegate) {
    return oldDelegate.shape != shape || oldDelegate.color != color;
  }
}
