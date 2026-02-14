# Google Play Store Submission Guide — Pulse

Step-by-step guide for publishing Pulse to the Google Play Store.

---

## Artifact Verification

Before starting, verify all required files are present:

| Artifact | Path | Status |
|---|---|---|
| App icon source | `assets/icon/app_icon.png` | Required |
| Signed AAB | `build/app/outputs/bundle/release/app-release.aab` | Build with `flutter build appbundle --release` |
| Short description | `store/google_play/short_description.txt` | Required |
| Full description | `store/google_play/description.txt` | Required |
| Feature graphic | `store/google_play/feature_graphic.png` | Required |
| Privacy policy | `docs/privacy-policy.html` | Must be hosted at a public URL |

---

## Prerequisites

- **Google Play Console account** — $25 one-time registration at [play.google.com/console](https://play.google.com/console)
- **Signed AAB** — Run `C:/flutter/bin/flutter build appbundle --release` to generate `build/app/outputs/bundle/release/app-release.aab`
- **Screenshots** — Minimum 2 phone screenshots captured from a device or emulator (JPEG or PNG, min 320px, max 3840px per side)
- **Privacy policy** — `docs/privacy-policy.html` hosted at a publicly accessible URL (e.g., GitHub Pages, Firebase Hosting)

---

## Step 1: Create App

1. Open [Google Play Console](https://play.google.com/console)
2. Navigate to **All apps** in the left sidebar
3. Click **Create app**
4. Fill in the details:
   - **App name**: Pulse
   - **Default language**: English (United States)
   - **App or game**: Game
   - **Free or paid**: Free
5. Review and accept the **Developer Program Policies** and **US export laws** declarations
6. Click **Create app**

---

## Step 2: Store Listing

1. Go to **Grow** > **Store presence** > **Main store listing**
2. Under **App details**:
   - **Short description**: Paste contents of `store/google_play/short_description.txt` (max 80 characters)
   - **Full description**: Paste contents of `store/google_play/description.txt` (max 4000 characters)
3. Under **Graphics**:
   - **App icon**: Auto-populated from the AAB manifest; verify it looks correct
   - **Feature graphic**: Upload `store/google_play/feature_graphic.png` (1024x500 px)
   - **Phone screenshots**: Upload at least 2 screenshots captured from the game (16:9 or 9:16, min 320px, max 3840px)
4. Click **Save**

---

## Step 3: Content Rating

1. Go to **Policy** > **App content** > **Content rating**
2. Click **Start questionnaire**
3. Enter your email address
4. Select category: **Game** (the closest match for a rhythm-action game)
5. For all content questions (violence, sexuality, language, substances, etc.), select **No** or **None**
6. Click **Save** > **Next** > **Submit**
7. Expected result: IARC rating of **Rated for 3+** / ESRB **Everyone**

---

## Step 4: Target Audience and Content

1. Go to **Policy** > **App content** > **Target audience and content**
2. Select target age group: **13 and over**
   - This is the simplest option and avoids child-specific compliance requirements (COPPA, etc.)
3. Confirm the app is **not primarily child-directed**
4. Click **Save**

---

## Step 5: App Content Declarations

1. Go to **Policy** > **App content** and complete each section:

   **Ads declaration:**
   - Does your app contain ads? **No**

   **App access:**
   - Is all functionality available without special access? **Yes — all functionality is available without special access**

   **Data safety:**
   - Does your app collect or share user data? **No**
   - Complete the data safety form indicating no data is collected or shared

   **Privacy policy:**
   - Enter the public URL where you have hosted `docs/privacy-policy.html`

2. Save each section after completing it

---

## Step 6: Upload and Release

1. Go to **Release** > **Production**
2. Click **Create new release**
3. Under **App signing**, accept Google Play App Signing if prompted (recommended)
4. Click **Upload** and select `build/app/outputs/bundle/release/app-release.aab`
5. Wait for the upload and processing to complete
6. Fill in release details:
   - **Release name**: 1.0.0
   - **Release notes**: "Initial release of Pulse — a rhythm-action game. Tap to the beat, dodge obstacles, and chase high scores."
7. Click **Review release**
8. Review any warnings or errors; fix if needed
9. Click **Start rollout to Production**
10. Confirm the rollout

---

## Post-Submission

- **Review time**: Google typically reviews within **1-3 business days**
- **Status tracking**: Monitor the release status in the Play Console under **Release** > **Production**
- If rejected, Google provides specific reasons — fix the issues and resubmit

---

## Common Issues to Watch For

- **Missing privacy policy URL** — Must be a live, publicly accessible link
- **Screenshots mismatch** — Screenshots must reflect the actual game experience
- **Target API level** — Google requires targeting a recent Android API level; Flutter handles this by default
- **App signing** — Accept Google Play App Signing for simplest key management
- **64-bit requirement** — Flutter AAB includes both arm64 and x86_64 by default
