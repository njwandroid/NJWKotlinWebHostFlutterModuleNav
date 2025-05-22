# Maestro Quickstart Guide

This guide will help you get started with Maestro UI testing for our hybrid Flutter-Kotlin
navigation app.

## Installation

### Prerequisites

- macOS, Windows, or Linux
- [Android SDK](https://developer.android.com/studio) for Android testing
- [Xcode](https://developer.apple.com/xcode/) for iOS testing (macOS only)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### 1. Install Maestro CLI

**macOS**:

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

**Windows**:

```bash
powershell -Command "iwr -useb https://get.maestro.mobile.dev/win | iex"
```

**Linux**:

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### 2. Verify Installation

```bash
maestro --version
```

You should see the Maestro version number, confirming it's installed correctly.

## Running Your First Test

### 1. Create flows directory

```bash
mkdir -p maestro/flows
```

### 2. Create a hello_world.yaml test

Create a file at `maestro/flows/hello_world.yaml` with this content:

```yaml
appId: com.example.myflutternavbarapplication # Replace with your app's ID
---
# Launch the app
- launchApp

# Wait for app to load
- waitForAnimationToEnd

# Verify the first tab is selected
- assertVisible:
    text: "My" # Text on the first tab

# This step will intentionally fail for demonstration
- assertVisible:
    text: "This text doesn't exist in the app"
    timeout: 5000
```

### 3. Run the test on a connected device or emulator

Ensure you have an Android emulator or iOS simulator running, or a physical device connected.

```bash
maestro test flows/hello_world.yaml
```

### 4. Observe the failure

The test will fail at the last step because "This text doesn't exist in the app" isn't present. This
confirms Maestro is working and can detect issues.

## Creating a Real Test

Let's modify our test to actually validate tab navigation:

```yaml
appId: com.example.myflutternavbarapplication # Replace with your app's ID
---
# Launch the app
- launchApp

# Wait for app to load
- waitForAnimationToEnd
  
# Take a screenshot of the starting state
- takeScreenshot: start-state

# Verify the My tab is visible
- assertVisible:
    text: "My"

# Tap on the Billing tab
- tapOn:
    text: "Billing"

# Verify we navigated to the Billing tab
- assertVisible:
    text: "Billing" 
    
# Take a screenshot of Billing tab
- takeScreenshot: billing-tab

# Tap on the Dashboard tab
- tapOn:
    text: "Dashboard"
    
# Verify we navigated to the Dashboard tab
- assertVisible:
    text: "Dashboard"

# Take a screenshot of Dashboard tab
- takeScreenshot: dashboard-tab
```

## Next Steps

1. Explore the [Maestro command reference](https://maestro.mobile.dev/api-reference/commands)
2. Check our [FAQ](./faq.md) for common questions
3. View example flows in the `flows/` directory
4. Try writing tests for other navigation patterns in our app
5. Integrate with CI using our GitHub Actions workflow