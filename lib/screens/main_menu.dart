import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';
import '../utils/daily_challenge_repository.dart';
import '../utils/score_repository.dart';

class MainMenu extends StatefulWidget {
  final PulseGame game;
  final bool animate;

  const MainMenu({required this.game, this.animate = true, super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.animate) {
      _fadeController.forward();
    } else {
      _fadeController.value = 1.0;
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildDailyStats() {
    final dailyBest = DailyChallengeRepository.instance.dailyBestScore;
    final streak = DailyChallengeRepository.instance.streak;
    final children = <Widget>[];
    if (dailyBest > 0) {
      children.add(Text(
        'BEST $dailyBest',
        style: TextStyle(
          color: GameConfig.textColor.withValues(alpha: 0.4),
          fontSize: 12,
        ),
      ));
    }
    if (dailyBest > 0 && streak > 0) {
      children.add(const SizedBox(width: 12));
    }
    if (streak > 0) {
      children.add(Text(
        '$streak DAY STREAK',
        style: TextStyle(
          color: GameConfig.xpDisplayColor.withValues(alpha: 0.6),
          fontSize: 12,
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestScore = ScoreRepository.instance.bestScore;

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        onTap: () => widget.game.startGame(),
        child: Container(
          color: Colors.black54,
          child: Stack(
            children: [
            // Centered title + tap to play
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulsing title with glow
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow layer behind
                        Text(
                          'PULSE',
                          style: TextStyle(
                            color: GameConfig.accentColor
                                .withValues(alpha: 0.15),
                            fontSize: 68,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 12,
                          ),
                        ),
                        // Main title
                        Text(
                          'PULSE',
                          style: TextStyle(
                            color: GameConfig.textColor,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'TAP TO PLAY',
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.7),
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                  ),
                  // Best score display — only if player has scored
                  if (bestScore > 0) ...[
                    const SizedBox(height: 16),
                    Text(
                      'BEST $bestScore',
                      style: TextStyle(
                        color: GameConfig.textColor.withValues(alpha: 0.5),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                  // Daily challenge section
                  const SizedBox(height: 24),
                  Container(
                    width: 120,
                    height: 1,
                    color: GameConfig.textColor.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => widget.game.startDailyChallenge(),
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      'DAILY CHALLENGE',
                      style: TextStyle(
                        color: GameConfig.accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDailyStats(),
                ],
              ),
            ),
            // SETTINGS and COLLECTION buttons — bottom center
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => widget.game.showSettings(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'SETTINGS',
                        style: TextStyle(
                          color: GameConfig.textColor.withValues(alpha: 0.5),
                          fontSize: 16,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () => widget.game.showGallery(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'COLLECTION',
                        style: TextStyle(
                          color: GameConfig.textColor.withValues(alpha: 0.5),
                          fontSize: 16,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
