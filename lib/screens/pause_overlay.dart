import 'package:flutter/material.dart';

import '../game/pulse_game.dart';

class PauseOverlay extends StatelessWidget {
  final PulseGame game;

  const PauseOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 48),
            TextButton(
              onPressed: () => game.resumeGame(),
              child: const Text(
                'RESUME',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => game.returnToMenu(),
              child: const Text(
                'QUIT',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
