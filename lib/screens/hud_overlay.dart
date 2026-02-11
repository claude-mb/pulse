import 'package:flutter/material.dart';

import '../game/pulse_game.dart';

class HudOverlay extends StatelessWidget {
  final PulseGame game;

  const HudOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Score — top left
          const Positioned(
            top: 16,
            left: 16,
            child: Text(
              'Score: 0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          // Pause button — top right
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 28),
              onPressed: () => game.pauseGame(),
            ),
          ),
          // Debug game-over button — bottom center
          // TODO: Remove in Phase 2
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => game.gameOver(),
                child: const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
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
