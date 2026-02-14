import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';
import '../utils/audio_manager.dart';
import '../utils/progression_repository.dart';
import '../utils/score_repository.dart';

class GameOverScreen extends StatefulWidget {
  final PulseGame game;

  const GameOverScreen({required this.game, super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _unlockFadeController;
  late Animation<double> _unlockFadeAnimation;

  PulseGame get game => widget.game;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (game.lastRunWasNewBest) {
      _pulseController.repeat(reverse: true);
    }

    // Unlock notification fade-in animation.
    _unlockFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _unlockFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _unlockFadeController,
        curve: Curves.easeOut,
      ),
    );

    // If there are new unlocks, play chime and trigger fade-in after a delay.
    if (game.lastNewUnlocks.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _unlockFadeController.forward();
          AudioManager.instance.playSfx(
            'unlock_chime.wav',
            volume: GameConfig.unlockChimeVolume,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _unlockFadeController.dispose();
    super.dispose();
  }

  /// Builds a small label + value column for lifetime stats.
  Widget _lifetimeStat(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: GameConfig.textColor.withValues(alpha: 0.4),
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: GameConfig.textColor.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

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
                  if (game.lastRunWasNewBest)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: const Text(
                        'NEW BEST!',
                        style: TextStyle(
                          color: GameConfig.highScoreColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
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
                  // This-run stats row
                  Text(
                    'Dodges: ${sm.totalDodges}'
                    '  |  Near-misses: ${sm.totalNearMisses}'
                    '  |  Best combo: \u00d7${sm.bestCombo}',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Survival time
                  Text(
                    '${game.survivalTime.toStringAsFixed(1)}s survived',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Thin divider above lifetime stats
                  Container(
                    width: 200,
                    height: 1,
                    color: GameConfig.textColor.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 12),
                  // Lifetime stats grid
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _lifetimeStat(
                        'GAMES',
                        '${ScoreRepository.instance.gamesPlayed}',
                      ),
                      const SizedBox(width: 24),
                      _lifetimeStat(
                        'BEST TIME',
                        '${ScoreRepository.instance.bestSurvivalTime.toStringAsFixed(1)}s',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _lifetimeStat(
                        'TOTAL DODGES',
                        '${ScoreRepository.instance.allTimeTotalDodges}',
                      ),
                      const SizedBox(width: 24),
                      _lifetimeStat(
                        'BEST COMBO',
                        '\u00d7${ScoreRepository.instance.allTimeBestCombo}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // XP earned this game
                  Text(
                    '+${game.lastXpEarned} XP',
                    style: const TextStyle(
                      color: GameConfig.xpDisplayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Total: ${ProgressionRepository.instance.totalXP} XP',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  // Unlock notifications (between XP display and TAP TO RETRY)
                  if (game.lastNewUnlocks.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _unlockFadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final unlock
                              in game.lastNewUnlocks.take(3))
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                'UNLOCKED: ${unlock.name}',
                                style: const TextStyle(
                                  color: GameConfig.xpDisplayColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
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
