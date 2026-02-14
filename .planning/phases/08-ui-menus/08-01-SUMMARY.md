---
phase: 08-ui-menus
plan: 01
status: complete
started: 2026-02-14
completed: 2026-02-14
---

# Summary: Main menu branding enhancement

## What was done

### Task 1: Animated pulsing title and high score display
- Converted MainMenu from StatelessWidget to StatefulWidget with SingleTickerProviderStateMixin
- Added AnimationController with 2s period, repeating in reverse, driving scale 1.0→1.05
- Title wrapped in ScaleTransition with Stack: glow layer (GameConfig.accentColor at 0.15 opacity, 68px) behind main title (GameConfig.textColor, 64px)
- Added conditional "BEST [score]" display below "TAP TO PLAY" — only shows when bestScore > 0
- All text colors now reference GameConfig.textColor instead of hardcoded Colors.white
- **Commit:** `300a60d` — feat(08-01): add animated pulsing title and high score display

### Task 2: Settings button and reorganize navigation layout
- Replaced single COLLECTION button with side-by-side Row: SETTINGS + COLLECTION (32px gap)
- Both buttons use consistent style: GameConfig.textColor at 0.5 alpha, 16px, letterSpacing 4, GestureDetector + HitTestBehavior.opaque
- Added showSettings()/hideSettings() methods to PulseGame (mirrors showGallery/hideGallery pattern)
- Registered 'Settings' overlay in main.dart overlayBuilderMap
- Created placeholder SettingsScreen in lib/screens/settings_screen.dart (title + BACK button)
- **Commit:** `1e90a81` — feat(08-01): add settings button and reorganize navigation layout

## Files modified
- `lib/screens/main_menu.dart` — StatefulWidget conversion, pulsing title, glow, best score, settings button
- `lib/game/pulse_game.dart` — showSettings()/hideSettings() methods
- `lib/main.dart` — Settings overlay registration
- `lib/screens/settings_screen.dart` — New placeholder settings screen

## Decisions
| Decision | Rationale |
|----------|-----------|
| SingleTickerProviderStateMixin (not full Ticker) | Only one animation controller needed |
| Glow as 68px text behind 64px title | Simple technique, no shader overhead |
| Placeholder SettingsScreen as separate widget | Clean separation, will be fully built in 08-02 |

## Issues
None.
