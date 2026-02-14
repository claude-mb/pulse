import 'package:shared_preferences/shared_preferences.dart';

/// Persists XP progression and player customisation selections using
/// [SharedPreferences].
///
/// Follows the same singleton pattern as [ScoreRepository].
///
/// XP is milestone-based: it only goes up and is never spent.  Items
/// auto-unlock when [totalXP] reaches their XP threshold.
///
/// Usage:
/// ```dart
/// await ProgressionRepository.instance.initialize();
/// ProgressionRepository.instance.addXP(100);
/// print(ProgressionRepository.instance.totalXP); // 100
/// ```
class ProgressionRepository {
  /// Singleton instance.
  static final ProgressionRepository instance = ProgressionRepository._();

  ProgressionRepository._();

  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _totalXPKey = 'total_xp';
  static const String _selectedShapeKey = 'selected_shape';
  static const String _selectedThemeKey = 'selected_theme';

  static const String _defaultShapeId = 'diamond';
  static const String _defaultThemeId = 'neon_red';

  /// Initialises the repository by loading [SharedPreferences].
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  /// Lifetime XP accumulated across all games.
  int get totalXP {
    if (!_initialized) return 0;
    return _prefs.getInt(_totalXPKey) ?? 0;
  }

  /// Currently selected player shape identifier.
  String get selectedShapeId {
    if (!_initialized) return _defaultShapeId;
    return _prefs.getString(_selectedShapeKey) ?? _defaultShapeId;
  }

  /// Currently selected colour theme identifier.
  String get selectedThemeId {
    if (!_initialized) return _defaultThemeId;
    return _prefs.getString(_selectedThemeKey) ?? _defaultThemeId;
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  /// Awards [amount] XP to the player's lifetime total and persists it.
  Future<void> addXP(int amount) async {
    if (!_initialized || amount <= 0) return;
    await _prefs.setInt(_totalXPKey, totalXP + amount);
  }

  /// Persists the player's selected shape.
  Future<void> setSelectedShape(String id) async {
    if (!_initialized) return;
    await _prefs.setString(_selectedShapeKey, id);
  }

  /// Persists the player's selected colour theme.
  Future<void> setSelectedTheme(String id) async {
    if (!_initialized) return;
    await _prefs.setString(_selectedThemeKey, id);
  }

  /// Returns `true` if the player's lifetime XP meets or exceeds [xpCost].
  bool isUnlocked(int xpCost) => totalXP >= xpCost;
}
