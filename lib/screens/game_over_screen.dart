import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';

class GameOverScreen extends StatelessWidget {
  final PulseGame game;

  const GameOverScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => game.resetGame(),
      child: Container(
        color: const Color(0xCC000000),
        child: Stack(
          children: [
            // Centered GAME OVER + Tap to Retry
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GAME OVER',
                    style: TextStyle(
                      color: GameConfig.textColor,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${game.survivalTime.toStringAsFixed(1)}s',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.8),
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'TAP TO RETRY',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.7),
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            // Menu button in bottom-left corner
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => game.returnToMenu(),
                  // Stop tap from propagating to the full-screen retry handler
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'MENU',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.4),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
