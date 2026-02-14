---
phase: 07-progression
plan: 04
subsystem: progression
tags: [unlock, notification, chime, reward, xp-threshold]

# Dependency graph
requires:
  - phase: 07-progression
    provides: ProgressionRepository with XP, PlayerShapes.all, ColorThemes.all with xpCost
provides:
  - UnlockInfo class for unlock detection results
  - checkNewUnlocks() threshold detection
  - Unlock notification on game over screen with chime audio
affects: [07-05, 08-02]

# Tech tracking
tech-stack:
  added: []
  patterns: [xpBefore/xpAfter threshold crossing detection, delayed audio/animation on game over]

key-files:
  created: [assets/audio/unlock_chime.wav]
  modified: [lib/utils/progression_repository.dart, lib/game/pulse_game.dart, lib/game/config/game_config.dart, lib/screens/game_over_screen.dart, lib/utils/audio_manager.dart, tool/generate_audio.dart]

key-decisions:
  - "Synchronous xpAfter = xpBefore + earned instead of re-reading async repo"
  - "500ms delay before unlock chime to avoid overlapping death impact"
  - "Cap at 3 unlock notifications max on game over screen"

patterns-established:
  - "UnlockInfo: simple data class for unlock detection results"
  - "Threshold crossing: xpBefore < cost <= xpAfter for newly-unlocked detection"

issues-created: []

# Metrics
duration: 4min
completed: 2026-02-14
---

# Phase 7 Plan 4: Unlock Conditions & Reward Triggers Summary

**XP threshold crossing detection with unlock chime audio and fade-in notification on game over screen**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-14T15:33:05Z
- **Completed:** 2026-02-14T15:37:14Z
- **Tasks:** 2
- **Files modified:** 7

## Accomplishments
- Created UnlockInfo class and checkNewUnlocks() method detecting XP threshold crossings
- Wired unlock detection into PulseGame.gameOver() with xpBefore/xpAfter capture
- Generated unlock_chime.wav (bright ascending E5→G5 two-note chime)
- Added unlock notification display on game over screen with 600ms fade-in animation
- Unlock chime plays after 500ms delay to avoid overlapping death sound

## Task Commits

Each task was committed atomically:

1. **Task 1: Detect newly unlocked items at game end** - `136880f` (feat)
2. **Task 2: Unlock notification with chime on game over screen** - `9285440` (feat)

## Files Created/Modified
- `lib/utils/progression_repository.dart` - Added UnlockInfo class and checkNewUnlocks() method
- `lib/game/pulse_game.dart` - Added lastNewUnlocks field, XP capture in gameOver()
- `lib/game/config/game_config.dart` - Added unlockChimeVolume (0.7)
- `lib/screens/game_over_screen.dart` - Unlock fade animation, chime playback, notification display (up to 3 items)
- `lib/utils/audio_manager.dart` - Registered unlock_chime.wav for preloading
- `tool/generate_audio.dart` - Added generateUnlockChime() (E5→G5 sine chime)
- `assets/audio/unlock_chime.wav` - Generated unlock chime audio

## Decisions Made
- Synchronous xpAfter = xpBefore + earned (avoids async timing issues with repo persistence)
- 500ms delay before unlock chime (prevents overlap with death impact sound)
- Cap at 3 unlock notifications max (prevents overflow on screen)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Unlock detection and notification complete
- Ready for collection/gallery screen (07-05) to browse and select unlocked items
- Ready for 07-05-PLAN.md

---
*Phase: 07-progression*
*Completed: 2026-02-14*
