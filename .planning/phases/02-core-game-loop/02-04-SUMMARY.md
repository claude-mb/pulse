---
phase: 02-core-game-loop
plan: 04
subsystem: game-flow
tags: [flame, restart, game-over, state-transitions, instant-retry]

# Dependency graph
requires:
  - phase: 02-core-game-loop (02-01 through 02-03)
    provides: Player, obstacles, collision → gameOver trigger
provides:
  - Clean world reset on all state transitions
  - Instant retry game over screen
  - Zero-friction play/die/restart loop
affects: [02-05-tuning, phase-4-visual-juice, phase-6-scoring, phase-8-ui-menus]

# Tech tracking
tech-stack:
  added: []
  patterns: [full-screen-gesture-detector, semi-transparent-overlay, stop-propagation-for-nested-actions]

key-files:
  created: []
  modified: [lib/game/pulse_game.dart, lib/screens/game_over_screen.dart]

key-decisions:
  - "Menu button bottom-center instead of corner — more natural for mobile"
  - "Full-screen tap for retry — fastest possible restart"
  - "Semi-transparent overlay — game state visible behind GAME OVER"

patterns-established:
  - "State transition cleanup: every transition calls clearObstacles + resetPosition + spawner.reset"
  - "Overlay UX: full-screen primary action + small secondary action with stop-propagation"

issues-created: []

# Metrics
duration: 4 min
completed: 2026-02-11
---

# Phase 2 Plan 4: Death & Instant Restart Summary

**Zero-friction retry loop with clean world reset on all state transitions and full-screen tap-to-retry game over screen**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-11T22:05:40Z
- **Completed:** 2026-02-11T22:09:30Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- All state transitions (startGame, resetGame, returnToMenu) guarantee clean world state
- Game over screen enables instant retry with single tap anywhere
- Menu button available at bottom-center with gesture propagation stop
- Semi-transparent overlay keeps game state visible

## Task Commits

1. **Task 1: Clean world reset on state transitions** - `c6caee4` (feat)
2. **Task 2: Polish game over screen for instant retry** - `c2c0ce1` (feat)

**Plan metadata:** (pending — docs commit)

## Files Created/Modified
- `lib/game/pulse_game.dart` - Added cleanup calls to returnToMenu()
- `lib/screens/game_over_screen.dart` - Full rewrite: tap-to-retry, semi-transparent overlay, menu button

## Decisions Made
- Menu button at bottom-center (not corner) — more natural mobile UX
- Full-screen GestureDetector for retry — minimizes friction
- Semi-transparent overlay so player can see game state behind GAME OVER text

## Deviations from Plan

None significant — minor UX improvement (menu button placement bottom-center vs corner).

## Issues Encountered
None

## Next Phase Readiness
- Full game loop functional: menu → play → dodge → die → retry
- Ready for timing tuning (Plan 02-05)

---
*Phase: 02-core-game-loop*
*Completed: 2026-02-11*
