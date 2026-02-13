---
phase: 04-visual-juice
plan: 05
subsystem: effects
tags: [flame, slow-motion, death-animation, entrance-animation, invulnerability, transitions]

# Dependency graph
requires:
  - phase: 02-core-game-loop
    provides: Player component, game state management, game over/restart flow
  - phase: 04-visual-juice/01
    provides: Screen shake system, death pause delay window
  - phase: 04-visual-juice/02
    provides: Death particles, dodge sparkle effects
  - phase: 04-visual-juice/03
    provides: Flash overlay, danger tint
  - phase: 04-visual-juice/04
    provides: Player glow/pulse rendering, geometric art style
provides:
  - Death slow-motion via _timeScale field on PulseGame (0.3x for 0.5s)
  - Player death animation — shrink to 0 + fade out over 0.4s during slow-mo
  - Player entrance animation — elastic pop-in from scale 0 + fade-in over 0.2s
  - Spawn protection with 0.5s invulnerability during entrance
  - resetVisuals() method on Player for clean state restoration
affects: [04-visual-juice, 05-audio-system]

# Tech tracking
tech-stack:
  added: []
  patterns: [_timeScale multiplier on FlameGame.update() for slow-motion, manual paint alpha animation for PolygonComponent opacity, ScaleEffect with elastic/easeIn curves, invulnerability flag with Future.delayed timer]

key-files:
  created: []
  modified: [lib/game/pulse_game.dart, lib/game/components/player.dart, lib/game/config/game_config.dart]

key-decisions:
  - "Manual _timeScale on PulseGame.update() instead of Flame built-in — cleaner control, applies to all children uniformly"
  - "Manual paint alpha animation for opacity instead of OpacityEffect — PolygonComponent lacks HasPaint mixin"
  - "Extended pre-pause delay from 0.3s to 0.5s for slow-mo window"
  - "Entrance invulnerability via Future.delayed — simple, prevents unfair deaths during pop-in"
  - "elasticOut curve for entrance, easeIn for death — pop-in feels satisfying, death feels weighty"

patterns-established:
  - "Time scale pattern: _timeScale field multiplied against dt in update(), reset in startGame/resetGame"
  - "Manual opacity animation: timer-based paint.color alpha interpolation for components without OpacityEffect support"
  - "Entrance/death animation pair: playEntranceAnimation() and playDeathAnimation() with resetVisuals() cleanup"
  - "Spawn protection: _invulnerable flag with guard in onCollisionStart() and Future.delayed timeout"

issues-created: []

# Metrics
duration: 7min
completed: 2026-02-13
---

# Plan 04-05: Smooth Animations and Transitions Summary

**Death slow-motion with player shrink/fade and entrance pop-in animation with elastic bounce and spawn protection**

## Performance

- **Duration:** 7 min
- **Started:** 2026-02-13T23:30:14Z
- **Completed:** 2026-02-13T23:37:14Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Death sequence triggers 0.3x slow-motion for 0.5s while player shrinks to zero and fades out with easeIn curve
- Game start and restart show player pop-in with elasticOut bounce from scale 0 and opacity fade-in
- Brief 0.5s invulnerability window during entrance prevents unfair deaths from lingering obstacles
- All visual state properly cleaned up via resetVisuals() on restart — no stale effects persist

## Task Commits

Each task was committed atomically:

1. **Task 1: Add death sequence animation** - `ac3838a` (feat)
2. **Task 2: Add game start and restart entrance animations** - `6bcdca5` (feat)

**Plan metadata:** `pending` (docs: complete plan)

## Files Created/Modified
- `lib/game/pulse_game.dart` - Added _timeScale field, slow-motion in gameOver(), entrance calls in startGame/resetGame
- `lib/game/components/player.dart` - Added playDeathAnimation(), playEntranceAnimation(), resetVisuals(), _invulnerable flag
- `lib/game/config/game_config.dart` - Added death animation and entrance animation config constants

## Decisions Made
- Used manual `_timeScale` field on PulseGame multiplied against `dt` in `update()` rather than any Flame built-in — gives uniform control over all children and is simple to reset
- Implemented opacity fade manually via paint.color alpha interpolation because PolygonComponent does not have the HasPaint mixin required for OpacityEffect
- Extended pre-pause delay from 0.3s (shake duration) to 0.5s (slow-mo duration) to accommodate the full slow-motion window
- Used Curves.elasticOut for entrance (satisfying bounce) and Curves.easeIn for death (weighty feel)
- Invulnerability uses Future.delayed for simplicity — works because the game loop continues during entrance

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug Fix] Manual opacity fade instead of OpacityEffect**
- **Found during:** Task 1 (death animation)
- **Issue:** Plan specified OpacityEffect for death fade, but PolygonComponent (Player's base class) doesn't support OpacityEffect due to lacking HasPaint mixin
- **Fix:** Implemented manual paint alpha interpolation via timer in update(), same approach used for both death fade-out and entrance fade-in
- **Files modified:** lib/game/components/player.dart
- **Verification:** flutter analyze passes, build succeeds
- **Committed in:** ac3838a (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (1 bug fix), 0 deferred
**Impact on plan:** OpacityEffect workaround was necessary for correctness with PolygonComponent. No scope creep.

## Issues Encountered
None

## Next Phase Readiness
- All transition animations in place — death feels dramatic, restart feels snappy
- Zero-friction retry loop preserved (entrance is 0.3s, invulnerability clears at 0.5s)
- Ready for 04-06 (background pulse effect synced to gameplay rhythm)
- _timeScale pattern reusable for any future slow-motion effects (e.g., near-miss slow-mo)

---
*Phase: 04-visual-juice*
*Completed: 2026-02-13*
