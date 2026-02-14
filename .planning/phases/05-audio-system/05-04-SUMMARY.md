---
phase: 05-audio-system
plan: 04
subsystem: audio
tags: [flame_audio, difficulty_scaling, audio_pool, pulse_bass, dynamic_audio]

# Dependency graph
requires:
  - phase: 05-audio-system
    provides: AudioManager with pools, SFX wiring, ambient loop
  - phase: 03-obstacle-system
    provides: DifficultyManager with speedMultiplier
provides:
  - Difficulty-reactive audio intensity scaling
  - Pulse bass sub-layer for spawn rhythm
  - Unified audio-visual spawn heartbeat
affects: [05-05]

# Tech tracking
tech-stack:
  added: []
  patterns: [difficulty-reactive volume scaling via speedMultiplier, multi-layer spawn audio]

key-files:
  created: [assets/audio/pulse_bass.wav]
  modified: [lib/game/managers/obstacle_spawner.dart, lib/game/components/obstacle.dart, lib/game/config/game_config.dart, tool/generate_audio.dart, lib/utils/audio_manager.dart]

key-decisions:
  - "Volume scaling via speedMultiplier lerp — mirrors danger tint opacity approach"
  - "Pulse bass as sub-frequency layer: felt more than heard"

patterns-established:
  - "Difficulty-reactive audio: base + (speedMultiplier - 1.0) * scale, clamped"

issues-created: []

# Metrics
duration: 3 min
completed: 2026-02-14
---

# Phase 5 Plan 4: Dynamic Audio Summary

**Difficulty-reactive volume scaling for spawn cue and near-miss, plus 55Hz pulse bass sub-layer synced to visual background pulse for unified audio-visual heartbeat**

## Performance

- **Duration:** 3 min
- **Started:** 2026-02-14T08:39:26Z
- **Completed:** 2026-02-14T08:42:48Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments
- Spawn cue volume scales 0.3→0.6 with difficulty, near-miss scales 0.5→1.0
- Generated pulse_bass.wav (55Hz, 0.15s exponential decay) as sub-bass thump layer
- Three spawn events fire on same frame: visual pulse kick + audio tick + bass thump
- All scaling uses consistent speedMultiplier lerp pattern matching visual danger tint approach

## Task Commits

Each task was committed atomically:

1. **Task 1: Scale spawn cue and near-miss volume with difficulty** - `8f8e814` (feat)
2. **Task 2: Add pulse bass layer and sync spawn audio with visual pulse** - `b571cf8` (feat)

## Files Created/Modified
- `lib/game/config/game_config.dart` - Added 6 volume constants (spawn cue, near-miss, pulse bass base/max)
- `lib/game/managers/obstacle_spawner.dart` - Difficulty-scaled spawn cue + pulse bass volumes
- `lib/game/components/obstacle.dart` - Difficulty-scaled near-miss volume
- `tool/generate_audio.dart` - Added generatePulseBass() function
- `assets/audio/pulse_bass.wav` - 55Hz sub-bass thump (0.15s, 13KB)
- `lib/utils/audio_manager.dart` - Added pulse_bass pool and preloading

## Decisions Made
- Volume scaling via speedMultiplier lerp — same approach as visual danger tint for consistent feel
- Pulse bass as sub-frequency layer that's felt more than heard — adds physical weight without clutter

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Dynamic audio complete, ready for audio settings/controls (05-05)
- 8 total audio assets now in pipeline

---
*Phase: 05-audio-system*
*Completed: 2026-02-14*
