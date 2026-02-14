import 'package:flutter/material.dart';

import '../game/pulse_game.dart';
import '../utils/audio_manager.dart';

class PauseOverlay extends StatefulWidget {
  final PulseGame game;

  const PauseOverlay({required this.game, super.key});

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  @override
  Widget build(BuildContext context) {
    final audio = AudioManager.instance;

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
              onPressed: () => widget.game.resumeGame(),
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
              onPressed: () => widget.game.returnToMenu(),
              child: const Text(
                'QUIT',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Audio mute toggles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SFX toggle
                _buildToggle(
                  icon: audio.sfxMuted
                      ? Icons.volume_off
                      : Icons.volume_up,
                  label: 'SFX',
                  muted: audio.sfxMuted,
                  onPressed: () {
                    setState(() {
                      audio.toggleSfxMute();
                    });
                  },
                ),
                const SizedBox(width: 32),
                // Music toggle
                _buildToggle(
                  icon: audio.bgmMuted
                      ? Icons.music_off
                      : Icons.music_note,
                  label: 'MUSIC',
                  muted: audio.bgmMuted,
                  onPressed: () {
                    setState(() {
                      audio.toggleBgmMute();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String label,
    required bool muted,
    required VoidCallback onPressed,
  }) {
    return Opacity(
      opacity: muted ? 0.5 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: Colors.white, size: 28),
            onPressed: onPressed,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
