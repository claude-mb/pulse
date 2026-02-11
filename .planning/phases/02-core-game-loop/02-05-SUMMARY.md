---
phase: 02-core-game-loop
plan: 05
subsystem: tuning
tags: [flame, gameplay-feel, timing, obstacle-variation, survival-timer, hud]

# Dependency graph
requires:
  - phase: 02-core-game-loop (02-01 through 02-04)
    provides: Player, obstacles, collision, death/restart
provides:
  - Tuned gameplay values for satisfying feel
  - Obstacle width variation and anti-clustering
  - Survival timer in HUD and game over screen
  - Complete playable core game loop
affects: [phase-3-obstacle-system, phase-4-visual-juice, phase-5-audio, phase-6-scoring]

# Tech tracking
tech-stack:
  added: []
  patterns: [stateful-overlay-with-periodic-timer, anti-clustering-spawn-logic, attempt-based-fallback]

key-files:
  created: []
  modified: [lib/game/config/game_config.dart, lib/game/components/obstacle.dart, lib/game/managers/obstacle_spawner.dart, lib/game/pulse_game.dart, lib/screens/hud_overlay.dart, lib/screens/game_over_screen.dart]

key-decisions:
  - "obstacleSpeed 280, spawnInterval 1.1s — urgent but fair"
  - "Anti-clustering: attempt-based with opposite-side fallback after 10 tries"
  - "Survival timer on both HUD and game over screen — continuous progress feedback"

patterns-established:
  - "StatefulWidget overlay with periodic Timer for live game data display"
  - "Anti-clustering: track lastSpawnX, retry with minimum separation, fallback to opposite side"

issues-created: []

# Metrics
duration: 5 min
completed: 2026-02-11
---

# Phase 2 Plan 5: Timing & Feel Calibration Summary

**Tuned obstacle speed (280) and spawn interval (1.1s), added width variation with anti-clustering, survival timer in HUD and game over screen — core loop playable end-to-end**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-11T22:10:22Z
- **Completed:** 2026-02-11T22:15:49Z
- **Tasks:** 2
- **Files modified:** 6

## Accomplishments
- Obstacle speed increased to 280 (screen crossing ~3s) for urgency
- Spawn interval reduced to 1.1s for denser obstacle field
- Obstacle width varies randomly between 50-80px
- Anti-clustering prevents consecutive obstacles from overlapping positions
- Survival timer visible in HUD during gameplay
- Survival time shown on game over screen
- Complete game loop verified: menu → play → dodge → die → retry

## Task Commits

1. **Task 1: Calibrate values and add obstacle variation** - `61ae4f1` (feat)
2. **Task 2: Add survival timer and verify game loop** - `9a402c8` (feat)

**Plan metadata:** (pending — docs commit)

## Files Created/Modified
- `lib/game/config/game_config.dart` - Tuned speed/interval, added min/max width and spawn separation
- `lib/game/components/obstacle.dart` - Optional width parameter
- `lib/game/managers/obstacle_spawner.dart` - Width randomization, anti-clustering logic
- `lib/game/pulse_game.dart` - Survival timer field, update override, reset calls
- `lib/screens/hud_overlay.dart` - StatefulWidget with periodic timer, survival time display
- `lib/screens/game_over_screen.dart` - Survival time display on death screen

## Decisions Made
- obstacleSpeed 280, spawnInterval 1.1s — creates urgent but fair feel
- Anti-clustering uses attempt-based fallback (10 tries, then opposite side) — avoids infinite loops
- Survival timer on both HUD and game over screen — players see progress continuously

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added survival time to GameOverScreen**
- **Found during:** Task 2 (HUD timer implementation)
- **Issue:** Plan verification criteria stated "die → see time" but plan only specified HUD timer, not game over screen
- **Fix:** Added survival time display to GameOverScreen between title and retry prompt
- **Files modified:** lib/screens/game_over_screen.dart
- **Verification:** Time visible on game over screen after death

---

**Total deviations:** 1 auto-fixed (missing critical — game over time display)
**Impact on plan:** Essential for complete user experience. No scope creep.

## Issues Encountered
None

## Next Phase Readiness
- Phase 2: Core Game Loop is 100% complete (5/5 plans done)
- Playable prototype: dodge obstacles, die, instant retry
- Ready for Phase 3: Obstacle System (patterns, difficulty escalation)

---
*Phase: 02-core-game-loop*
*Completed: 2026-02-11*
