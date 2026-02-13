# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-10)

**Core value:** The gameplay feel — buttery smooth controls, tight timing windows, and satisfying feedback that makes every tap feel perfect.
**Current focus:** Phase 4 in progress — Visual Juice (screen shake complete)

## Current Position

Phase: 4 of 10 (Visual Juice)
Plan: 1 of 6 in current phase
Status: In progress
Last activity: 2026-02-13 — Completed 04-01-PLAN.md

Progress: ████▓░░░░░ 30%

## Performance Metrics

**Velocity:**
- Total plans completed: 16
- Average duration: 9 min
- Total execution time: 2.5 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1. Foundation | 5/5 | 67 min | 13 min |
| 2. Core Game Loop | 5/5 | 20 min | 4 min |
| 3. Obstacle System | 5/5 | 57 min | 11 min |
| 4. Visual Juice | 1/6 | 9 min | 9 min |

**Recent Trend:**
- Last 5 plans: 03-02 (36 min), 03-03 (4 min), 03-04 (6 min), 03-05 (5 min), 04-01 (9 min)
- Trend: Consistent execution, back to normal after 03-02 outlier

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

| Phase | Decision | Rationale |
|-------|----------|-----------|
| 01-01 | Flutter SDK installed to C:/flutter | Was not pre-installed; cloned stable branch |
| 01-01 | Let pub resolve latest Flame versions | Avoid version pinning issues early |
| 01-02 | CameraComponent.withFixedResolution(400x800) via constructor | Cleaner initialization than creating in onLoad |
| 01-02 | GameWidget.controlled(gameFactory:) modern pattern | Avoids deprecated instance passing |
| 01-03 | World-level TapCallbacks instead of game-level | Game-level gives canvas coords not world coords under fixed-resolution camera |
| 01-03 | CircleComponent for TapIndicator | Built-in circle rendering, cleaner than raw PositionComponent |
| 01-04 | Simple enum + methods for game state | No external library needed; sufficient for game flow |
| 01-04 | HUD transparent Stack with Positioned children | Game canvas remains visible and tappable behind HUD |
| 01-05 | GameConfig static const class with private constructor | Simple centralized config, no DI overhead needed |
| 01-05 | Placeholder player/obstacle values in GameConfig | Will be tuned in Phase 2-3 when features exist |
| 02-01 | Diamond/rhombus shape via canvas.drawPath | Geometric, game-like aesthetic matching art style |
| 02-01 | MoveEffect.to() with 0.1s for dodge animation | Snappy responsive feel, cancel-before-add pattern |
| 02-02 | Subtract-not-zero timer accumulator | Preserves timing accuracy across variable frame rates |
| 02-03 | 80% player hitbox, passive obstacle hitboxes | Near-miss fairness + performance optimization |
| 02-05 | obstacleSpeed 280, spawnInterval 1.1s | Urgent but fair feel for core loop |
| 02-05 | Anti-clustering: attempt-based with fallback | Prevents impossible obstacle overlap sequences |
| 03-01 | normalizedX (0-1) for pattern placement | Decouples patterns from absolute pixel positions |
| 03-01 | Static factory methods per pattern with Random | Procedural variation, consistent project style |
| 03-02 | Generate-then-filter for difficulty gating | Simpler than maintaining eligible pattern lists |
| 03-02 | Obstacle speed as instance field | Prepares for difficulty scaling without changing behavior |
| 03-03 | Smooth lerp between difficulty thresholds | Gradual ramp, no sudden jumps |
| 03-03 | Speed primary, patterns secondary escalation | Players feel speed increase before harder patterns |
| 03-04 | 55px minimum survivable gap | 32px hitbox + 23px dodge tolerance |
| 03-04 | Validated generation with retry/fallback | Prevents impossible layouts, max 5 attempts |
| 03-05 | History-based weight penalties (0.3x) for recent patterns | Keeps randomness while reducing repetition |
| 03-05 | Randomized intense threshold (4-6) for rhythm | Prevents predictable breather timing |
| 03-05 | Breather: simple patterns + 1.3x interval | Double relief: easier patterns AND slower spawning |
| 04-01 | Manual per-frame random offsets for ScreenShake | Jitter needs non-deterministic control, not tweened MoveEffect |
| 04-01 | Future.delayed with state guard for death pause | Shake must play out before game freezes; guard prevents stale pause |
| 04-01 | Near-miss threshold 70px center-to-center | Triggers often with 80% hitbox, feels rewarding without being spammy |

### Deferred Issues

None yet.

### Blockers/Concerns

- Flutter SDK at C:/flutter is not in system PATH — must use full path `C:/flutter/bin/flutter` or add to PATH before sessions

## Session Continuity

Last session: 2026-02-13
Stopped at: Completed 04-01-PLAN.md — Screen shake system done, Phase 4 in progress
Resume file: None
