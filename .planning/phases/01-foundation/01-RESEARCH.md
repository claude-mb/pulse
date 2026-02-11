# Phase 1: Foundation - Research

**Researched:** 2026-02-10
**Domain:** Flutter + Flame engine for 2D mobile game development
**Confidence:** HIGH

<research_summary>
## Summary

Researched the Flutter Flame engine ecosystem for building a minimalist 2D rhythm-action mobile game. Flame v1.35.0 is the current stable release with a mature component system, built-in collision detection, effects, particles, overlays, and a rich ecosystem of 37+ packages.

The standard approach is: FlameGame as the base class, Component tree (FCS) for game entities, Overlays for Flutter UI (menus/HUD), RouterComponent for screen navigation, CameraComponent.withFixedResolution() for consistent layout across devices, and flame_audio for sound.

Flame is confirmed as the right choice for this game type. Benchmarks show it handles ~1800 entities at 60fps on mobile — more than sufficient for our minimal-entity rhythm game. It excels at hyper-casual and 2D arcade games, which is exactly our use case.

**Primary recommendation:** Use FlameGame + Component tree architecture. Use Overlays for all UI (menus, HUD, pause). Use CameraComponent.withFixedResolution() for responsive layout. Do NOT hand-roll collision detection, effects, or particles — Flame's built-ins are comprehensive.
</research_summary>

<standard_stack>
## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flame | 1.35.0 | Core 2D game engine | The standard for Flutter games. Component system, effects, particles, collision, input |
| flutter | 3.x | App framework | Cross-platform foundation, widget tree for UI |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flame_audio | 2.11.13 | Audio (SFX + music) | All sound: tap sounds, ambient pulse, death effects |
| shared_preferences | latest | Local key-value storage | High scores, unlocks, settings persistence |
| flame_bloc | 1.12.20 | State management bridge | If game state grows complex (progression, unlocks) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| flame_audio | audioplayers directly | flame_audio wraps audioplayers with game-friendly API, use it |
| flame_bloc | flame_riverpod | Both work; Bloc is simpler for game state, Riverpod for complex DI |
| flame_forge2d | Built-in collision | Forge2D overkill for our game; built-in collision detection sufficient |

**Installation:**
```bash
flutter create pulse_game
cd pulse_game
flutter pub add flame flame_audio
```
</standard_stack>

<architecture_patterns>
## Architecture Patterns

### Recommended Project Structure
```
lib/
├── main.dart                    # App entry, MaterialApp + GameWidget
├── game/
│   ├── pulse_game.dart          # FlameGame subclass (main game class)
│   ├── components/
│   │   ├── player.dart          # Player shape component
│   │   ├── obstacle.dart        # Obstacle component
│   │   └── background.dart      # Background/parallax
│   ├── effects/
│   │   ├── screen_shake.dart    # Camera shake effect
│   │   └── death_effect.dart    # Death particles/flash
│   ├── managers/
│   │   ├── obstacle_manager.dart # Spawning + difficulty
│   │   └── score_manager.dart   # Score tracking
│   └── config/
│       └── game_config.dart     # Constants, tuning values
├── screens/
│   ├── main_menu.dart           # Flutter widget (overlay)
│   ├── game_over.dart           # Flutter widget (overlay)
│   └── settings.dart            # Flutter widget (overlay)
└── utils/
    └── audio_manager.dart       # Audio loading + playback
assets/
├── audio/                       # SFX and music files
└── images/                      # Sprites (if any)
```

### Pattern 1: FlameGame + GameWidget Integration
**What:** FlameGame is the base class providing world, camera, component tree, collision detection, and game loop.
**When to use:** Always — this is the standard entry point.
**Example:**
```dart
// Source: https://docs.flame-engine.org/latest/flame/game.html
class PulseGame extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    // Set fixed resolution for consistent layout across devices
    camera = CameraComponent.withFixedResolution(width: 400, height: 800);

    // Add game components to world
    world.add(Player());
    world.add(ObstacleManager());

    // Add screen boundary detection
    world.add(ScreenHitbox());
  }
}

// In main.dart:
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget<PulseGame>.controlled(
          gameFactory: PulseGame.new,
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenuWidget(game: game),
            'GameOver': (context, game) => GameOverWidget(game: game),
            'HUD': (context, game) => HudWidget(game: game),
            'Pause': (context, game) => PauseWidget(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    ),
  );
}
```

