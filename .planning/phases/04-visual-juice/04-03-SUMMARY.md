---
phase: 04-visual-juice
plan: 03
subsystem: effects
tags: [flame, flash-overlay, danger-tint, color-feedback, game-feel]

# Dependency graph
requires:
  - phase: 02-core-game-loop
    provides: Player component, game state management, game over flow
  - phase: 04-visual-juice/01
    provides: Screen shake system, death pause delay (0.3s window)
  - phase: 04-visual-juice/02
    provides: Death particles, effects/ directory, particle factory pattern
  - phase: 03-obstacle-system
    provides: DifficultyManager with 5 levels and speed multiplier
provides:
  - FlashOverlay: full-screen white flash on death that fades out in 0.25s
  - DangerTint: persistent overlay that subtly shifts red as difficulty increases
  - Flash and tint config constants in GameConfig
affects: [04-visual-juice, 05-audio-system]

# Tech tracking
tech-stack:
  added: []
  patterns: [RectangleComponent with OpacityEffect for flash, RectangleComponent with per-frame opacity update for tint]

key-files:
  created: [lib/game/effects/flash_overlay.dart, lib/game/components/danger_tint.dart]
  modified: [lib/game/config/game_config.dart, lib/game/pulse_game.dart]

key-decisions:
  - "FlashOverlay at priority 100 renders on top of everything for maximum impact"
  - "DangerTint at priority -1 renders behind gameplay but above background"
  - "Danger tint derives progress from speedMultiplier for smooth interpolation"
  - "Opacity targets: 0.0/0.02/0.05/0.08/0.12 across 5 levels — intentionally very subtle"

patterns-established:
  - "Full-screen overlay pattern: RectangleComponent sized to world dimensions at position zero"
  - "Flash effect: set initial opacity then OpacityEffect.fadeOut with onComplete removeFromParent"
  - "Continuous tint: persistent component reading game state in update() to adjust opacity"

issues-created: []

# Metrics
duration: 6min
completed: 2026-02-13
---

# Plan 04-03: Flash and Color Feedback Summary

**Full-screen death flash overlay with 0.25s fade-out and difficulty-responsive danger tint that scales from invisible to subtle red across 5 levels**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-13T23:04:04Z
- **Completed:** 2026-02-13T23:10:04Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- FlashOverlay component: full-screen white rectangle at 0.7 opacity that fades out in 0.25s on death, auto-removes when complete
- DangerTint component: persistent overlay using difficulty speed multiplier for smooth opacity interpolation (0.0 to 0.12)
- Both effects are additive with existing shake and particles — flash fires simultaneously in gameOver()
- Config constants added for all tunable parameters (flash duration, opacity, tint color, max opacity)

## Task Commits

Each task was committed atomically:

1. **Task 1: Create death flash overlay effect** - `d4ed7ef` (feat)
2. **Task 2: Create difficulty danger tint overlay** - `1b6f251` (feat)

**Plan metadata:** `pending` (docs: complete plan)

## Files Created/Modified
- `lib/game/effects/flash_overlay.dart` - Full-screen white flash that fades out on death
- `lib/game/components/danger_tint.dart` - Persistent red tint overlay scaling with difficulty
- `lib/game/config/game_config.dart` - Added flash and danger tint config constants
- `lib/game/pulse_game.dart` - Wired FlashOverlay into gameOver(), DangerTint into onLoad()

## Decisions Made
- FlashOverlay at priority 100 to render on top of all game components including particles
- DangerTint at priority -1 to render behind obstacles and player but above the background color
- Derived tint opacity from speedMultiplier rather than discrete level checks for smooth interpolation between levels
- Opacity targets (0.0, 0.02, 0.05, 0.08, 0.12) are intentionally very subtle — players feel tension without consciously noticing the red shift

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Flash and tint effects complete — all death feedback layers now in place (shake + particles + flash)
- DangerTint provides ambient tension escalation throughout gameplay
- Ready for 04-04 (geometric art style)
- effects/ directory now has screen_shake, death_particles, dodge_sparkle, and flash_overlay

---
*Phase: 04-visual-juice*
*Completed: 2026-02-13*
