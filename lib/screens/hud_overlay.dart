import 'dart:async';

import 'package:flutter/material.dart';

import '../game/config/game_config.dart';
import '../game/pulse_game.dart';

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
    // Rebuild at ~30fps to keep the timer display responsive.
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
    return SafeArea(
      child: Stack(
        children: [
          // Survival timer — top center
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '${widget.game.survivalTime.toStringAsFixed(1)}s',
                style: const TextStyle(
                  color: GameConfig.textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
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
