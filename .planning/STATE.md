# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-10)

**Core value:** The gameplay feel — buttery smooth controls, tight timing windows, and satisfying feedback that makes every tap feel perfect.
**Current focus:** Phase 9 complete — ready for Phase 10

## Current Position

Phase: 9 of 10 (Daily Challenge)
Plan: 5 of 5 in current phase
Status: Phase 9 complete
Last activity: 2026-02-14 — Completed 09-05 (Phase 9 complete)

Progress: █████████░ 87%

## Performance Metrics

**Velocity:**
- Total plans completed: 46
- Average duration: 7 min
- Total execution time: 5.67 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1. Foundation | 5/5 | 67 min | 13 min |
| 2. Core Game Loop | 5/5 | 20 min | 4 min |
| 3. Obstacle System | 5/5 | 57 min | 11 min |
| 4. Visual Juice | 6/6 | 71 min | 12 min |
| 5. Audio System | 5/5 | 28 min | 6 min |
| 6. Scoring | 5/5 | 55 min | 11 min |
| 7. Progression | 5/5 | 20 min | 4 min |

| 8. UI & Menus | 5/5 | 27 min | 5 min |
| 9. Daily Challenge | 5/5 | 17 min | 3 min |

**Recent Trend:**
- Last 5 plans: 09-01 (3 min), 09-02 (3 min), 09-03 (2 min), 09-04 (3 min), 09-05 (6 min)
- Trend: Phase 9 complete at ~3 min/plan average

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
| 05-01 | Pure Dart WAV synthesis — no external audio tools | Keeps build reproducible and self-contained |
| 05-01 | AudioPool for dodge_whoosh and spawn_cue (maxPlayers: 4) | High-frequency SFX need low latency |
| 05-02 | Spawn cue at 0.4 volume, menu select at 0.5 for pause | Volume differentiation for ambient vs action feedback |
| 05-03 | 4.4s loop = 4 × 1.1s spawn intervals | Rhythmic alignment with obstacle spawning |
| 05-03 | Abrupt BGM stop on death, not fade | Silence after impact is more dramatic |
| 05-04 | Volume scaling via speedMultiplier lerp | Mirrors danger tint opacity approach |
| 05-04 | Pulse bass as 55Hz sub-layer on spawn | Felt more than heard, adds physical weight |
| 05-05 | Mute toggles only, no volume sliders for v1 | Simpler UX; sliders can come in Phase 8 |
| 05-05 | Track last-requested BGM for unmute resume | Seamless music toggle without losing track state |
| 07-01 | Milestone-based XP (never spent, only accumulated) | Avoids currency management complexity, forward progress feel |
| 07-01 | 1 XP per score point | Simple, predictable progression mapping |
| 07-01 | Teal accent (0xFF4ECDC4) for XP display | Distinct from score gold, visually separates progression |
| 07-02 | PolygonComponent keeps diamond vertices; render() uses _shapePath | Flame refreshVertices() requires same vertex count |
| 07-02 | Star shape via trigonometry (5 outer r=20, 5 inner r=9) | Programmatic generation for clean star points |
| 07-02 | Death particle fragments pre-computed per particle | Performance: avoid per-frame shape calculations |
| 07-03 | GameConfig color fields → getters delegating to activeTheme | Zero callsite changes, seamless theme switching |
| 07-03 | Non-themed colors (text, highscore, danger, XP) stay const | Universal meaning, shouldn't change per theme |
| 07-03 | refreshThemeColors() pattern on cached-paint components | Only needed for components that cache Paint objects |
| 07-04 | Synchronous xpAfter = xpBefore + earned | Avoids async timing issues with repo persistence |
| 07-04 | 500ms delay before unlock chime | Prevents overlap with death impact sound |
| 07-05 | Stack layout in MainMenu for COLLECTION button | Separate tap target from full-screen game-start |
| 07-05 | CustomPainter for shape previews at 30x30 | Efficient scaled rendering of vertex paths |
| 08-01 | SingleTickerProviderStateMixin for title pulse | Only one AnimationController needed |
| 08-01 | Glow as 68px text behind 64px title | Simple technique, no shader overhead |
| 08-01 | Placeholder SettingsScreen as separate widget | Clean separation, fully built in 08-02 |
| 08-02 | _galleryReturnTo field for dynamic gallery back-nav | Simple tracking of gallery origin without complex state |
| 08-02 | Fire-and-forget SharedPreferences for mute persistence | Matches ProgressionRepository pattern; no await needed for UX |
| 08-03 | 200ms fade for overlays, 300ms for GameOverScreen | Snappy transitions; dramatic death effect slightly slower |
| 08-03 | 100ms HUD delay on game start | Clean visual beat between menu removal and HUD appearance |
| 08-04 | Tutorial intercepts startGame() with _beginGameplay() extraction | Clean dual call path; no separate entry point needed |
| 08-04 | Fire-and-forget SharedPreferences for tutorial flag | Matches existing persistence patterns; no await needed |
| 08-05 | _settingsReturnTo mirrors _galleryReturnTo pattern | Consistent return-to tracking for settings origin |
| 08-05 | GestureDetector + HitTestBehavior.opaque for all buttons | Consistent pattern across all overlay screens |
| 09-01 | year*10000 + month*100 + day for daily seed | Unique integer per date, simple and deterministic |
| 09-01 | Optional seed parameter on ObstacleSpawner constructor/reset | Backward-compatible seeded RNG injection |
| 09-02 | DailyChallengeRepository singleton matching ScoreRepository | Consistent persistence pattern |
| 09-02 | Streak increments on first attempt of day only | Prevents multiple streak counts per day |
| 09-03 | Daily games dual-record to both repositories | Lifetime stats always accurate |
| 09-03 | returnToMenu() resets to endless mode | Explicit daily re-entry required |
| 09-04 | Nested GestureDetector for DAILY button | Prevents full-screen tap from starting endless |
| 09-04 | DAILY CHALLENGE label above HUD score | Clear mode identification during gameplay |
| 09-05 | DAILY CHALLENGE title at 32px on game over | Visual distinction from GAME OVER at 48px |
| 09-05 | Reuse _pulseController for NEW DAILY BEST | Consistent animation, minimal code duplication |

### Deferred Issues

None yet.

### Blockers/Concerns

- Flutter SDK at C:/flutter is not in system PATH — must use full path `C:/flutter/bin/flutter` or add to PATH before sessions

## Session Continuity

Last session: 2026-02-14
Stopped at: Phase 9 complete — ready for Phase 10 (App Store Ship)
Resume file: None
