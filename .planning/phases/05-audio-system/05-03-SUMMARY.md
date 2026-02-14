---
phase: 05-audio-system
plan: 03
subsystem: audio
tags: [flame_audio, bgm, ambient_loop, wav_synthesis, game_state]

# Dependency graph
requires:
  - phase: 05-audio-system
    provides: AudioManager with BGM API, generate_audio.dart script
provides:
  - Seamless ambient_loop.wav (4.4s, sub-bass drone + rhythmic pulse + noise texture)
  - BGM wired into all game state transitions
affects: [05-04, 05-05]

# Tech tracking
tech-stack:
  added: []
  patterns: [FlameAudio.bgm lifecycle management, stop-before-play guard]

key-files:
  created: [assets/audio/ambient_loop.wav]
  modified: [tool/generate_audio.dart, lib/game/pulse_game.dart, lib/utils/audio_manager.dart]

key-decisions:
  - "4.4s loop duration (4 × 1.1s spawn intervals) for seamless rhythmic alignment"
  - "Abrupt BGM stop on death — silence reinforces impact moment"

patterns-established:
  - "BGM lifecycle mirrors game state: play on start, pause/resume, stop on death/menu"

issues-created: []

# Metrics
duration: 6 min
completed: 2026-02-14
---

# Phase 5 Plan 3: Ambient Background Pulse Summary

**Seamless 4.4s ambient loop with 55Hz sub-bass drone, 110Hz rhythmic pulse synced to spawn interval, and noise texture — wired to full game state lifecycle**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-14T08:32:33Z
- **Completed:** 2026-02-14T08:38:18Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- Generated ambient_loop.wav with three-layer synthesis: 55Hz drone, 110Hz pulse fading every 1.1s (4 cycles), filtered noise texture
- Loop is exactly 4.4s for seamless repeat aligned to spawn rhythm
- BGM wired into all 6 game state transitions: start, reset, gameOver, pause, resume, returnToMenu
- Added stop-before-play guard in playBgm to prevent overlap on rapid restarts

## Task Commits

Each task was committed atomically:

1. **Task 1: Generate ambient loop audio asset** - `241a2d4` (feat)
2. **Task 2: Wire BGM into game state lifecycle** - `0792216` (feat)

## Files Created/Modified
- `tool/generate_audio.dart` - Added generateAmbientLoop() with 3-layer synthesis
- `assets/audio/ambient_loop.wav` - 388KB seamless loop (4.4s, 44100Hz, 16-bit mono)
- `lib/game/pulse_game.dart` - BGM calls in startGame, resetGame, gameOver, pauseGame, resumeGame, returnToMenu
- `lib/utils/audio_manager.dart` - Added ambient_loop.wav to preload list, stop-before-play guard in playBgm

## Decisions Made
- 4.4s loop duration = 4 × 1.1s spawn intervals — ensures rhythmic alignment with obstacle spawning
- Abrupt BGM stop on death rather than fade — silence after death impact is more dramatic

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- BGM infrastructure complete, ready for dynamic audio behavior (05-04)
- All state transitions handled, ready for volume/mute controls (05-05)

---
*Phase: 05-audio-system*
*Completed: 2026-02-14*
