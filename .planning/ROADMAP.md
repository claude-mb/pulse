# Roadmap: Pulse

## Overview

Build a minimalist rhythm-action mobile game from zero to published on both app stores. Start with the core feel (the thing that makes or breaks the game), layer on systems that create depth and replayability, then polish and ship. Every phase delivers something playable and testable.

## Domain Expertise

None

## Phases

- [x] **Phase 1: Foundation** - Flutter + Flame project setup, build configs, game shell
- [ ] **Phase 2: Core Game Loop** - Tap-to-dodge mechanic, player movement, collision detection
- [ ] **Phase 3: Obstacle System** - Procedural obstacle generation, patterns, escalating difficulty
- [ ] **Phase 4: Visual Juice** - Screen shake, particles, flash effects, geometric art style
- [ ] **Phase 5: Audio System** - Sound effects, ambient pulse, gameplay-tied audio feedback
- [ ] **Phase 6: Scoring & High Scores** - Score tracking, personal bests, local persistence
- [ ] **Phase 7: Progression & Unlockables** - Unlockable shapes, color themes, reward system
- [ ] **Phase 8: UI & Menus** - Main menu, game over screen, settings, navigation flow
- [ ] **Phase 9: Daily Challenge** - Seeded daily mode with unique patterns per day
- [ ] **Phase 10: App Store Ship** - Icons, splash screens, store metadata, release builds

## Phase Details

### Phase 1: Foundation
**Goal**: Working Flutter + Flame project that builds and runs on both Android and iOS with an empty game canvas
**Depends on**: Nothing (first phase)
**Research**: Likely (Flutter + Flame project setup, game loop architecture, Flame best practices)
**Research topics**: Flame engine setup patterns, Flutter game project structure, Flame GameWidget integration, target frame rate configuration
**Plans**: 5 plans

Plans:
- [x] 01-01: Flutter project scaffolding with Flame dependency and build verification
- [x] 01-02: Flame GameWidget integration and game loop skeleton
- [x] 01-03: Input handling system (tap detection, gesture processing)
- [x] 01-04: Game state management (playing, paused, game over, restart)
- [x] 01-05: Asset loading pipeline and screen scaling/responsive layout

### Phase 2: Core Game Loop
**Goal**: Playable prototype — a shape moves, player taps to dodge, collisions kill, instant restart
**Depends on**: Phase 1
**Research**: Unlikely (core game logic, collision math, internal patterns)
**Plans**: 5 plans

Plans:
- [x] 02-01: Player entity — shape rendering, position, tap-to-move/dodge mechanic
- [x] 02-02: Basic obstacle spawning and movement toward player
- [x] 02-03: Collision detection between player and obstacles
- [x] 02-04: Death + instant restart flow (zero friction retry loop)
- [x] 02-05: Timing window tuning and difficulty feel calibration

### Phase 3: Obstacle System
**Goal**: Procedurally generated obstacle patterns that escalate in difficulty over time
**Depends on**: Phase 2
**Research**: Unlikely (procedural generation, pattern design, internal logic)
**Plans**: 5 plans

Plans:
- [x] 03-01: Obstacle pattern library (single, double, alternating, wave)
- [x] 03-02: Pattern sequencer with weighted random selection
- [x] 03-03: Difficulty curve — speed and complexity escalation over time
- [x] 03-04: Gap calibration — ensuring patterns are always fair/survivable
- [x] 03-05: Pattern variety and rhythm — preventing repetitive sequences

### Phase 4: Visual Juice
**Goal**: Every interaction feels satisfying — screen shake, particles, flash, color, motion
**Depends on**: Phase 2
**Research**: Likely (Flame particle system API, effect composition patterns)
**Research topics**: Flame ParticleSystemComponent, custom particle behaviors, camera shake in Flame, color tween effects
**Plans**: 6 plans

Plans:
- [x] 04-01: Screen shake system (on death, near-miss, combo milestones)
- [x] 04-02: Particle effects (death explosion, trail particles, dodge sparkle)
- [x] 04-03: Flash and color feedback (hit flash, combo glow, danger tint)
- [x] 04-04: Geometric art style — player shapes, obstacle shapes, background
- [x] 04-05: Smooth animations and transitions (game start, death, restart)
- [x] 04-06: Background pulse effect synced to gameplay rhythm

### Phase 5: Audio System
**Goal**: Sound design that reinforces every action — taps, dodges, deaths, combos
**Depends on**: Phase 2
**Research**: Likely (Flutter/Flame audio libraries, low-latency audio playback)
**Research topics**: flame_audio package, AudioPool for low-latency SFX, background music loop, audio asset formats for mobile
**Plans**: 5 plans

