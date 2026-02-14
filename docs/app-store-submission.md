# App Store Submission Guide — Pulse

Step-by-step guide for publishing Pulse to the Apple App Store.

---

## Prerequisites

- **Apple Developer account** — $99/year at [developer.apple.com](https://developer.apple.com)
- **macOS with Xcode** — Required for building and uploading iOS archives (see `docs/ios-release-guide.md` for build steps)
- **iOS archive** — Built and uploaded via Xcode Organizer
- **Screenshots** — Captured from iOS device or simulator for required device sizes
- **Privacy policy** — `docs/privacy-policy.html` hosted at a publicly accessible URL

---

## Step 1: Register Bundle ID

1. Go to [developer.apple.com](https://developer.apple.com) and sign in
2. Navigate to **Certificates, Identifiers & Profiles**
3. Select **Identifiers** in the left sidebar
4. Click the **+** button to register a new identifier
5. Select **App IDs** > **App**
6. Fill in the details:
   - **Description**: Pulse
   - **Bundle ID**: Select **Explicit** and enter `com.pulsegame.pulse`
7. Under **Capabilities**, no additional capabilities are needed (defaults are fine)
8. Click **Continue** > **Register**

---

## Step 2: Create App in App Store Connect

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) and sign in
2. Navigate to **My Apps**
3. Click the **+** button > **New App**
4. Fill in the details:
   - **Platforms**: iOS
   - **Name**: Pulse
   - **Primary language**: English (U.S.)
   - **Bundle ID**: Select `com.pulsegame.pulse` (registered in Step 1)
   - **SKU**: pulse-v1
   - **User Access**: Full Access
5. Click **Create**

---

## Step 3: App Information

1. In your app's page, go to **App Information** (left sidebar under General)
2. Set the following:
   - **Category**: Games > **Arcade**
   - **Content Rights**: Select "This app does not contain, show, or access third-party content"
3. Go to **Age Rating** and complete the questionnaire:
   - For all content categories (cartoon/fantasy violence, realistic violence, sexual content, profanity, drugs, etc.), select **None**
   - Expected result: **4+** age rating
4. Click **Save**

---

## Step 4: Pricing

1. Go to **Pricing and Availability** (left sidebar)
2. Set **Price**: Free
3. Under **Availability**, select the countries/regions where you want to distribute (or leave as all territories)
4. Click **Save**

---

## Step 5: App Privacy

1. Go to **App Privacy** (left sidebar)
2. Click **Get Started** on the privacy questionnaire
3. For each data type category, select **No, we do not collect data from this app**
4. Enter your **Privacy Policy URL** — the public URL where `docs/privacy-policy.html` is hosted
5. Click **Save** > **Publish**

---

## Step 6: Version Information

1. Go to your app version page (e.g., **iOS App** > **1.0 Prepare for Submission**)
2. Fill in the following fields:

   **Description:**
   - Paste contents of `store/app_store/description.txt`

   **Keywords:**
   - Paste contents of `store/app_store/keywords.txt` (comma-separated, max 100 characters total)

   **Support URL:**
   - Enter your support URL (e.g., GitHub repository issues page or a contact page)

   **Marketing URL:** (optional)
   - Enter if available, otherwise leave blank

   **Screenshots:**
   - Upload screenshots for the following required device sizes:
     - **6.5-inch iPhone** (iPhone 14 Plus / 15 Plus): 1284 x 2778 px
     - **5.5-inch iPhone** (iPhone 8 Plus): 1242 x 2208 px
   - Minimum 1 screenshot per size, recommended 3-5
   - Screenshots must show actual gameplay, not mockups

   **App Preview:** (optional)
   - Upload a short gameplay video if desired

3. Click **Save**

---

## Step 7: Build and Submit

1. **Build the iOS archive** following the steps in `docs/ios-release-guide.md`
2. **Upload via Xcode:**
   - Open the project in Xcode
   - Select **Product** > **Archive**
   - In the Organizer window, select the archive and click **Distribute App**
   - Choose **App Store Connect** > **Upload**
   - Follow the prompts to sign and upload
3. **Wait for processing** — The build takes a few minutes to process in App Store Connect
4. **Select the build** in App Store Connect:
   - Go to your app version page
   - Under **Build**, click **+** and select the uploaded build
5. **Submit for Review:**
   - Verify all sections show green checkmarks
   - Click **Submit for Review**
6. **Review time**: Apple typically reviews within **24-48 hours**

---

## Post-Submission

- **Status tracking**: Monitor in App Store Connect under your app's **Activity** tab
- **Common statuses**: Waiting for Review > In Review > Ready for Sale (or Rejected)
- If rejected, Apple provides specific reasons with guideline references — fix and resubmit

---

## Common Rejection Reasons to Avoid

- **Missing privacy policy URL** — Must be a live, publicly accessible link before submission
- **Placeholder text** — Ensure no "Lorem ipsum" or "[TODO]" text remains in any field
- **Screenshots not matching actual app** — Screenshots must accurately represent the current version
- **App crashes on launch** — Test thoroughly on a physical iOS device before submitting
- **Incomplete metadata** — All required fields must be filled in (description, screenshots, support URL)
- **Guideline 4.3 (Spam)** — Ensure the app provides meaningful value and unique functionality
- **Guideline 2.1 (Performance)** — App must not crash, hang, or have obvious bugs