### Pattern 2: Component Lifecycle
**What:** Components have async onLoad → onMount → update/render → onRemove lifecycle.
**When to use:** Every game entity.
**Key details:**
- `onLoad()` — async, runs once. Load assets here.
- `onMount()` — runs each time added to tree. Do NOT init `late final` here.
- `update(double dt)` — every tick. Game logic here.
- `render(Canvas canvas)` — every frame. Drawing here.
- `onRemove()` — cleanup.

### Pattern 3: Overlay System for UI
**What:** Standard Flutter widgets rendered on top of the Flame game canvas. Toggled via `game.overlays.add/remove`.
**When to use:** All menus, HUD, pause screen, game over screen.
**Why:** Full power of Flutter UI (animations, layout, styling) without fighting the game canvas.
```dart
// From game code:
overlays.add('GameOver');
overlays.remove('HUD');

// From overlay widget:
game.overlays.remove('GameOver');
game.reset();
```

### Pattern 4: RouterComponent for Screen Navigation
**What:** Built-in route stack with opaque/transparent routes, WorldRoute for level switching, OverlayRoute for overlay management.
**When to use:** Alternative to manual overlay management for complex screen flows.
**Details:**
- Routes addressed by unique names
- Opaque routes block rendering below, transparent routes don't
- `maintainState: false` to rebuild on each visit

### Pattern 5: Fixed Resolution Camera
**What:** CameraComponent.withFixedResolution() creates a virtual resolution with automatic letterboxing.
**When to use:** Our game — ensures consistent gameplay across all screen sizes.
```dart
camera = CameraComponent.withFixedResolution(width: 400, height: 800);
```

### Anti-Patterns to Avoid
- **Don't mix game-level gesture detectors with component-level input** — pick one approach
- **Don't nest BodyComponents as children** in flame_forge2d (must be at world level)
- **Don't use onMount for late final initialization** — it can run multiple times
- **Don't create components in the render loop** — create once, update transforms
- **Don't ignore CollisionType** — set passive/inactive for non-interactive objects
</architecture_patterns>

<dont_hand_roll>
## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Collision detection | Custom distance/overlap math | HasCollisionDetection + ShapeHitbox | Built-in broadphase (sweep-and-prune or QuadTree), handles edge cases, callbacks for start/during/end |
| Screen shake | Manual camera offset math | Effects system (MoveByEffect with alternating controller) | EffectController handles timing, easing, infinite/repeat |
| Particle explosions | Custom particle rendering loop | ParticleSystemComponent + AcceleratedParticle/CircleParticle | Automatic lifespan, composition, cleanup. 10+ particle types built in |
| Component animations | Manual property tweening | MoveEffect, ScaleEffect, RotateEffect, OpacityEffect, SequenceEffect | Full easing curves, chaining, repeat, alternate. EffectController is very flexible |
| Screen management | Custom state machine for screens | Overlays (for Flutter UI) or RouterComponent (for game screens) | Built-in show/hide/toggle, opaque/transparent, state preservation |
| Audio playback | Raw audioplayers calls | flame_audio (FlameAudio.play, FlameAudio.bgm) | Wraps audioplayers with game-friendly API, bgm management |
| Screen boundary detection | Manual bounds checking | ScreenHitbox component | Automatically represents viewport edges, integrates with collision system |
| Input handling | Raw gesture detectors | TapCallbacks, DragCallbacks mixins on components | Automatic hit testing via containsLocalPoint, event propagation, multi-touch |

**Key insight:** Flame's built-in effects system alone covers 80% of the "juice" we need. MoveEffect + ScaleEffect + OpacityEffect + SequenceEffect + EffectController with curves = screen shake, death animations, spawn animations, combo feedback. Don't write custom animation loops.
</dont_hand_roll>

<common_pitfalls>
## Common Pitfalls

### Pitfall 1: Tunneling (Fast Objects Through Walls)
**What goes wrong:** Fast-moving obstacles pass through the player without triggering collision.
**Why it happens:** Default collision detection checks positions per frame — at high speeds, objects skip past each other.
**How to avoid:** Keep obstacle speed reasonable relative to hitbox sizes. Use larger hitboxes if needed. Consider checking collision manually for critical fast objects.
**Warning signs:** Player "dies" after obstacle visually passes them, or obstacles pass through without any collision.

### Pitfall 2: Using onMount for Late Final Initialization
**What goes wrong:** `late final` variable initialized in onMount throws on second mount.
**Why it happens:** onMount runs EVERY time a component joins the tree, not just the first time. If a component is removed and re-added, onMount fires again.
**How to avoid:** Use onLoad() for one-time initialization. Use onMount() only for things that genuinely need to happen each time (re-subscribing to events).
**Warning signs:** Crash on game restart or scene transition with "late final already initialized" error.

