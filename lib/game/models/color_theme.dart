import 'dart:ui';

/// Defines a complete color palette for the game's visual theme.
///
/// Each theme provides colors for all key game elements: background, player,
/// obstacles, grid, and pulse overlay. Non-themed colors (text, high score
/// gold, danger red) remain constant in [GameConfig].
///
/// Themes are unlocked via milestone XP. The default theme (neonRed) is free;
/// others require progressively more XP.
class ColorTheme {
  /// Unique identifier used for persistence (e.g. 'neon_red').
  final String id;

  /// Human-readable display name (e.g. 'Neon Red').
  final String name;

  /// XP milestone required to unlock this theme (0 = free/default).
  final int xpCost;

  /// Main background fill color.
  final Color backgroundColor;

  /// Player shape fill and glow color.
  final Color playerColor;

  /// Obstacle body fill color.
  final Color obstacleColor;

  /// Obstacle stroke outline color.
  final Color obstacleOutlineColor;

  /// Obstacle top-edge highlight color.
  final Color obstacleHighlightColor;

  /// Accent color used for subtle UI elements.
  final Color accentColor;

  /// Background grid line color (before opacity is applied).
  final Color gridColor;

  /// Background pulse overlay color.
  final Color pulseColor;

  /// Whether obstacles should render hand-drawn angry faces.
  final bool drawFace;

  /// Face stroke/fill color (falls back to [obstacleHighlightColor] if null).
  final Color? faceColor;

  const ColorTheme({
    required this.id,
    required this.name,
    required this.xpCost,
    required this.backgroundColor,
    required this.playerColor,
    required this.obstacleColor,
    required this.obstacleOutlineColor,
    required this.obstacleHighlightColor,
    required this.accentColor,
    required this.gridColor,
    required this.pulseColor,
    this.drawFace = false,
    this.faceColor,
  });
}

/// Static collection of all available color themes.
///
/// Themes are defined as compile-time constants and accessed via [all] or
/// looked up by ID with [getById].
class ColorThemes {
  ColorThemes._();

  /// Default theme -- matches the original game colors exactly.
  static const ColorTheme neonRed = ColorTheme(
    id: 'neon_red',
    name: 'Neon Red',
    xpCost: 0,
    backgroundColor: Color(0xFF1A1A2E),
    playerColor: Color(0xFFE94560),
    obstacleColor: Color(0xFF0F3460),
    obstacleOutlineColor: Color(0xFF1A5276),
    obstacleHighlightColor: Color(0xFF2471A3),
    accentColor: Color(0xFF16213E),
    gridColor: Color(0xFF2A3050),
    pulseColor: Color(0xFF16213E),
  );

  /// Cool blue/cyan palette -- deep ocean atmosphere.
  static const ColorTheme neonBlue = ColorTheme(
    id: 'neon_blue',
    name: 'Neon Blue',
    xpCost: 750,
    backgroundColor: Color(0xFF0A1628),
    playerColor: Color(0xFF00E5FF),
    obstacleColor: Color(0xFF0D4F6B),
    obstacleOutlineColor: Color(0xFF1A7A9B),
    obstacleHighlightColor: Color(0xFF26A8C8),
    accentColor: Color(0xFF0E2240),
    gridColor: Color(0xFF1A3550),
    pulseColor: Color(0xFF0E2240),
  );

  /// Toxic green palette -- neon hacker aesthetic.
  static const ColorTheme neonGreen = ColorTheme(
    id: 'neon_green',
    name: 'Neon Green',
    xpCost: 2000,
    backgroundColor: Color(0xFF0A1A0A),
    playerColor: Color(0xFF39FF14),
    obstacleColor: Color(0xFF1A4D1A),
    obstacleOutlineColor: Color(0xFF2E7D32),
    obstacleHighlightColor: Color(0xFF43A047),
    accentColor: Color(0xFF0E2E0E),
    gridColor: Color(0xFF1A3A1A),
    pulseColor: Color(0xFF0E2E0E),
  );

  /// Deep purple/magenta palette -- synthwave vibes.
  static const ColorTheme neonPurple = ColorTheme(
    id: 'neon_purple',
    name: 'Neon Purple',
    xpCost: 4000,
    backgroundColor: Color(0xFF1A0A2E),
    playerColor: Color(0xFFE040FB),
    obstacleColor: Color(0xFF2E1065),
    obstacleOutlineColor: Color(0xFF4A148C),
    obstacleHighlightColor: Color(0xFF6A1B9A),
    accentColor: Color(0xFF1A0E3E),
    gridColor: Color(0xFF2A1A50),
    pulseColor: Color(0xFF1A0E3E),
  );

  /// Clean monochrome palette -- minimal black and white.
  static const ColorTheme monochrome = ColorTheme(
    id: 'monochrome',
    name: 'Monochrome',
    xpCost: 6000,
    backgroundColor: Color(0xFF000000),
    playerColor: Color(0xFFFFFFFF),
    obstacleColor: Color(0xFF3A3A3A),
    obstacleOutlineColor: Color(0xFF555555),
    obstacleHighlightColor: Color(0xFF777777),
    accentColor: Color(0xFF1A1A1A),
    gridColor: Color(0xFF2A2A2A),
    pulseColor: Color(0xFF1A1A1A),
  );

  /// Dark red palette with hand-drawn angry faces on obstacles.
  static const ColorTheme angryBlocks = ColorTheme(
    id: 'angry_blocks',
    name: 'Angry Blocks',
    xpCost: 8000,
    backgroundColor: Color(0xFF1A0A0A),
    playerColor: Color(0xFFFF6B35),
    obstacleColor: Color(0xFF8B1A1A),
    obstacleOutlineColor: Color(0xFFA52A2A),
    obstacleHighlightColor: Color(0xFFCD5C5C),
    accentColor: Color(0xFF2A0E0E),
    gridColor: Color(0xFF3A1A1A),
    pulseColor: Color(0xFF2A0E0E),
    drawFace: true,
    faceColor: Color(0xFFFFD700),
  );

  /// All available themes in unlock order.
  static const List<ColorTheme> all = [
    neonRed,
    neonBlue,
    neonGreen,
    neonPurple,
    monochrome,
    angryBlocks,
  ];

  /// Looks up a theme by [id]. Returns [neonRed] if not found.
  static ColorTheme getById(String id) {
    for (final theme in all) {
      if (theme.id == id) return theme;
    }
    return neonRed;
  }
}
