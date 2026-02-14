import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';

/// Placeholder settings screen.
///
/// Displays a title and a back button to return to the main menu.
/// Actual settings controls will be added in a future phase.
class SettingsScreen extends StatelessWidget {
  final PulseGame game;

  const SettingsScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Stack(
        children: [
          // Centered title
          Center(
            child: Text(
              'SETTINGS',
              style: TextStyle(
                color: GameConfig.textColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          // BACK button — bottom center
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => game.hideSettings(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'BACK',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.5),
                      fontSize: 16,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
