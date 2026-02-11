import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/pulse_game.dart';

void main() {
  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget<PulseGame>.controlled(
          gameFactory: PulseGame.new,
          overlayBuilderMap: {
            'MainMenu': (context, game) {
              return GestureDetector(
                onTap: () => game.overlays.remove('MainMenu'),
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Text(
                      'Tap to Start',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              );
            },
            'GameOver': (context, game) {
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    'Game Over',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            },
            'HUD': (context, game) {
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    'HUD',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            },
            'Pause': (context, game) {
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    'Pause',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              );
            },
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}
