---
phase: 01-foundation
plan: 03
subsystem: input
tags: [flame, tap-callbacks, effects, position-component, input-handling]

# Dependency graph
requires:
  - phase: 01-02
    provides: FlameGame shell with CameraComponent and World
provides:
  - Tap detection pipeline (world-level TapCallbacks)
  - TapIndicator visual feedback component
  - Input-to-world coordinate mapping pattern
affects: [core-game-loop, player-entity, ui-menus]

# Tech tracking
tech-stack:
  added: []
  patterns: [world-level-tap-handler, flame-effects-for-animation, auto-removing-components]

key-files:
  created: [lib/game/components/tap_indicator.dart]
  modified: [lib/game/pulse_game.dart, lib/main.dart]

key-decisions:
  - "World-level TapCallbacks instead of game-level: game-level gives canvas coords, not world coords under CameraComponent.withFixedResolution"
  - "CircleComponent instead of raw PositionComponent for TapIndicator: built-in circle rendering, still a PositionComponent subclass"

patterns-established:
  - "World-level tap handling: add Component with TapCallbacks + containsLocalPoint=>true to world for correct coordinate space"
  - "Auto-removing effects: OpacityEffect.fadeOut with onComplete: removeFromParent for self-cleaning components"

issues-created: []

# Metrics
duration: 25min
completed: 2026-02-11
---

# Phase 1 Plan 3: Input Handling Summary

**Tap detection with world-level TapCallbacks, animated CircleComponent indicator using OpacityEffect fade-out**

## Performance

- **Duration:** 25 min
- **Started:** 2026-02-11T20:58:40Z
- **Completed:** 2026-02-11T21:23:49Z
- **Tasks:** 1 auto + 1 checkpoint (verified)
- **Files modified:** 3

## Accomplishments
- Tap detection pipeline proven end-to-end: tap -> world position -> visual feedback -> cleanup
- TapIndicator component using Flame's built-in Effects system (OpacityEffect.fadeOut)
- World-level tap handler with correct coordinate mapping under fixed-resolution camera
- MainMenu overlay made dismissible (tap to start)

## Task Commits

Each task was committed atomically:

1. **Task 1: Add tap detection and visual tap indicator** - `deb09a1` (feat)

**Plan metadata:** (next commit)

## Files Created/Modified
- `lib/game/components/tap_indicator.dart` - CircleComponent with fade-out animation, auto-removes on completion
- `lib/game/pulse_game.dart` - Added _WorldTapHandler to world for tap detection in world coordinates
- `lib/main.dart` - MainMenu overlay now tappable to dismiss (GestureDetector wrapping)

## Decisions Made
- **World-level TapCallbacks over game-level:** Game-level TapCallbacks on FlameGame gives canvas/screen coordinates, which don't match world coordinates under CameraComponent.withFixedResolution(400x800). World-level component receives events already transformed to world space. Phase 2 will move input to Player entity's TapCallbacks.
- **CircleComponent over raw PositionComponent:** Built-in circle rendering is cleaner than manual canvas drawing. CircleComponent extends ShapeComponent extends PositionComponent, so all APIs (anchor, effects) work identically.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed coordinate space mismatch for tap positions**
- **Found during:** Task 1 verification (checkpoint)
- **Issue:** Game-level TapCallbacks on FlameGame provides event.localPosition in canvas coordinates, not world coordinates. With CameraComponent.withFixedResolution(400x800), world origin (0,0) is at viewport center, so indicators appeared far offset from tap location.
- **Fix:** Replaced game-level TapCallbacks with a world-level _WorldTapHandler component that receives events already in world coordinates. containsLocalPoint returns true to catch all taps.
- **Files modified:** lib/game/pulse_game.dart
- **Verification:** Visual verification — indicators now appear exactly at tap/click position
- **Committed in:** deb09a1

**2. [Rule 3 - Blocking] Made MainMenu overlay dismissible**
- **Found during:** Task 1 verification (checkpoint)
- **Issue:** MainMenu overlay was a full-screen Container with no tap handler — absorbed all pointer events, preventing any taps from reaching the game canvas. Could not verify tap detection.
- **Fix:** Wrapped MainMenu overlay in GestureDetector that removes the overlay on tap. Changed text to "Tap to Start".
- **Files modified:** lib/main.dart
- **Verification:** Tapping overlay dismisses it, game canvas receives subsequent taps
- **Committed in:** deb09a1

---

**Total deviations:** 2 auto-fixed (1 bug, 1 blocking), 0 deferred
**Impact on plan:** Both fixes necessary for correct input handling and testability. No scope creep.

## Issues Encountered
None beyond the deviations documented above.

## Next Phase Readiness
- Input pipeline proven: tap -> world position -> visual feedback -> cleanup
- Pattern established for Phase 2: component-level TapCallbacks on Player entity
- Ready for 01-04-PLAN.md (Game state management)

---
*Phase: 01-foundation*
*Completed: 2026-02-11*
