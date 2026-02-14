import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

/// Generates a 1024x1024 PNG app icon for the Pulse game.
///
/// Design:
/// - Background: solid #1A1A2E (dark navy)
/// - Glow layer: diamond at ~560px with 40% opacity neon red
/// - Center diamond: filled #E94560 (neon red), ~500px tall rotated 45deg
void main() {
  const size = 1024;
  const centerX = 512;
  const centerY = 512;
  const diamondHalf = 250; // Half-size of the inner diamond
  const glowOuter = 280; // Outer edge of glow region

  // Colors
  const bgR = 0x1A, bgG = 0x1A, bgB = 0x2E;
  const playerR = 0xE9, playerG = 0x45, playerB = 0x60;

  print('Generating 1024x1024 app icon...');

  // Create image with background color
  final image = img.Image(width: size, height: size);
  img.fill(image, color: img.ColorRgba8(bgR, bgG, bgB, 255));

  // Draw diamond and glow using Manhattan distance
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final d = (x - centerX).abs() + (y - centerY).abs();

      if (d < diamondHalf) {
        // Inner diamond: solid neon red
        image.setPixelRgba(x, y, playerR, playerG, playerB, 255);
      } else if (d < glowOuter) {
        // Glow region: blend neon red over background with fading opacity
        final t = (glowOuter - d) / (glowOuter - diamondHalf); // 1.0 at edge of diamond, 0.0 at outer glow
        final alpha = (t * 0.4 * 255).round().clamp(0, 255); // Max 40% opacity

        // Alpha blend: result = fg * alpha + bg * (1 - alpha)
        final a = alpha / 255.0;
        final r = (playerR * a + bgR * (1 - a)).round();
        final g = (playerG * a + bgG * (1 - a)).round();
        final b = (playerB * a + bgB * (1 - a)).round();

        image.setPixelRgba(x, y, r, g, b, 255);
      }
      // else: keep background color
    }
  }

  // Encode to PNG and write
  final pngBytes = img.encodePng(image);
  final outputPath = 'assets/icon/app_icon.png';
  File(outputPath).writeAsBytesSync(pngBytes);

  final fileSize = File(outputPath).lengthSync();
  print('Icon saved to $outputPath ($fileSize bytes)');
  print('Done!');
}
