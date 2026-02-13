---
phase: 04-visual-juice
plan: 01
subsystem: effects
tags: [flame, camera-shake, screen-shake, near-miss, game-feel]

# Dependency graph
requires:
  - phase: 02-core-game-loop
    provides: Player component, collision detection, game state management
  - phase: 03-obstacle-system
    provides: Obstacle component with speed/position, GameConfig pattern constants
provides:
  - Reusable ScreenShake effect component with configurable intensity/duration
  - triggerShake() API on PulseGame for any caller
  - Near-miss detection on obstacles within configurable threshold
  - Death shake with delayed pause for visual feedback
affects: [04-visual-juice, 05-audio-system]

# Tech tracking
tech-stack:
  added: []
  patterns: [manual per-frame position jitter (not MoveEffect), Future.delayed with state guard for deferred pause]

key-files:
  created: [lib/game/effects/screen_shake.dart]
  modified: [lib/game/config/game_config.dart, lib/game/pulse_game.dart, lib/game/components/obstacle.dart]

key-decisions:
  - "Manual random offset per frame instead of MoveEffect — jitter needs non-deterministic per-frame control"
  - "Future.delayed with state guard for death pause — shake must play out before game freezes"
  - "Near-miss threshold 70px center-to-center — triggers often with 80% hitbox, feels rewarding"
  - "_clearShake helper in startGame/resetGame — prevents stale shake state on restart"

patterns-established:
  - "ScreenShake on camera.viewfinder: add as child, auto-removes after duration"
  - "triggerShake() prevents stacking by removing existing shakes first"
  - "Near-miss detection: one-shot flag per obstacle when passing player Y zone"

issues-created: []

# Metrics
duration: 9min
completed: 2026-02-13
---

# Plan 04-01: Screen Shake System Summary

**Reusable ScreenShake effect with decaying random offsets, death shake with delayed pause, and per-obstacle near-miss detection**

## Performance

- **Duration:** 9 min
- **Started:** 2026-02-13T22:42:03Z
- **Completed:** 2026-02-13T22:50:39Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- ScreenShake component with linear intensity decay and automatic base position restoration
- Death triggers strong camera shake (8px, 0.3s) before game pauses via Future.delayed with state guard
- Obstacles detect near-misses (within 70px) as they pass the player zone, triggering subtle shake (3px, 0.15s)
- triggerShake() API on PulseGame prevents shake stacking and is reusable for any future caller

## Task Commits

Each task was committed atomically:

1. **Task 1: Create ScreenShake effect component** - `aee2a80` (feat)
2. **Task 2: Wire shake to death and implement near-miss detection** - `77e8644` (feat)

**Plan metadata:** `pending` (docs: complete plan)

## Files Created/Modified
- `lib/game/effects/screen_shake.dart` - Reusable screen shake component with decaying random offsets
- `lib/game/config/game_config.dart` - Added shake intensity, duration, and near-miss threshold constants
- `lib/game/pulse_game.dart` - Added triggerShake(), _clearShake(), modified gameOver() for delayed pause
- `lib/game/components/obstacle.dart` - Added HasGameReference mixin and near-miss detection in update()

## Decisions Made
- Used manual per-frame random offsets instead of MoveEffect — random jitter needs non-deterministic control, not tweened animation
- Future.delayed with state guard for death pause — ensures shake plays out visually; guard prevents pausing if user restarts during the 300ms window
- Added _clearShake() helper called from startGame/resetGame to prevent stale shake state on restart (deviation Rule 2: missing critical functionality)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added _clearShake helper to startGame/resetGame**
- **Found during:** Task 2 (wiring death shake)
- **Issue:** Plan specified ensuring paused=false in startGame/resetGame but didn't explicitly mention cleaning up lingering ScreenShake components and restoring viewfinder position
- **Fix:** Added _clearShake() private method that removes ScreenShake children and resets viewfinder to base position, called from both startGame() and resetGame()
- **Files modified:** lib/game/pulse_game.dart
- **Verification:** flutter analyze passes, build succeeds
- **Committed in:** 77e8644 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 missing critical), 0 deferred
**Impact on plan:** Auto-fix prevents camera offset persisting across game restarts. Essential for correctness.

## Issues Encountered
None

## Next Phase Readiness
- Screen shake system is reusable — any component can call game.triggerShake(intensity, duration)
- Ready for 04-02 (particle effects) — effects/ directory now established
- Near-miss detection provides a hook point for future audio feedback (05-04)

---
*Phase: 04-visual-juice*
*Completed: 2026-02-13*
