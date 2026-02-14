import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/models/color_theme.dart';
import '../game/models/player_shape.dart';
import '../game/pulse_game.dart';
import '../utils/audio_manager.dart';
import '../utils/progression_repository.dart';

/// Settings screen with audio toggles and customization info.
///
/// Provides SFX and music mute toggles, displays the currently equipped
/// shape and theme, and links to the collection gallery.
class SettingsScreen extends StatefulWidget {
  final PulseGame game;

  const SettingsScreen({required this.game, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PulseGame get game => widget.game;

  AudioManager get _audio => AudioManager.instance;

  @override
  Widget build(BuildContext context) {
    final sfxMuted = _audio.sfxMuted;
    final bgmMuted = _audio.bgmMuted;

    final shapeName = PlayerShapes.getById(
      ProgressionRepository.instance.selectedShapeId,
    ).name;
    final themeName = ColorThemes.getById(
      ProgressionRepository.instance.selectedThemeId,
    ).name;

    return Container(
      color: const Color(0xCC000000),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SETTINGS title
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    color: GameConfig.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 28),
                // AUDIO section header
                Text(
                  'AUDIO',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                // SFX toggle row
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _audio.toggleSfxMute();
                    setState(() {});
                  },
                  child: Opacity(
                    opacity: sfxMuted ? 0.5 : 1.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          sfxMuted ? Icons.volume_off : Icons.volume_up,
                          color: GameConfig.textColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SFX',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.8),
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          sfxMuted ? 'OFF' : 'ON',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Music toggle row
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _audio.toggleBgmMute();
                    setState(() {});
                  },
                  child: Opacity(
                    opacity: bgmMuted ? 0.5 : 1.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          bgmMuted ? Icons.music_off : Icons.music_note,
                          color: GameConfig.textColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'MUSIC',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.8),
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          bgmMuted ? 'OFF' : 'ON',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Container(
                  width: 200,
                  height: 1,
                  color: GameConfig.textColor.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 24),
                // CUSTOMIZATION section header
                Text(
                  'CUSTOMIZATION',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                // Equipped shape row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Shape',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.8),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      shapeName,
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Equipped theme row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.8),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      themeName,
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // VIEW COLLECTION button
                GestureDetector(
                  onTap: () => game.showGalleryFromSettings(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'VIEW COLLECTION',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.5),
                        fontSize: 16,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // BACK button
                GestureDetector(
                  onTap: () => game.hideSettings(),
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
}
