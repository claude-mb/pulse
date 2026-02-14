# iOS Build and Submission Guide

This guide covers building and submitting Pulse to the Apple App Store. iOS builds require macOS with Xcode -- these steps cannot be performed on Windows or Linux.

## 1. Prerequisites

- **macOS** computer (Ventura 13.0 or later recommended)
- **Xcode 15+** installed from the Mac App Store
- **Apple Developer account** ($99/year) -- enroll at [developer.apple.com](https://developer.apple.com/programs/enroll/)
- **CocoaPods** installed:
  ```bash
  sudo gem install cocoapods
  ```
- **Flutter SDK** installed on the Mac:
  ```bash
  git clone https://github.com/flutter/flutter.git -b stable
  export PATH="$PATH:$(pwd)/flutter/bin"
  flutter doctor
  ```

## 2. Initial Setup on Mac

1. Clone the repository:
   ```bash
   git clone <repo-url> pulse-game
   cd pulse-game
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Install iOS CocoaPods dependencies:
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. Open the Xcode workspace (**not** the `.xcodeproj`):
   ```bash
   open ios/Runner.xcworkspace
   ```

   Using `.xcworkspace` is required because CocoaPods manages dependencies through the workspace. Opening `.xcodeproj` directly will cause build failures.

## 3. Signing Configuration

1. In Xcode, select the **Runner** project in the left sidebar
2. Select the **Runner** target (not RunnerTests)
3. Go to the **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team** from the dropdown (your Apple Developer account)
6. Xcode will automatically create and manage provisioning profiles
7. Verify there are no signing errors in the status area

If you see "No profiles for 'com.pulsegame.pulse'", Xcode will offer to create one -- click **Fix Issue**.

**Bundle ID:** The project is already configured with `com.pulsegame.pulse`. Do not change this unless you have a specific reason.

## 4. Build Release Archive

### Option A: Flutter CLI (Recommended)

```bash
flutter build ios --release
```

This creates a release build. To create an archive for distribution:

```bash
flutter build ipa
```

The `.ipa` file will be at `build/ios/ipa/pulse_game.ipa`.

### Option B: Xcode

1. In Xcode, set the destination to **Any iOS Device (arm64)**
2. Go to **Product > Archive**
3. Wait for the archive to complete
4. The archive appears in **Window > Organizer**

### Troubleshooting

- If the build fails with signing errors, revisit Section 3
- If CocoaPods errors appear, run `cd ios && pod install --repo-update && cd ..`
- For minimum deployment target warnings, update `IPHONEOS_DEPLOYMENT_TARGET` in `ios/Runner.xcodeproj/project.pbxproj`

## 5. Upload to App Store Connect

### Prerequisites

- Create your app listing at [App Store Connect](https://appstoreconnect.apple.com/)
- Click **My Apps > +** to register a new app
- Use bundle ID `com.pulsegame.pulse`

### Option A: Xcode Organizer (Recommended)

1. Open **Window > Organizer** in Xcode
2. Select your archive
3. Click **Distribute App**
4. Select **App Store Connect**
5. Click **Upload**
6. Follow the prompts to validate and upload

### Option B: CLI with xcrun

```bash
xcrun altool --upload-app \
  -f build/ios/ipa/pulse_game.ipa \
  -t ios \
  -u YOUR_APPLE_ID \
  -p YOUR_APP_SPECIFIC_PASSWORD
```

Generate an app-specific password at [appleid.apple.com](https://appleid.apple.com/) under **Security > App-Specific Passwords**.

### After Upload

- The build processes in App Store Connect (takes approximately 15 minutes)
- Once processed, go to App Store Connect > your app > TestFlight to verify
- Add the build to your app version under **App Store** tab for submission
- Fill in required metadata: screenshots, description, keywords, privacy policy URL
- Submit for review (typically 24-48 hours)

## 6. Alternative: CI/CD

For ongoing development, CI/CD automates building and uploading on every push or tag.

### Codemagic (Recommended for Flutter)

Codemagic offers a free tier with 500 build minutes/month on macOS VMs.

1. Sign up at [codemagic.io](https://codemagic.io/)
2. Connect your repository
3. Add a `codemagic.yaml` to the repo root:

```yaml
workflows:
  ios-release:
    name: iOS Release
    instance_type: mac_mini_m2
    max_build_duration: 30
    environment:
      ios_signing:
        distribution_type: app_store
        bundle_identifier: com.pulsegame.pulse
      flutter: stable
    scripts:
      - name: Install dependencies
        script: |
          flutter pub get
      - name: Install CocoaPods
        script: |
          cd ios && pod install
      - name: Build iOS
        script: |
          flutter build ipa --release
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      app_store_connect:
        auth: integration
        submit_to_testflight: true
```

4. Configure iOS code signing in the Codemagic UI (upload your certificates or use automatic signing)

### GitHub Actions

Use `macos-latest` runner with the Flutter action:

```yaml
# .github/workflows/ios-release.yml
name: iOS Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Install CocoaPods
        run: cd ios && pod install

      - name: Build iOS
        run: flutter build ipa --release
        env:
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}

      - name: Upload to App Store Connect
        run: |
          xcrun altool --upload-app \
            -f build/ios/ipa/*.ipa \
            -t ios \
            -u ${{ secrets.APPLE_ID }} \
            -p ${{ secrets.APP_SPECIFIC_PASSWORD }}
```

**Required GitHub secrets:**
- `APPLE_ID` -- Your Apple ID email
- `APP_SPECIFIC_PASSWORD` -- Generated at appleid.apple.com
- `APPLE_TEAM_ID` -- Your Apple Developer Team ID

**Note:** For GitHub Actions, you also need to set up code signing certificates. Use [match](https://docs.fastlane.tools/actions/match/) (via Fastlane) or manually export and import certificates as secrets.
