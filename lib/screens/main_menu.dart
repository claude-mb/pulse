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
        child: const Center(
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
      ),
    );
  }
}
