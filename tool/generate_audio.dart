/// Generates WAV audio assets for the Pulse game.
///
/// Run with: dart run tool/generate_audio.dart
/// Outputs 7 WAV files to assets/audio/.
///
/// All files are 44100Hz, 16-bit mono PCM WAV format.
/// No external packages required — uses only dart:io, dart:math, dart:typed_data.
library;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const int sampleRate = 44100;
const int bitsPerSample = 16;
const int numChannels = 1;

// ---------------------------------------------------------------------------
// Synthesis helpers
// ---------------------------------------------------------------------------

/// Sine wave sample at [freq] Hz at time [t] seconds.
double sine(double freq, double t) => sin(2 * pi * freq * t);

/// White noise sample in range [-1, 1].
double noise(Random rng) => rng.nextDouble() * 2.0 - 1.0;

/// Simple attack-decay envelope.
///
/// Ramps linearly from 0 to 1 over [attack] seconds, then decays linearly
/// from 1 to 0 over [decay] seconds. Returns 0 outside [0, attack+decay].
double envelope(double t, double attack, double decay) {
  if (t < 0) return 0;
  if (t < attack) return t / attack;
  final remaining = t - attack;
  if (remaining < decay) return 1.0 - (remaining / decay);
  return 0;
}

/// Exponential decay envelope — sharp attack, natural decay.
double expDecay(double t, double attack, double decayRate) {
  if (t < 0) return 0;
  if (t < attack) return t / attack;
  return exp(-(t - attack) * decayRate);
}

// ---------------------------------------------------------------------------
// WAV writer
// ---------------------------------------------------------------------------

/// Writes a WAV file with the given samples (values in [-1, 1]).
void writeWav(String path, List<double> samples) {
  final numSamples = samples.length;
  final dataSize = numSamples * (bitsPerSample ~/ 8) * numChannels;
  final fileSize = 44 + dataSize - 8; // RIFF chunk size = file size - 8

  final buffer = ByteData(44 + dataSize);
  var offset = 0;

  // RIFF header
  void writeString(String s) {
    for (var i = 0; i < s.length; i++) {
      buffer.setUint8(offset++, s.codeUnitAt(i));
    }
  }

  void writeUint32(int v) {
    buffer.setUint32(offset, v, Endian.little);
    offset += 4;
  }

  void writeUint16(int v) {
    buffer.setUint16(offset, v, Endian.little);
    offset += 2;
  }

  writeString('RIFF');
  writeUint32(fileSize);
  writeString('WAVE');

  // fmt sub-chunk
  writeString('fmt ');
  writeUint32(16); // sub-chunk size
  writeUint16(1); // PCM format
  writeUint16(numChannels);
  writeUint32(sampleRate);
  writeUint32(sampleRate * numChannels * (bitsPerSample ~/ 8)); // byte rate
  writeUint16(numChannels * (bitsPerSample ~/ 8)); // block align
  writeUint16(bitsPerSample);

  // data sub-chunk
  writeString('data');
  writeUint32(dataSize);

  // PCM samples (16-bit signed, little-endian)
  for (final sample in samples) {
    final clamped = sample.clamp(-1.0, 1.0);
    final intVal = (clamped * 32767).round().clamp(-32768, 32767);
    buffer.setInt16(offset, intVal, Endian.little);
    offset += 2;
  }

  File(path).writeAsBytesSync(buffer.buffer.asUint8List());
}

// ---------------------------------------------------------------------------
// Sound generators
// ---------------------------------------------------------------------------

/// Dodge whoosh — white noise burst with fast attack/decay (~0.15s).
List<double> generateDodgeWhoosh() {
  final rng = Random(42);
  final duration = 0.15;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final env = envelope(t, 0.01, 0.14);
    // Filtered noise — mix two noise sources for texture.
    final n = noise(rng) * 0.7 + noise(rng) * 0.3;
    samples.add(n * env * 0.8);
  }
  return samples;
}

/// Death impact — low sine (80Hz) + noise, heavy attack then decay (~0.3s).
List<double> generateDeathImpact() {
  final rng = Random(123);
  final duration = 0.3;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final env = expDecay(t, 0.005, 8.0);
    final low = sine(80, t) * 0.7;
    final n = noise(rng) * 0.3;
    samples.add((low + n) * env * 0.9);
  }
  return samples;
}

/// Near miss — rising sine sweep 400-1200Hz with quick decay (~0.2s).
List<double> generateNearMiss() {
  final duration = 0.2;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  var phase = 0.0;
  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final env = expDecay(t, 0.005, 10.0);
    // Frequency sweeps from 400 to 1200 Hz.
    final freq = 400.0 + (800.0 * t / duration);
    phase += 2 * pi * freq / sampleRate;
    samples.add(sin(phase) * env * 0.7);
  }
  return samples;
}

