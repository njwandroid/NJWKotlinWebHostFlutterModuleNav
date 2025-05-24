# Maestro Safe Demo Mode - Privacy Protection Guide

## 🔒 Overview

This guide provides best practices for recording Maestro demonstrations while protecting personal
information and avoiding privacy leaks in screenshots and videos.

## 🚨 Common Privacy Risks

### High-Risk Areas

- **Status Bar Information**: Time, battery, carrier, Wi-Fi networks
- **Notifications**: SMS, calls, emails, app notifications
- **Recent Apps**: Personal app content visible in task switcher
- **Keyboard Suggestions**: Personal data in auto-complete
- **Background Apps**: Personal content visible during app switching

### Medium-Risk Areas

- **Device Information**: Model, Android version, developer settings
- **Network Information**: Wi-Fi names, Bluetooth connections
- **App Data**: Test data resembling real personal information

## 🛡️ Safe Demo Environment Setup

### Pre-Recording Checklist

#### 1. Enable Privacy Protection Modes

```bash
# Enable airplane mode (recommended)
# This prevents incoming calls/SMS during recording
```

#### 2. Notification Management

```bash
# Clear all notifications
# Enable Do Not Disturb mode
# Close all background apps
# Disable auto-sync for personal apps
```

#### 3. Status Bar Cleanup

```bash
# Set time to generic time (12:00 or 10:09)
# Ensure battery level is acceptable to show
# Use generic carrier name if possible
# Disconnect from personal Wi-Fi networks
```

#### 4. App Environment

```bash
# Use test data only (no real personal information)
# Clear recent apps/task switcher
# Disable keyboard learning/suggestions
# Use incognito/private browsing if needed
```

### Device-Specific Setup

#### Android Setup

```bash
# Enable airplane mode
adb shell settings put global airplane_mode_on 1
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE

# Clear notifications
adb shell service call notification 1

# Set generic time (optional - requires root)
# adb shell su -c 'date MMDDhhmmYYYY.ss'
```

#### iOS Setup (if applicable)

```bash
# Enable airplane mode in Control Center
# Clear notifications from Notification Center
# Close all background apps
# Disable Siri suggestions
```

## 📱 Safe Recording Practices

### Before Starting Recording

1. **Environment Check**
    - [ ] Airplane mode enabled
    - [ ] Notifications cleared
    - [ ] Background apps closed
    - [ ] Generic time set (if possible)
    - [ ] Test data prepared

2. **App State Verification**
    - [ ] Only demo app and system apps visible
    - [ ] No personal data in test app
    - [ ] Clean recent apps view
    - [ ] Keyboard history cleared

3. **Recording Settings**
    - [ ] Record in controlled environment
    - [ ] Use shortest necessary recording time
    - [ ] Plan recording flow in advance
    - [ ] Have script/steps ready

### During Recording

1. **Stay Focused**
    - Follow planned script exactly
    - Avoid deviating from intended app flow
    - Don't access settings or other apps unnecessarily
    - Keep recording time minimal

2. **Handle Interruptions**
    - If notification appears, stop recording immediately
    - If call comes in, stop recording immediately
    - Restart recording after clearing interruption

3. **Navigation Safety**
    - Avoid task switcher/recent apps unless necessary
    - Don't access notification panel
    - Stay within demo app boundaries

## 🎬 Maestro-Specific Safety

### Using Robust Maestro Script Safely

```bash
# Run in safe mode with cleaned environment
./maestro/scripts/robust_run_maestro_test.sh \
  --device [specific-test-device] \
  --verbose \
  flows/your-demo-flow.yaml
```

### Safe Flow Design

```yaml
# Example safe Maestro flow
appId: com.example.testapp
---
# Always start fresh
- clearState
- launchApp

# Use specific test data
- tapOn: "Test Button"
- assertVisible: "Expected Test Result"

# Avoid system interactions
- tapOn: id:"app_specific_button"  # Good
# - tapOn: "Back"  # May show system UI - be careful
```

