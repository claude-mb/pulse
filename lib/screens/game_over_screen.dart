import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';
import '../utils/score_repository.dart';

class GameOverScreen extends StatelessWidget {
  final PulseGame game;

  const GameOverScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final sm = game.scoreManager;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => game.resetGame(),
      child: Container(
        color: const Color(0xCC000000),
        child: Stack(
          children: [
            // Centered content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GAME OVER title
                  Text(
                    'GAME OVER',
                    style: TextStyle(
                      color: GameConfig.textColor,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // SCORE label
                  Text(
                    'SCORE',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.6),
                      fontSize: 14,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Final score number
                  Text(
                    '${sm.displayScore}',
                    style: const TextStyle(
                      color: GameConfig.textColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Best score comparison
                  if (sm.isNewBest)
                    const Text(
                      'NEW BEST!',
                      style: TextStyle(
                        color: GameConfig.playerColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    )
                  else
                    Text(
                      'BEST ${ScoreRepository.instance.bestScore}',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.5),
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Stats row: survival time + best combo
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${game.survivalTime.toStringAsFixed(1)}s',
                        style: TextStyle(
                          color: GameConfig.textColor.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                      if (sm.bestCombo > 1) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '\u00b7',
                            style: TextStyle(
                              color:
                                  GameConfig.textColor.withValues(alpha: 0.5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Best \u00d7${sm.bestCombo}',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  // TAP TO RETRY
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
            // Menu button — bottom center
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
