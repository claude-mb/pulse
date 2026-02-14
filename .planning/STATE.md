# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-10)

**Core value:** The gameplay feel — buttery smooth controls, tight timing windows, and satisfying feedback that makes every tap feel perfect.
**Current focus:** Phase 4 complete — ready for Phase 5: Audio System

## Current Position

Phase: 4 of 10 (Visual Juice)
Plan: 6 of 6 in current phase
Status: Phase complete
Last activity: 2026-02-14 — Completed 04-06-PLAN.md

Progress: ████░░░░░░ 40%

## Performance Metrics

**Velocity:**
- Total plans completed: 21
- Average duration: 9 min
- Total execution time: 3.5 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1. Foundation | 5/5 | 67 min | 13 min |
| 2. Core Game Loop | 5/5 | 20 min | 4 min |
| 3. Obstacle System | 5/5 | 57 min | 11 min |
| 4. Visual Juice | 6/6 | 71 min | 12 min |

**Recent Trend:**
- Last 5 plans: 04-02 (6 min), 04-03 (6 min), 04-04 (8 min), 04-05 (7 min), 04-06 (35 min)
- Trend: 04-06 longer due to UAT checkpoint and visual tuning

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
| 04-02 | ComputedParticle for fading instead of PaintParticle | Simpler opacity calc, avoids saveLayer GPU cost |
| 04-02 | Diamond fragments for death, white circles for dodge | Match player shape aesthetic; high contrast sparkle on dark bg |
| 04-02 | Particle factory pattern: static create() returning ParticleSystemComponent | Reusable, consistent with project patterns |
| 04-03 | FlashOverlay at priority 100, DangerTint at priority -1 | Flash renders on top of everything; tint behind gameplay, above background |
| 04-03 | Danger tint derives opacity from speedMultiplier for smooth interpolation | Avoids discrete level jumps, smooth tension ramp |
| 04-03 | Opacity targets 0.0/0.02/0.05/0.08/0.12 across 5 levels | Intentionally very subtle — subconscious tension |
| 04-04 | Manual render() on Obstacle for fill + outline + highlight | Full control over multi-layer geometric drawing |
| 04-04 | Static Paint objects on Obstacle | Avoid per-frame allocation overhead |
| 04-04 | Grid scrolls at 15% of obstacle speed | Subtle parallax — noticeable but not distracting |
| 04-04 | Player glow via MaskFilter.blur on scaled diamond | Simple, performant glow with idle pulse animation |
| 04-04 | Pulse 1.2x-1.4x at 1.5Hz via sin wave | Subtle breathing — alive feel without conscious distraction |
| 04-05 | Manual _timeScale on PulseGame.update() for slow-motion | Uniform control over all children, simple reset |
| 04-05 | Manual paint alpha animation for PolygonComponent opacity | PolygonComponent lacks HasPaint mixin for OpacityEffect |
| 04-05 | Entrance invulnerability via Future.delayed (0.5s) | Prevents unfair deaths during pop-in animation |
| 04-05 | elasticOut for entrance, easeIn for death curves | Satisfying bounce on start, weighty feel on death |
| 04-06 | Pulse syncs to spawn interval via difficultyManager | Natural rhythm match, intensity scales with difficulty |
| 04-06 | Exponential decay kick (0.06 × 0.85/frame) | Sharp heartbeat on spawn that fades naturally |
| 04-06 | Grid tuned: 0xFF2A3050, opacity 0.5, 1.0px stroke | Original was invisible against background; UAT-driven fix |

### Deferred Issues

None yet.

### Blockers/Concerns

- Flutter SDK at C:/flutter is not in system PATH — must use full path `C:/flutter/bin/flutter` or add to PATH before sessions

## Session Continuity

Last session: 2026-02-14
Stopped at: Completed 04-06-PLAN.md — Phase 4: Visual Juice complete
Resume file: None
