---
phase: 06-scoring
plan: 02
subsystem: ui
tags: [hud, score-display, combo, game-over, flutter-widget]

# Dependency graph
requires:
  - phase: 06-scoring
    provides: ScoreManager with displayScore, combo, comboMultiplier, lastScoreEvent
provides:
  - Live score HUD with combo indicator and score event flash
  - Game over screen with score summary and stats
affects: [06-03-persistence, 06-04-celebration]

# Tech tracking
tech-stack:
  added: []
  patterns: [ScoreManager data binding in StatefulWidget HUD]

key-files:
  created: []
  modified: [lib/screens/hud_overlay.dart, lib/screens/game_over_screen.dart]

key-decisions:
  - "Combo shown only when > 1 to reduce visual noise"
  - "Score event flash at 60% opacity for subtle but visible feedback"

patterns-established:
  - "Score data accessed via widget.game.scoreManager in overlay widgets"

issues-created: []

# Metrics
duration: 4min
completed: 2026-02-14
---

# Phase 6 Plan 2: In-Game Score HUD Summary

**Live score display in HUD with combo multiplier indicator and score event flash, plus game over score summary**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-14T13:21:42Z
- **Completed:** 2026-02-14T13:26:32Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- HUD shows live score (integer) replacing raw survival time
- Combo multiplier indicator appears when combo > 1, in player accent color
- Score event flash shows "DODGE +25" / "NEAR MISS +50" briefly on action
- Game over screen shows final score prominently with stats row (time survived, best combo)

## Task Commits

Each task was committed atomically:

1. **Task 1: Update HUD with live score and combo display** - `933fd4f` (feat)
2. **Task 2: Update game over screen with score summary** - `5652aac` (feat)

## Files Created/Modified
- `lib/screens/hud_overlay.dart` - Replaced survival time with score + combo + score event flash
- `lib/screens/game_over_screen.dart` - Score summary layout with stats row

## Decisions Made
- Combo indicator only visible when combo > 1 — reduces clutter at start
- Score event flash at 60% opacity — visible but not distracting
- Stats row uses divider dot between time and best combo

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Score display fully functional, ready for best score overlay in 06-03 (after persistence)
- Game over screen ready for new high score celebration in 06-04

---
*Phase: 06-scoring*
*Completed: 2026-02-14*