/// Restart chime — two ascending sine tones (440Hz then 660Hz, ~0.25s).
List<double> generateRestartChime() {
  final duration = 0.25;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    double sample = 0;

    // First tone: 440Hz, 0s-0.15s
    if (t < 0.15) {
      final env1 = envelope(t, 0.005, 0.145);
      sample += sine(440, t) * env1 * 0.6;
    }

    // Second tone: 660Hz, 0.1s-0.25s (overlaps first by 0.05s)
    if (t >= 0.1) {
      final t2 = t - 0.1;
      final env2 = envelope(t2, 0.005, 0.145);
      sample += sine(660, t) * env2 * 0.6;
    }

    samples.add(sample.clamp(-1.0, 1.0));
  }
  return samples;
}

/// Spawn cue — very short low sine pulse at 120Hz (~0.08s).
List<double> generateSpawnCue() {
  final duration = 0.08;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final env = envelope(t, 0.005, 0.075);
    samples.add(sine(120, t) * env * 0.6);
  }
  return samples;
}

/// Menu select — short sine blip at 880Hz (~0.1s).
List<double> generateMenuSelect() {
  final duration = 0.1;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final env = expDecay(t, 0.005, 20.0);
    samples.add(sine(880, t) * env * 0.6);
  }
  return samples;
}

/// Pulse bass — very short deep sine at 55Hz with fast attack and exponential
/// decay (~0.15s). A "felt more than heard" sub-bass thump layered on spawn.
List<double> generatePulseBass() {
  final duration = 0.15;
  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    // Very fast attack (2ms), then exponential decay.
    final env = expDecay(t, 0.002, 20.0);
    samples.add(sine(55, t) * env * 0.3);
  }
  return samples;
}

/// Ambient loop — sub-bass drone with rhythmic pulse and noise texture (~4.4s).
///
/// Designed to loop seamlessly at exactly 4 × 1.1s spawn intervals.
/// Layers:
///   1. Constant 55Hz sine drone (A1 sub-bass) at amplitude ~0.15
///   2. 110Hz sine pulse that fades in/out every 1.1s (4 cycles), amplitude 0–0.2
///   3. Very quiet filtered noise (amplitude ~0.03) for atmospheric texture
///
/// All wave periods are exact integer multiples so the loop point is seamless.
List<double> generateAmbientLoop() {
  final rng = Random(777);

  // Duration: exactly 4 × 1.1s = 4.4s
  // 55Hz: period = 1/55 ≈ 0.01818s → 4.4 / (1/55) = 242 complete cycles ✓
  // 110Hz: period = 1/110 ≈ 0.00909s → 4.4 / (1/110) = 484 complete cycles ✓
  // Pulse envelope cycles: 4 complete cycles in 4.4s ✓
  const double duration = 4.4; // 4 × 1.1s spawn intervals
  const int pulseCycles = 4; // complete envelope cycles in duration

  final numSamples = (sampleRate * duration).round();
  final samples = <double>[];

  // Simple low-pass filter state for noise texture.
  double noisePrev = 0.0;
  const double noiseAlpha = 0.15; // heavy smoothing for rumble-like texture

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    double sample = 0;

    // Layer 1: constant sub-bass drone at 55Hz.
    sample += sine(55, t) * 0.15;

    // Layer 2: rhythmic pulse at 110Hz with smooth sine envelope.
    // Envelope uses a sine wave at the pulse frequency (1/1.1 Hz),
    // rectified to always be positive: |sin(...)| gives smooth fade in/out.
    // The pulse completes exactly [pulseCycles] cycles in [duration].
    final pulseEnvFreq = pulseCycles / duration; // = 1/1.1 Hz
    final pulseEnv = sin(2 * pi * pulseEnvFreq * t).abs();
    sample += sine(110, t) * pulseEnv * 0.2;

    // Layer 3: filtered noise for atmospheric texture.
    final rawNoise = noise(rng);
    noisePrev = noisePrev * (1.0 - noiseAlpha) + rawNoise * noiseAlpha;
    sample += noisePrev * 0.03;

    samples.add(sample.clamp(-1.0, 1.0));
  }
  return samples;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

void main() {
  final outputDir = 'assets/audio';
  Directory(outputDir).createSync(recursive: true);

  final sounds = <String, List<double> Function()>{
    'dodge_whoosh.wav': generateDodgeWhoosh,
    'death_impact.wav': generateDeathImpact,
    'near_miss.wav': generateNearMiss,
    'restart_chime.wav': generateRestartChime,
    'spawn_cue.wav': generateSpawnCue,
    'menu_select.wav': generateMenuSelect,
    'pulse_bass.wav': generatePulseBass,
    'ambient_loop.wav': generateAmbientLoop,
  };

  for (final entry in sounds.entries) {
    final path = '$outputDir/${entry.key}';
    final samples = entry.value();
    writeWav(path, samples);
    final file = File(path);
    final size = file.lengthSync();
    print('Generated $path (${samples.length} samples, $size bytes)');
  }

  print('\nAll ${sounds.length} audio files generated successfully.');
}
