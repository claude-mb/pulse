import 'package:flutter/material.dart';

import '../game/pulse_game.dart';

class GameOverScreen extends StatelessWidget {
  final PulseGame game;

  const GameOverScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Score: 0',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () => game.resetGame(),
              child: const Text(
                'TAP TO RETRY',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => game.returnToMenu(),
              child: const Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
