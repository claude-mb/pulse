---
phase: 07-progression
plan: 02
subsystem: progression
tags: [player-shape, polygon, unlockable, geometric]

# Dependency graph
requires:
  - phase: 07-progression
    provides: ProgressionRepository with selectedShapeId persistence
  - phase: 02-01
    provides: Player component with diamond PolygonComponent rendering
  - phase: 04-04
    provides: Player glow via MaskFilter.blur
provides:
  - PlayerShape model with 5 geometric shape definitions
  - Dynamic Player rendering for any shape
  - Shape selection persistence via ProgressionRepository
  - Shape-matched death particle fragments
affects: [07-03, 07-04, 07-05, 08-03]

# Tech tracking
tech-stack:
  added: []
  patterns: [PlayerShape model with vertices/path/center, shape-specific death particles]

key-files:
  created: [lib/game/models/player_shape.dart]
  modified: [lib/game/components/player.dart, lib/game/pulse_game.dart, lib/game/effects/death_particles.dart]

key-decisions:
  - "PolygonComponent keeps diamond vertices for sizing; actual shape rendered via custom render() using _shapePath"
  - "Star shape generated via trigonometry: 5 outer (r=20) + 5 inner (r=9) vertices"
  - "Death particle fragments pre-computed per particle with shape-specific aspect ratios"

patterns-established:
  - "PlayerShape: model with vertices, computed path getter, computed center getter"
  - "PlayerShapes: static definitions class with all list and getById() lookup"

issues-created: []

# Metrics
duration: 5min
completed: 2026-02-14
---

# Phase 7 Plan 2: Unlockable Player Shapes Summary

**5 geometric player shapes (diamond, circle, triangle, hexagon, star) with dynamic rendering, selection persistence, and shape-matched death particles**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-14T15:19:44Z
- **Completed:** 2026-02-14T15:25:31Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- Created PlayerShape model with id, name, xpCost, vertices, computed path and center
- Defined 5 shapes: diamond (free), circle (500 XP), triangle (1500 XP), hexagon (3000 XP), star (5000 XP)
- Refactored Player to render any shape dynamically via custom render() with _shapePath
- Added applyShape() to PulseGame for runtime shape switching with persistence
- Death particles generate shape-specific 3-vertex fragments matching each shape's angular feel

## Task Commits

Each task was committed atomically:

1. **Task 1: Create PlayerShape model and shape definitions** - `495eea0` (feat)
2. **Task 2: Refactor Player for dynamic shapes with selection persistence** - `4307acf` (feat)

## Files Created/Modified
- `lib/game/models/player_shape.dart` - PlayerShape class + PlayerShapes static definitions (5 shapes)
- `lib/game/components/player.dart` - Dynamic shape rendering via _shapePath, updateShape() method
- `lib/game/pulse_game.dart` - applyShape() method for shape switching with persistence
- `lib/game/effects/death_particles.dart` - Shape-specific fragment generation per active shape

## Decisions Made
- PolygonComponent keeps diamond vertices for sizing; actual shape rendered via custom render() using _shapePath
- Star vertices generated with trigonometry (5 outer r=20, 5 inner r=9)
- Death particle fragments pre-computed per particle for performance

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Player shape system complete, ready for color themes (07-03)
- Shape selection works end-to-end, ready for gallery UI (07-05)
- Ready for 07-03-PLAN.md

---
*Phase: 07-progression*
*Completed: 2026-02-14*
