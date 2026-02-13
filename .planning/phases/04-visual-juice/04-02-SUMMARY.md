---
phase: 04-visual-juice
plan: 02
subsystem: effects
tags: [flame, particles, death-explosion, dodge-sparkle, game-feel]

# Dependency graph
requires:
  - phase: 02-core-game-loop
    provides: Player component, game state management, dodge mechanics
  - phase: 04-visual-juice/01
    provides: Screen shake system, effects/ directory, death pause delay
provides:
  - DeathParticles factory: 18 diamond fragments bursting from player position on death
  - DodgeSparkle factory: 6 white circle sparkles drifting opposite to dodge direction
  - Particle config constants in GameConfig for tuning
affects: [04-visual-juice, 05-audio-system]

# Tech tracking
tech-stack:
  added: []
  patterns: [Particle.generate() with AcceleratedParticle + ComputedParticle composition, factory class with static create() method]

key-files:
  created: [lib/game/effects/death_particles.dart, lib/game/effects/dodge_sparkle.dart]
  modified: [lib/game/config/game_config.dart, lib/game/pulse_game.dart, lib/game/components/player.dart]

key-decisions:
  - "ComputedParticle for fading instead of PaintParticle — simpler, avoids saveLayer GPU cost"
  - "Diamond fragments for death particles matching player shape aesthetic"
  - "White circles for dodge sparkles — high contrast against dark background, subtle accent"
  - "Sparkle direction opposite to dodge for visual trail feel"

patterns-established:
  - "Particle factory pattern: static create() method returning ParticleSystemComponent"
  - "AcceleratedParticle wrapping ComputedParticle for physics + custom rendering"
  - "Opacity fade via (1.0 - particle.progress) in ComputedParticle renderer"

issues-created: []

# Metrics
duration: 6min
completed: 2026-02-13
---

# Plan 04-02: Particle Effects Summary

**Death explosion with 18 diamond fragments and dodge sparkle with 6 directional white circles using Flame's composable particle system**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-13T22:52:31Z
- **Completed:** 2026-02-13T22:58:31Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments
- DeathParticles factory creates 18 diamond-shaped fragments bursting outward from player position with random velocities, gravity, and fade-out
- DodgeSparkle factory creates 6 subtle white circles drifting opposite to dodge direction with quick fade
- Both effects use Particle.generate() with AcceleratedParticle + ComputedParticle composition pattern
- ParticleSystemComponent auto-removes when particles expire — no manual cleanup needed

## Task Commits

Each task was committed atomically:

1. **Task 1: Create death explosion particle effect** - `04062a0` (feat)
2. **Task 2: Create dodge sparkle particle effect** - `afa64e3` (feat)

**Plan metadata:** `pending` (docs: complete plan)

## Files Created/Modified
- `lib/game/effects/death_particles.dart` - Factory creating death explosion burst of diamond fragments
- `lib/game/effects/dodge_sparkle.dart` - Factory creating directional dodge sparkle circles
- `lib/game/config/game_config.dart` - Added death particle and dodge sparkle config constants
- `lib/game/pulse_game.dart` - Added DeathParticles.create() call in gameOver()
- `lib/game/components/player.dart` - Added DodgeSparkle.create() calls in dodgeLeft() and dodgeRight()

## Decisions Made
- Used ComputedParticle for fade rendering instead of PaintParticle — avoids canvas.saveLayer GPU cost, simpler opacity calculation via particle.progress
- Diamond-shaped fragments for death particles to match the player's diamond shape aesthetic
- White circles for dodge sparkles to provide high contrast against the dark background without overwhelming the action
- Sparkles drift opposite to dodge direction for a natural visual trail feel

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- Particle factory pattern established — reusable for any future particle effects
- effects/ directory now has screen_shake, death_particles, and dodge_sparkle
- Ready for 04-03 (flash and color feedback)
- Death particles animate during the 0.3s pre-pause window (from 04-01), then freeze as a dramatic frame

---
*Phase: 04-visual-juice*
*Completed: 2026-02-13*
