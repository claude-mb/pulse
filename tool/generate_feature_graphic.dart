import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

/// Generates a 1024x500 PNG feature graphic for Google Play.
///
/// Design:
/// - Background: solid #1A1A2E (dark navy, matching game theme)
/// - Center-left: diamond shape ~350px tall with glow effect
/// - Right side: "PULSE" in block-letter pixel art, white (#FFFFFF)
void main() {
  const width = 1024;
  const height = 500;

  // Diamond position: offset left
  const diamondX = 300;
  const diamondY = 250;
  const diamondHalf = 140; // Half-size of inner diamond (~280px tall)
  const glowOuter = 175; // Outer edge of glow region

  // Colors
  const bgR = 0x1A, bgG = 0x1A, bgB = 0x2E;
  const playerR = 0xE9, playerG = 0x45, playerB = 0x60;

  print('Generating 1024x500 feature graphic...');

  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgba8(bgR, bgG, bgB, 255));

  // Draw diamond and glow using Manhattan distance
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final d = (x - diamondX).abs() + (y - diamondY).abs();

      if (d < diamondHalf) {
        // Inner diamond: solid neon red
        image.setPixelRgba(x, y, playerR, playerG, playerB, 255);
      } else if (d < glowOuter) {
        // Glow region: blend neon red over background with fading opacity
        final t = (glowOuter - d) / (glowOuter - diamondHalf);
        final alpha = (t * 0.4 * 255).round().clamp(0, 255);

        final a = alpha / 255.0;
        final r = (playerR * a + bgR * (1 - a)).round();
        final g = (playerG * a + bgG * (1 - a)).round();
        final b = (playerB * a + bgB * (1 - a)).round();

        image.setPixelRgba(x, y, r, g, b, 255);
      }
    }
  }

  // Draw "PULSE" in block-letter pixel art on the right side
  // Each letter is a 5x7 grid, scaled up by 8x for readability
  const scale = 8;
  const letterW = 5;
  const letterH = 7;
  const spacing = 2; // grid units between letters
  const scaledLetterW = letterW * scale; // 40px per letter
  const scaledSpacing = spacing * scale; // 16px between letters
  const totalTextW =
      5 * scaledLetterW + 4 * scaledSpacing; // 5 letters + 4 gaps = 264px

  // Position text: centered in the right portion (from ~500 to 1024)
  const textStartX = 500 + (524 - totalTextW) ~/ 2; // ~630
  const textStartY = (height - letterH * scale) ~/ 2; // vertically centered

  // 5x7 pixel font definitions for P, U, L, S, E
  const letters = <String, List<String>>{
    'P': [
      '####.',
      '#...#',
      '#...#',
      '####.',
      '#....',
      '#....',
      '#....',
    ],
    'U': [
      '#...#',
      '#...#',
      '#...#',
      '#...#',
      '#...#',
      '#...#',
      '.###.',
    ],
    'L': [
      '#....',
      '#....',
      '#....',
      '#....',
      '#....',
      '#....',
      '#####',
    ],
    'S': [
      '.####',
      '#....',
      '#....',
      '.###.',
      '....#',
      '....#',
      '####.',
    ],
    'E': [
      '#####',
      '#....',
      '#....',
      '####.',
      '#....',
      '#....',
      '#####',
    ],
  };

  const word = ['P', 'U', 'L', 'S', 'E'];

  for (int li = 0; li < word.length; li++) {
    final pattern = letters[word[li]]!;
    final offsetX = textStartX + li * (scaledLetterW + scaledSpacing);

    for (int row = 0; row < letterH; row++) {
      for (int col = 0; col < letterW; col++) {
        if (pattern[row][col] == '#') {
          // Fill a scale x scale block
          for (int dy = 0; dy < scale; dy++) {
            for (int dx = 0; dx < scale; dx++) {
              final px = offsetX + col * scale + dx;
              final py = textStartY + row * scale + dy;
              if (px >= 0 && px < width && py >= 0 && py < height) {
                image.setPixelRgba(px, py, 255, 255, 255, 255);
              }
            }
          }
        }
      }
    }
  }

  // Encode to PNG and write
  final pngBytes = img.encodePng(image);
  final outputDir = Directory('store/google_play');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }
  final outputPath = 'store/google_play/feature_graphic.png';
  File(outputPath).writeAsBytesSync(pngBytes);

  final fileSize = File(outputPath).lengthSync();
  print('Feature graphic saved to $outputPath ($fileSize bytes)');
  print('Done!');
}
