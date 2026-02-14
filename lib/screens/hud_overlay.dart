import 'dart:async';

import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';
import '../utils/score_repository.dart';

class HudOverlay extends StatefulWidget {
  final PulseGame game;

  const HudOverlay({required this.game, super.key});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> {
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Rebuild at ~30fps to keep the score display responsive.
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sm = widget.game.scoreManager;

    return SafeArea(
      child: Stack(
        children: [
          // Score + combo + event — top center
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Score display
                Text(
                  '${sm.displayScore}',
                  style: const TextStyle(
                    color: GameConfig.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                // Combo multiplier (only visible when combo > 1)
                if (sm.combo > 1)
                  Text(
                    '\u00d7${sm.comboMultiplier.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: GameConfig.playerColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                // Last score event flash
                if (sm.lastScoreEvent != null)
                  Text(
                    sm.lastScoreEvent!,
                    style: TextStyle(
                      color: GameConfig.textColor.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          // Best score — top left (only shown if a best exists)
          if (ScoreRepository.instance.bestScore > 0)
            Positioned(
              top: 20,
              left: 16,
              child: Text(
                'BEST ${ScoreRepository.instance.bestScore}',
                style: TextStyle(
                  color: GameConfig.textColor.withValues(alpha: 0.5),
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),
          // Pause button — top right
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 28),
              onPressed: () => widget.game.pauseGame(),
            ),
          ),
        ],
      ),
    );
  }
}