Plans:
- [x] 05-01: Audio engine setup (flame_audio or alternative, asset loading)
- [x] 05-02: Core SFX — tap sound, dodge whoosh, death impact, restart chime
- [x] 05-03: Ambient background pulse/music loop
- [x] 05-04: Dynamic audio — combo escalation sounds, near-miss tension
- [x] 05-05: Audio settings (mute toggle, volume control, SFX/music separation)

### Phase 6: Scoring & High Scores
**Goal**: Score tracking that drives "one more try" — visible during gameplay, persisted locally
**Depends on**: Phase 2
**Research**: Unlikely (local storage, score calculation, internal logic)
**Plans**: 5 plans

Plans:
- [x] 06-01: Score calculation — distance/time survived, dodge bonuses, combo multiplier
- [x] 06-02: In-game score HUD (current score, current combo, best score indicator)
- [x] 06-03: Local high score persistence (shared_preferences or similar)
- [x] 06-04: New high score celebration (visual + audio fanfare)
- [x] 06-05: Score history and stats tracking (games played, best combo, total dodges)

### Phase 7: Progression & Unlockables
**Goal**: Reward system that gives long-term goals — unlock shapes and themes by playing
**Depends on**: Phase 6
**Research**: Unlikely (internal game logic, unlock conditions)
**Plans**: 5 plans

Plans:
- [x] 07-01: Progression currency/XP system (earned through gameplay)
- [x] 07-02: Unlockable player shapes (circle, triangle, hexagon, star, etc.)
- [x] 07-03: Unlockable color themes (palette swaps for entire game aesthetic)
- [x] 07-04: Unlock conditions and reward triggers (score milestones, games played)
- [x] 07-05: Collection/gallery screen showing owned and locked items

### Phase 8: UI & Menus
**Goal**: Complete navigation flow — title screen, game over, settings, all connected
**Depends on**: Phase 7
**Research**: Unlikely (Flutter navigation, UI patterns)
**Plans**: 5 plans

Plans:
- [x] 08-01: Main menu branding enhancement (animated title, high score, settings entry)
- [x] 08-02: Settings screen with audio controls and mute persistence
- [x] 08-03: Animated screen transitions for all overlays
- [x] 08-04: First-time tutorial/onboarding (minimal — tap instruction)
- [ ] 08-05: UI consistency pass and complete navigation flow verification

### Phase 9: Daily Challenge
**Goal**: Seeded daily mode that gives players a reason to come back every day
**Depends on**: Phase 3, Phase 6
**Research**: Unlikely (seeded RNG, date-based seeds, internal logic)
**Plans**: 5 plans

Plans:
- [ ] 09-01: Seeded random number generator (date-based seed for consistent daily patterns)
- [ ] 09-02: Daily challenge obstacle sequence generation from seed
- [ ] 09-03: Daily challenge game mode with distinct UI indicator
- [ ] 09-04: Daily best score tracking (separate from endless mode)
- [ ] 09-05: Daily challenge entry point and streak tracking

### Phase 10: App Store Ship
**Goal**: Published on Google Play Store and Apple App Store
**Depends on**: All previous phases
**Research**: Likely (Store submission requirements, Flutter release build configuration)
**Research topics**: Flutter build for release (Android AAB, iOS archive), App Store Connect setup, Google Play Console setup, app signing, store listing requirements, privacy policy requirements
**Plans**: 6 plans

Plans:
- [ ] 10-01: App icon and splash screen design (geometric style matching game)
- [ ] 10-02: Android release build — signing, AAB generation, ProGuard config
- [ ] 10-03: iOS release build — signing, archive, provisioning profiles
- [ ] 10-04: Store listing assets — screenshots, description, keywords, categories
- [ ] 10-05: Privacy policy and required legal pages
- [ ] 10-06: Store submission — Google Play and App Store Connect upload

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 5/5 | Complete | 2026-02-11 |
| 2. Core Game Loop | 5/5 | Complete | 2026-02-11 |
| 3. Obstacle System | 5/5 | Complete | 2026-02-13 |
| 4. Visual Juice | 6/6 | Complete | 2026-02-14 |
| 5. Audio System | 5/5 | Complete | 2026-02-14 |
| 6. Scoring & High Scores | 5/5 | Complete | 2026-02-14 |
| 7. Progression & Unlockables | 5/5 | Complete | 2026-02-14 |
| 8. UI & Menus | 4/5 | In progress | - |
| 9. Daily Challenge | 0/5 | Not started | - |
| 10. App Store Ship | 0/6 | Not started | - |
