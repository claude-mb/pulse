---
phase: 02-core-game-loop
plan: 03
subsystem: collision
tags: [flame, collision-detection, hitbox, rectangle-hitbox, collision-callbacks]

# Dependency graph
requires:
  - phase: 02-core-game-loop (02-01, 02-02)
    provides: Player entity, Obstacle component
provides:
  - Collision detection between player and obstacles
  - Game over trigger on collision
  - Forgiving 80% player hitbox for near-miss feel
affects: [02-04-death-restart, 02-05-tuning, phase-4-visual-juice, phase-6-scoring]

# Tech tracking
tech-stack:
  added: []
  patterns: [active-passive-collision-types, forgiving-hitbox-sizing, state-guard-on-callbacks]

key-files:
  created: []
  modified: [lib/game/components/player.dart, lib/game/components/obstacle.dart]

key-decisions:
  - "80% player hitbox — near-misses feel fair and exciting"
  - "CollisionType.passive on obstacles — only player detects, better performance"
  - "State guard in onCollisionStart — prevents multiple gameOver calls"

patterns-established:
  - "Hitbox sizing: player forgiving (80%), threats full-size (100%)"
  - "Collision callback guard: check game.state before acting"

issues-created: []

# Metrics
duration: 3 min
completed: 2026-02-11
---

# Phase 2 Plan 3: Collision Detection Summary

**RectangleHitbox collision system with 80% forgiving player hitbox, passive obstacle hitboxes, and state-guarded gameOver trigger on collision**

## Performance

- **Duration:** 3 min
- **Started:** 2026-02-11T22:01:37Z
- **Completed:** 2026-02-11T22:04:47Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Player has 80% RectangleHitbox (active) — near-misses feel fair
- Obstacles have full-size RectangleHitbox (passive) — performance optimized
- Collision between player and obstacle triggers gameOver() cleanly
- State guard prevents multiple simultaneous collision callbacks

## Task Commits

1. **Task 1: Add collision hitboxes** - `325f6a7` (feat)
2. **Task 2: Implement collision callbacks** - `e32440f` (feat)

**Plan metadata:** (pending — docs commit)

## Files Created/Modified
- `lib/game/components/player.dart` - Added CollisionCallbacks mixin, 80% RectangleHitbox, onCollisionStart
- `lib/game/components/obstacle.dart` - Added passive RectangleHitbox

## Decisions Made
- 80% hitbox on player makes near-misses possible and exciting
- Passive collision type on obstacles prevents O(n^2) obstacle-obstacle checks
- State guard prevents race conditions with multiple simultaneous collisions

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Collision → death flow works — ready for clean restart (Plan 02-04)
- Ready for 02-04-PLAN.md

---
*Phase: 02-core-game-loop*
*Completed: 2026-02-11*
