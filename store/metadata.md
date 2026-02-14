# Pulse - Store Metadata

## Category
- Google Play: Games > Arcade
- App Store: Games > Arcade

## Content Rating
- Google Play: Everyone (no violence, no sexual content, no IAP, no ads, no user interaction, no data collection)
- App Store: 4+ (no objectionable content)

## Supported Languages
- English

## Contact Information
- Developer email: [PLACEHOLDER - fill in before submission]
- Privacy policy URL: [PLACEHOLDER - create and host before submission]
- Website: [PLACEHOLDER - optional]

## Screenshot Requirements

### Google Play
- Minimum 2 screenshots (up to 8)
- Format: JPEG or 24-bit PNG (no alpha)
- Dimensions: 320px to 3840px per side
- Aspect ratio: 16:9 for landscape, 9:16 for portrait
- Must be captured from running app

### App Store
- 6.5" display (iPhone): 1284 x 2778 px (required)
- 5.5" display (iPhone): 1242 x 2208 px (required)
- iPad Pro 12.9" (3rd gen): 2048 x 2732 px (required if supporting iPad)
- Must be captured from running app or simulator

## Feature Graphic
- Google Play: 1024 x 500 px (PNG or JPEG)
- Generated via `tool/generate_feature_graphic.dart`

## Notes
- Screenshots must be captured from a running device or emulator (not generated)
- Privacy policy is required by both stores even with no data collection
- Google Play requires a developer account ($25 one-time fee)
- App Store requires Apple Developer Program membership ($99/year)

## Privacy Policy Hosting

The privacy policy is located at `docs/privacy-policy.html` (static HTML) and `docs/privacy-policy.md` (source). You must host the HTML version at a public URL and enter that URL in both Google Play Console and App Store Connect before submission.

### Option A -- GitHub Pages (Recommended)

1. Push `docs/privacy-policy.html` to the repo on the `main` branch
2. Go to repo **Settings > Pages > Source**: select "Deploy from a branch", choose `main`, and set folder to `/docs`
3. Privacy policy will be accessible at: `https://[username].github.io/[repo]/privacy-policy.html`

### Option B -- Netlify Drop

1. Go to [app.netlify.com/drop](https://app.netlify.com/drop)
2. Drag the `docs/` folder onto the page
3. Get an instant URL; set a custom domain if desired

### Option C -- Include in Web Build

1. Copy `docs/privacy-policy.html` to the `web/` directory
2. Deploy the web build; privacy policy will be accessible at `/privacy-policy.html`

### Store Entry Points

- **Google Play Console:** App content > Privacy policy > enter URL
- **App Store Connect:** App Information > Privacy Policy URL > enter URL

> **Note:** The privacy policy URL must be entered in both stores before submission. The URL must be publicly accessible (not behind authentication).