import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';

class TutorialOverlay extends StatefulWidget {
  final PulseGame game;

  const TutorialOverlay({required this.game, super.key});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.game.dismissTutorial(),
        child: Container(
          color: const Color(0xCC000000),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'HOW TO PLAY',
                  style: TextStyle(
                    color: GameConfig.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 32),
                // Left dodge instruction
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TAP LEFT',
                          style: TextStyle(
                            color: GameConfig.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'TO DODGE LEFT',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.5),
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Right dodge instruction
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TAP RIGHT',
                          style: TextStyle(
                            color: GameConfig.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'TO DODGE RIGHT',
                          style: TextStyle(
                            color: GameConfig.textColor.withValues(alpha: 0.5),
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Survive subtitle
                Text(
                  'DODGE OBSTACLES TO SURVIVE',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                // Tap to start prompt
                Text(
                  'TAP TO START',
                  style: TextStyle(
                    color: GameConfig.textColor.withValues(alpha: 0.7),
                    fontSize: 20,
                    letterSpacing: 4,
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
