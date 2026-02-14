---
phase: 06-scoring
plan: 01
subsystem: scoring
tags: [score, combo, near-miss, dodge, game-logic]

# Dependency graph
requires:
  - phase: 02-core-game-loop
    provides: survivalTime tracking, dodge mechanics, collision detection
  - phase: 04-visual-juice
    provides: near-miss detection at 70px threshold
provides:
  - ScoreManager component with score/combo/dodge/near-miss tracking
  - Scoring formula (time + dodge bonus + near-miss bonus × combo multiplier)
  - Score event system for HUD display
affects: [06-02-hud, 06-03-persistence, 06-04-celebration, 06-05-stats]

# Tech tracking
tech-stack:
  added: []
  patterns: [ScoreManager as world Component with HasGameReference]

key-files:
  created: [lib/game/managers/score_manager.dart]
  modified: [lib/game/config/game_config.dart, lib/game/pulse_game.dart, lib/game/components/player.dart, lib/game/components/obstacle.dart]

key-decisions:
  - "Combo multiplier formula: 1.0 + (combo × 0.1), capped at 3.0x"
  - "Score event display timer of 0.8s for HUD flash text"
  - "Time-based score accumulation via survivalTime delta tracking"

patterns-established:
  - "ScoreManager as Component following DifficultyManager pattern"
  - "Score event string + timer pattern for transient HUD messages"

issues-created: []

# Metrics
duration: 9min
completed: 2026-02-14
---

# Phase 6 Plan 1: Score Calculation Summary

**ScoreManager with time-based scoring, dodge/near-miss bonuses, and combo multiplier system capped at 3.0x**

## Performance

- **Duration:** 9 min
- **Started:** 2026-02-14T13:11:19Z
- **Completed:** 2026-02-14T13:20:28Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments
- ScoreManager component with full scoring formula (time + dodge + near-miss bonuses)
- Combo system incrementing on dodge and near-miss, multiplier capped at 3.0x
- Score event display system with 0.8s auto-clear timer for HUD integration
- Wired into game loop: dodge events from Player, near-miss events from Obstacle

## Task Commits

Each task was committed atomically:

1. **Task 1: Create ScoreManager with scoring formula and combo system** - `a5b95ff` (feat)
2. **Task 2: Wire ScoreManager into game loop and scoring events** - `bfda15f` (feat)

## Files Created/Modified
- `lib/game/managers/score_manager.dart` - New ScoreManager component with score/combo/dodge/near-miss tracking
- `lib/game/config/game_config.dart` - Added 6 scoring constants (scorePerSecond, dodgeBonus, nearMissBonus, maxComboMultiplier, comboMultiplierStep, scoreEventDisplayDuration)
- `lib/game/pulse_game.dart` - Added scoreManager field, creation in onLoad(), reset in startGame()/resetGame()
- `lib/game/components/player.dart` - Added scoreManager.addDodge() in dodgeLeft()/dodgeRight()
- `lib/game/components/obstacle.dart` - Added scoreManager.addNearMiss() in near-miss detection block

## Decisions Made
- Combo multiplier formula: 1.0 + (combo × 0.1), capped at 3.0x — smooth escalation rewarding sustained play
- Score event display timer 0.8s — long enough to read, short enough to not clutter
- Time score via survivalTime delta tracking — reuses existing timing infrastructure

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- ScoreManager fully functional, ready for HUD display in 06-02
- Score event system ready for score popup text
- All stats (totalDodges, totalNearMisses, bestCombo) available for 06-05

---
*Phase: 06-scoring*
*Completed: 2026-02-14*
