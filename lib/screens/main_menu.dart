import 'package:flutter/material.dart';

import '../game/pulse_game.dart';

class MainMenu extends StatelessWidget {
  final PulseGame game;

  const MainMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => game.startGame(),
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            // Centered title + tap to play
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PULSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 12,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'TAP TO PLAY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            // COLLECTION button — bottom center, own tap target
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => game.showGallery(),
                  // Stop tap from propagating to the full-screen start handler
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'COLLECTION',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
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
      ),
    );
  }
}