### Pitfall 3: GameWidget Doesn't Clip Canvas
**What goes wrong:** Game content renders outside the GameWidget boundaries.
**Why it happens:** GameWidget does NOT clip by default.
**How to avoid:** Wrap GameWidget in `ClipRect` if it's not fullscreen.
**Warning signs:** Game elements visible outside game area when embedded in other Flutter widgets.

### Pitfall 4: Hollow Hitboxes by Default
**What goes wrong:** A small object inside a larger object doesn't trigger collision.
**Why it happens:** All hitboxes are hollow by default — one can be fully enclosed by another without collision.
**How to avoid:** Set `isSolid = true` on hitboxes where enclosed collisions matter.
**Warning signs:** Player inside an obstacle boundary but no collision callback fires.

### Pitfall 5: Performance Death from Too Many Active Colliders
**What goes wrong:** Frame rate drops as obstacles accumulate.
**Why it happens:** Every active collider is checked against every other active collider. O(n²) without optimization.
**How to avoid:** Set `CollisionType.passive` on obstacles (they don't need to check each other). Remove off-screen components promptly. Use QuadTree broadphase if entity count exceeds ~100.
**Warning signs:** FPS drops correlate with obstacle count, not visual complexity.

### Pitfall 6: Memory Leaks from Unremoved Components
**What goes wrong:** Memory grows over time as the game runs.
**Why it happens:** Obstacles/particles that move off-screen are never removed from the component tree.
**How to avoid:** Use RemoveEffect for timed removal. Check bounds in update() and call removeFromParent(). ScreenHitbox can detect when objects leave the viewport.
**Warning signs:** Increasing memory usage over long play sessions, gradual FPS degradation.
</common_pitfalls>

<code_examples>
## Code Examples

### FlameGame with Fixed Resolution and Overlays
```dart
// Source: https://docs.flame-engine.org/latest/flame/game.html
// Source: https://docs.flame-engine.org/latest/flame/game_widget.html
class PulseGame extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    camera = CameraComponent.withFixedResolution(width: 400, height: 800);
    world.add(ScreenHitbox());
  }

  void startGame() {
    overlays.remove('MainMenu');
    overlays.add('HUD');
    // Add game components...
  }

  void gameOver(int score) {
    overlays.remove('HUD');
    overlays.add('GameOver');
  }
}
```

### Component with Collision and Input
```dart
// Source: https://docs.flame-engine.org/latest/flame/collision_detection.html
// Source: https://docs.flame-engine.org/latest/flame/inputs/tap_events.html
class Player extends PositionComponent
    with CollisionCallbacks, TapCallbacks, HasGameReference<PulseGame> {

  @override
  Future<void> onLoad() async {
    size = Vector2(40, 40);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Dodge mechanic
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Obstacle) {
      game.gameOver(score);
    }
  }
}
```

### Effects Composition (Screen Shake + Death Animation)
```dart
// Source: https://docs.flame-engine.org/latest/flame/effects.html
// Screen shake via camera viewfinder
camera.viewfinder.add(
  MoveByEffect(
    Vector2(5, 5),
    EffectController(
      duration: 0.05,
      alternate: true,
      repeatCount: 5,
    ),
  ),
);

// Death explosion particles
game.world.add(ParticleSystemComponent(
  particle: Particle.generate(
    count: 20,
    lifespan: 0.8,
    generator: (i) => AcceleratedParticle(
      position: deathPosition.clone(),
      speed: Vector2(
        random.nextDouble() * 200 - 100,
        random.nextDouble() * 200 - 100,
      ),
      acceleration: Vector2(0, 200),
      child: CircleParticle(
        radius: 3.0,
        paint: Paint()..color = Colors.white,
      ),
    ),
  ),
));
```

### Obstacle with Passive Collision
```dart
// Source: https://docs.flame-engine.org/latest/flame/collision_detection.html
class Obstacle extends PositionComponent with CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    size = Vector2(60, 20);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    // Remove when off screen
    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }
}
```
</code_examples>

<sota_updates>
## State of the Art (2025-2026)

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual camera system | CameraComponent + World architecture | Flame 1.x | Proper viewport, fixed resolution, camera following, visibleWorldRect culling |
| HasGameRef mixin | HasGameReference<T> mixin | Recent | Typed game reference, deprecated old mixin |
| Manual screen management | RouterComponent + Overlays | Flame 1.x | Built-in route stack, opaque/transparent routes, WorldRoute, OverlayRoute |
| Custom animation tweening | Built-in Effects system | Flame 1.x | 15+ effect types with flexible EffectController (curves, repeat, alternate, sequence) |
| flame_oxygen (ECS) | Standard Component tree (FCS) | Ongoing | FCS is the recommended approach; flame_oxygen exists but is niche |

**New tools/patterns to consider:**
- **QuadTree broadphase**: Alternative collision broadphase for 100+ entities. Use `HasQuadTreeCollisionDetection` mixin.
- **flame_behaviors**: Entity/Behavior pattern for clean separation of concerns.
- **GameWidget.controlled()**: Factory constructor that manages game lifecycle — preferred over passing game instance.
- **Flame Game Jam 4 (2025)**: Active community producing reference games and patterns.

**Deprecated/outdated:**
- **HasGameRef** — use HasGameReference<T> instead (typed)
- **Oxygen ECS** — flame_oxygen exists but standard FCS (Component tree) is recommended
- **Manual gesture detectors on game class** — prefer component-level TapCallbacks/DragCallbacks
</sota_updates>

<open_questions>
## Open Questions

1. **Exact latest Flame version**
   - What we know: v1.35.0 per pub.dev publisher page, v1.33.0 per one search result
   - What's unclear: Which is truly current (pub.dev listing may include pre-release)
   - Recommendation: Use `flutter pub add flame` to get latest stable; pin after initial setup

2. **Audio latency on mobile**
   - What we know: flame_audio wraps audioplayers; AudioPool exists for pre-loaded SFX
   - What's unclear: Actual latency on Android vs iOS for tap-responsive sounds
   - Recommendation: Prototype early and test audio latency in Phase 5; may need platform-specific tuning

3. **Camera shake implementation**
   - What we know: Effects system exists, viewfinder supports effects, but no dedicated shake API
   - What's unclear: Whether MoveByEffect on viewfinder is the canonical approach
   - Recommendation: Implement as MoveByEffect with alternate+repeat EffectController; adjust if community has better pattern
</open_questions>

<sources>
## Sources

### Primary (HIGH confidence)
- [Flame Official Docs](https://docs.flame-engine.org/latest/) — Components, Effects, Collision, Camera, Overlays, GameWidget
- [pub.dev flame package](https://pub.dev/packages/flame) — Version, API docs
- [pub.dev flame-engine.org publisher](https://pub.dev/publishers/flame-engine.org/packages) — Complete ecosystem
- [GitHub flame-engine/flame](https://github.com/flame-engine/flame) — Source, changelog, examples

### Secondary (MEDIUM confidence)
- [Genieee: Flame Competitor 2025](https://genieee.com/flutter-game-development-is-flame-a-real-competitor-in-2025/) — Market position, strengths/weaknesses
- [filiph.net: Benchmarking Flutter/Flame/Unity/Godot](https://filiph.net/text/benchmarking-flutter-flame-unity-godot.html) — Performance comparison data
- [Google Codelabs: Brick Breaker](https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker) — Official tutorial patterns
- [Very Good Ventures: Flame + Bloc](https://www.verygood.ventures/blog/flutter-games-with-bloc-and-flame) — State management patterns
- [Aalto University: Flame Basics](https://opencs.aalto.fi/en/courses/device-agnostic-design/part-6/3-flame-engine-basics) — Academic reference

### Tertiary (LOW confidence - needs validation)
- Flame version discrepancy (1.35.0 vs 1.33.0) — validate with `flutter pub add`
- Audio latency claims — validate during implementation
</sources>

<metadata>
## Metadata

**Research scope:**
- Core technology: Flutter + Flame engine v1.35.0
- Ecosystem: flame_audio, flame_forge2d, flame_bloc, flame_riverpod, 37+ packages total
- Patterns: FlameGame, Component tree (FCS), Overlays, RouterComponent, Effects, Particles, Camera/World
- Pitfalls: Tunneling, onMount vs onLoad, clipping, hollow hitboxes, collision performance, memory leaks

**Confidence breakdown:**
- Standard stack: HIGH — verified with official docs and pub.dev
- Architecture: HIGH — from official tutorials and documentation
- Pitfalls: HIGH — documented in official docs and community issues
- Code examples: HIGH — adapted from official documentation patterns

**Research date:** 2026-02-10
**Valid until:** 2026-03-12 (30 days — Flame ecosystem is stable)
</metadata>

---

*Phase: 01-foundation*
*Research completed: 2026-02-10*
*Ready for planning: yes*
