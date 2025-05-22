# Story: Deploy iOS App to Firebase App Distribution (Stretch Goal)

## Summary (TLDR)

**Configure and deploy the iOS app to Firebase App Distribution for testing.**

* **Key Tasks**:
    * Set up **Firebase project** with iOS app registration
    * Configure **code signing** and provisioning profiles
    * Create **build scripts** for Firebase deployment
    * Distribute app to **test group**
* **Goal**: Enable easy distribution to testers without App Store
* **Time Estimates**:
    * For developer with limited iOS/Swift experience: **12-15 hours**
    * For experienced iOS/Swift developer: **5-8 hours**

## Description

Configure Firebase App Distribution for the iOS hybrid app to enable easy distribution to testers
without going through the App Store. This story includes setting up the Firebase project,
configuring code signing, creating build scripts, and distributing the app to a test group.

## Requirements

- Configure Firebase project with iOS app registration
- Set up code signing and provisioning profiles for distribution
- Create build scripts for generating and uploading builds
- Document the deployment process for future updates
- Distribute the app to a test group

## Technical Tasks

- [ ] Create Firebase project in Firebase Console
- [ ] Register iOS app in Firebase project
- [ ] Download and integrate GoogleService-Info.plist
- [ ] Install Firebase SDK via CocoaPods or Swift Package Manager
- [ ] Set up Apple Developer account and create App ID
- [ ] Generate distribution certificate and provisioning profile
- [ ] Configure Xcode project with signing capabilities
- [ ] Create build script for generating IPA file
- [ ] Install and configure Firebase CLI tools
- [ ] Create script for uploading builds to Firebase
- [ ] Set up test group in Firebase Console
- [ ] Document the entire process for team reference

## Implementation Details

### Build Script Example

```bash
#!/bin/bash
# Build and deploy to Firebase App Distribution

# Configuration
APP_NAME="MyFlutterIOSApp"
WORKSPACE_PATH="./MyFlutterIOSApp.xcworkspace"
SCHEME_NAME="MyFlutterIOSApp"
BUILD_DIR="./build"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
IPA_PATH="$BUILD_DIR/$APP_NAME.ipa"
EXPORT_OPTIONS_PLIST="./ExportOptions.plist"
FIREBASE_APP_ID="1:123456789012:ios:abcdef1234567890"
TESTERS="testgroup1"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Archive the app
echo "Archiving app..."
xcodebuild archive \
  -workspace "$WORKSPACE_PATH" \
  -scheme "$SCHEME_NAME" \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  -configuration Release

if [ $? -ne 0 ]; then
  echo "Archive failed"
  exit 1
fi

# Export IPA
echo "Exporting IPA..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$BUILD_DIR" \
  -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"

if [ $? -ne 0 ]; then
  echo "IPA export failed"
  exit 1
fi

# Upload to Firebase
echo "Uploading to Firebase App Distribution..."
firebase appdistribution:distribute "$IPA_PATH" \
  --app "$FIREBASE_APP_ID" \
  --groups "$TESTERS" \
  --release-notes "New test build with hybrid navigation features."

if [ $? -ne 0 ]; then
  echo "Firebase upload failed"
  exit 1
fi

echo "Distribution completed successfully!"
```

### ExportOptions.plist Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.yourcompany.MyFlutterIOSApp</key>
        <string>YOUR_PROVISIONING_PROFILE_NAME</string>
    </dict>
</dict>
</plist>
```

## Acceptance Criteria

- [ ] Firebase project is properly configured with iOS app
- [ ] App can be built with correct code signing
- [ ] Build script successfully generates IPA file
- [ ] App can be uploaded to Firebase App Distribution
- [ ] Testers can install the app via Firebase App Distribution
- [ ] Process is documented for future deployments

## Dependencies

- All other stories in the epic (this is a stretch goal)

## Notes

This story is marked as a stretch goal because it introduces additional complexity related to code
signing and app distribution that is not strictly necessary for demonstrating the navigation
patterns in the Simulator. For developers with limited iOS experience, code signing and provisioning
can be particularly challenging.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** High
- **LOE with Firebender using Gemini 2.5 Pro:** High

### Project Metrics for Developer with Limited iOS/Swift Experience (Scale 1-10)

- **Likelihood of Success:** 5/10
- **Likelihood of Frustration:** 9/10
- **Likelihood of Manual Steps:** 10/10

### Project Metrics for Experienced iOS/Swift Developer (Scale 1-10)

- **Likelihood of Success:** 8/10
- **Likelihood of Frustration:** 6/10
- **Likelihood of Manual Steps:** 9/10

### Time Estimates

- **For developer with limited iOS/Swift experience:** 12-15 hours
- **For experienced iOS/Swift developer:** 5-8 hours

### Notes

For a Flutter developer with limited iOS experience, code signing and app distribution represent one
of the most challenging aspects of iOS development. Key challenges include:

1. Understanding Apple's code signing process (certificates, identifiers, and provisioning profiles)
2. Configuring the project for distribution builds
3. Setting up automated build scripts that handle signing correctly
4. Troubleshooting common code signing errors

This story has a high likelihood of frustration and manual steps even for experienced iOS
developers, as code signing issues can be notoriously difficult to diagnose and resolve.

Consider these strategies for success:

1. Use automatic signing in Xcode where possible
2. Start with manual steps before attempting automation
3. Document each step carefully, including screenshots
4. Use Apple's documentation on code signing as a reference

Resources that will help:

- [Firebase App Distribution documentation](https://firebase.google.com/docs/app-distribution/ios/distribute-console)
- [Apple's Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Fastlane tools](https://fastlane.tools/) if more advanced automation is needed