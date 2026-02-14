---
phase: 05-audio-system
plan: 01
subsystem: audio
tags: [flame_audio, wav, synthesis, dart_cli, audio_pool]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: flame_audio dependency, asset pipeline, GameConfig pattern
provides:
  - 6 procedurally generated WAV audio assets
  - AudioManager singleton with SFX/BGM API
  - Audio preloading and pool infrastructure
affects: [05-02, 05-03, 05-04, 05-05, 08-03]

# Tech tracking
tech-stack:
  added: [flame_audio AudioPool]
  patterns: [programmatic WAV generation, singleton audio manager, audio pool for low-latency SFX]

key-files:
  created: [tool/generate_audio.dart, lib/utils/audio_manager.dart, assets/audio/dodge_whoosh.wav, assets/audio/death_impact.wav, assets/audio/near_miss.wav, assets/audio/restart_chime.wav, assets/audio/spawn_cue.wav, assets/audio/menu_select.wav]
  modified: [lib/game/config/game_config.dart, lib/game/pulse_game.dart]

key-decisions:
  - "Pure Dart WAV synthesis — no external audio tools or packages for asset generation"
  - "AudioPool for dodge_whoosh and spawn_cue (high-frequency SFX) with maxPlayers: 4"

patterns-established:
  - "Programmatic asset generation via tool/ scripts"
  - "AudioManager singleton accessible via PulseGame.audioManager"

issues-created: []

# Metrics
duration: 7 min
completed: 2026-02-14
---

# Phase 5 Plan 1: Audio Engine Setup Summary

**Programmatic WAV synthesis pipeline generating 6 game SFX plus AudioManager singleton with flame_audio pools and SFX/BGM API**

## Performance

- **Duration:** 7 min
- **Started:** 2026-02-14T00:37:31Z
- **Completed:** 2026-02-14T00:44:28Z
- **Tasks:** 2
- **Files modified:** 10

## Accomplishments
- Created standalone Dart CLI script that synthesizes 6 WAV audio files (44100Hz, 16-bit mono PCM) using pure dart:io/math/typed_data
- Built AudioManager singleton with preloading, AudioPool for high-frequency SFX, and full SFX/BGM API
- Integrated AudioManager into PulseGame.onLoad with audio config constants in GameConfig

## Task Commits

Each task was committed atomically:

1. **Task 1: Generate audio assets with Dart script** - `42c4c03` (feat)
2. **Task 2: Create AudioManager and integrate into PulseGame** - `7e9fde9` (feat)

## Files Created/Modified
- `tool/generate_audio.dart` - Standalone Dart CLI for WAV synthesis (sine, noise, envelope functions)
- `lib/utils/audio_manager.dart` - Singleton AudioManager with preload, pools, playSfx, BGM controls
- `lib/game/config/game_config.dart` - Added defaultSfxVolume/defaultBgmVolume constants
- `lib/game/pulse_game.dart` - Added audioManager field and initialization in onLoad
- `assets/audio/dodge_whoosh.wav` - White noise burst (~0.15s, 13KB)
- `assets/audio/death_impact.wav` - Low sine + noise impact (~0.3s, 27KB)
- `assets/audio/near_miss.wav` - Rising sine sweep (~0.2s, 18KB)
- `assets/audio/restart_chime.wav` - Two ascending tones (~0.25s, 22KB)
- `assets/audio/spawn_cue.wav` - Low sine pulse (~0.08s, 7KB)
- `assets/audio/menu_select.wav` - Sine blip (~0.1s, 9KB)

## Decisions Made
- Pure Dart WAV synthesis with no external audio tools — keeps build reproducible and self-contained
- AudioPool for dodge_whoosh and spawn_cue (maxPlayers: 4) — these fire frequently and need low latency

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- AudioManager infrastructure ready for sound triggers (05-02)
- All 6 SFX assets available for gameplay wiring
- BGM API ready for ambient pulse track (05-03)

---
*Phase: 05-audio-system*
*Completed: 2026-02-14*
