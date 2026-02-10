# Pulse

## What This Is

A minimalist rhythm-action mobile game for Android and iOS. A shape moves along a path and the player taps to dodge obstacles with precise timing. Clean geometric visuals, escalating difficulty, and instant restarts create a "one more try" addiction loop.

## Core Value

The gameplay feel — buttery smooth controls, tight timing windows, and satisfying feedback that makes every tap feel perfect. If the moment-to-moment gameplay doesn't feel incredible, nothing else matters.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Core tap-to-dodge gameplay with precise timing mechanics
- [ ] Procedurally escalating difficulty (speed, pattern complexity)
- [ ] Instant death + instant restart loop (zero friction retry)
- [ ] Clean geometric visual style with motion feedback (screen shake, particles, flash)
- [ ] Sound design tied to gameplay actions (tap sounds, hit feedback, ambient pulse)
- [ ] Score system with personal high score tracking
- [ ] Unlockable shapes/color themes as progression rewards
- [ ] Daily challenge mode with unique seed per day
- [ ] Published on Google Play Store and Apple App Store
- [ ] 60fps performance on mid-range devices

### Out of Scope

- Monetization (ads, IAP, subscriptions) — v1 is purely about gameplay, monetize after validating the game is worth playing
- Backend infrastructure — all data stored locally on device for v1
- Level editor / user-generated content — adds complexity without validating core loop
- Story mode / narrative — the gameplay IS the content

## Context

- Greenfield project, no existing codebase
- Cross-platform mobile game targeting both Android and iOS
- Inspiration: games like Flappy Bird, Geometry Dash, and Duet that prove simple mechanics + tight feel = massive engagement
- Must feel native and performant on both platforms
- The "juice" (visual/audio feedback) is as important as the mechanics — a tap that feels dead kills the game

## Constraints

- **Platform**: Android + iOS — must ship to Google Play Store and Apple App Store
- **Tech stack**: Flutter + Flame engine — single codebase, native performance, strong 2D game support
- **Performance**: 60fps minimum on mid-range devices — games that stutter lose players instantly
- **Art style**: Geometric/minimalist — achievable without dedicated artist, looks intentional not cheap

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Flutter + Flame engine | Single codebase for both platforms, strong 2D game performance, Dart is productive | — Pending |
| Minimalist geometric art style | Achievable without artist, ages well, performs well, looks intentional | — Pending |
| No monetization in v1 | Validate the game is fun before adding business model complexity | — Pending |
| Local-only data storage | No backend needed for v1, reduces complexity and cost | — Pending |

---
*Last updated: 2026-02-10 after initialization*