### Recording Configuration

```bash
# Record with specific device and controlled environment
maestro --device [test-device-id] record \
  flows/safe-demo-flow.yaml \
  output/safe-demo-$(date +%Y%m%d_%H%M%S).mp4
```

## ✅ Post-Recording Verification

### Privacy Review Checklist

Before sharing any recorded content:

#### Screenshots

- [ ] **Status Bar**: Check time, battery, carrier, Wi-Fi
- [ ] **Notifications**: Verify no notification icons visible
- [ ] **App Content**: Ensure only test data shown
- [ ] **System UI**: Check navigation bar doesn't show personal info

#### Videos

- [ ] **Full Playback**: Watch entire video for privacy issues
- [ ] **Interruptions**: Check for incoming calls/SMS during recording
- [ ] **Background Content**: Verify no personal apps visible
- [ ] **Status Changes**: Watch for notification popups
- [ ] **Task Switching**: If shown, verify no personal app content

### Red Flags to Look For

🚨 **Immediate Issues (Re-record Required)**

- Personal phone numbers or contact names
- SMS/call notifications with personal content
- Personal Wi-Fi network names
- Real email addresses or personal data
- Banking/financial app content
- Personal photos or media

⚠️ **Minor Issues (Consider Editing)**

- Specific timestamps that reveal recording time
- Non-generic carrier names
- Battery percentage (minor issue)
- Device-specific model information

## 🔧 Privacy Issue Remediation

### If Privacy Issues Are Found

1. **Immediate Actions**
   ```bash
   # Stop sharing the content immediately
   # Document the specific privacy issue
   # Plan re-recording or editing approach
   ```

2. **Remediation Options**
    - **Re-record**: Best option for serious privacy issues
    - **Edit/Blur**: For minor status bar information
    - **Crop**: If privacy issue is in specific area
    - **Replace**: Overwrite file with clean version

3. **Git Repository Handling**
   ```bash
   # Replace problematic file with clean version
   cp clean-recording.mp4 problematic-recording.mp4
   git add problematic-recording.mp4
   git commit -m "Replace with privacy-safe version"
   git push
   ```

## 📋 Quick Reference

### Essential Pre-Recording Commands

```bash
# Android Privacy Setup
adb shell settings put global airplane_mode_on 1
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE
adb shell service call notification 1

# Clear recent apps
adb shell am kill-all

# Launch demo app fresh
adb shell am start -S -W [your.app.package]/.MainActivity
```

### Safe Recording Template

```bash
#!/bin/bash
# Safe Maestro Recording Script

# 1. Setup safe environment
echo "Setting up safe demo environment..."
adb shell settings put global airplane_mode_on 1
adb shell service call notification 1

# 2. Wait for setup
sleep 3

# 3. Record with robust script
./maestro/scripts/robust_run_maestro_test.sh \
  --first \
  --clean \
  flows/your-safe-demo.yaml

echo "Recording complete - remember to verify privacy before sharing!"
```

## 🎯 Integration with Robust Maestro Script

The robust Maestro script includes privacy-aware features:

- **Device Selection**: Choose specific test devices
- **Clean Environment**: `--clean` flag for fresh builds
- **Controlled Execution**: Specific device targeting
- **Verbose Logging**: Track what's happening during recording

## 📚 Additional Resources

- [Android Privacy Settings](https://developer.android.com/guide/topics/permissions/overview)
- [Maestro Recording Best Practices](https://maestro.mobile.dev/)
- [Mobile App Privacy Guidelines](https://developer.android.com/guide/topics/permissions/overview)

## 🆘 Emergency Privacy Response

If you accidentally record sensitive information:

1. **Stop sharing immediately**
2. **Replace the file** with a clean version
3. **Commit the replacement** to git
4. **Document the incident** for learning
5. **Review and improve** privacy procedures

Remember: **Prevention is better than remediation**. Always set up a safe environment before
recording demos!