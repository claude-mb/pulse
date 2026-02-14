import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/pulse_game.dart';
import 'screens/gallery_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/hud_overlay.dart';
import 'screens/main_menu.dart';
import 'screens/pause_overlay.dart';

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
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameOver': (context, game) => GameOverScreen(game: game),
            'HUD': (context, game) => HudOverlay(game: game),
            'Pause': (context, game) => PauseOverlay(game: game),
            'Gallery': (context, game) => GalleryScreen(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}
