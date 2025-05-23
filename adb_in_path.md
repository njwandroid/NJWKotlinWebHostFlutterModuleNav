# Adding ADB to PATH on macOS with Zsh

This guide helps you add Android Debug Bridge (adb) to your system PATH so you can use `adb`
commands from any terminal location.

## Quick Setup

### 1. Find Your Android SDK Location

```bash
# Check if Android SDK is installed via Android Studio
ls ~/Library/Android/sdk/platform-tools/adb
# or
ls /Users/$USER/Library/Android/sdk/platform-tools/adb
```

### 2. Add to Zsh PATH

```bash
# Open your zsh configuration file
nano ~/.zshrc
# or
vim ~/.zshrc
# or
open -e ~/.zshrc
```

### 3. Add These Lines to ~/.zshrc

```bash
# Android SDK Platform Tools
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
```

### 4. Reload Your Shell Configuration

```bash
# Reload zsh configuration
source ~/.zshrc

# Test that adb is now available
adb version
```

## Alternative Locations

If the above doesn't work, try these common Android SDK locations:

### Via Homebrew

```bash
# If installed via Homebrew
export PATH=$PATH:/opt/homebrew/share/android-commandlinetools/platform-tools
```

### Via Android Studio Default

```bash
# Default Android Studio installation
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin
```

### Manual Installation Location

```bash
# If you installed Android SDK manually
export ANDROID_HOME=/path/to/your/android-sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## Finding Your Android SDK Path

### Method 1: Android Studio

1. Open Android Studio
2. Go to **Preferences** → **Appearance & Behavior** → **System Settings** → **Android SDK**
3. Copy the "Android SDK Location" path
4. Add `/platform-tools` to that path

### Method 2: Command Line Search

```bash
# Search for adb in common locations
find /Users/$USER -name "adb" 2>/dev/null
find /opt -name "adb" 2>/dev/null
find /usr/local -name "adb" 2>/dev/null
```

### Method 3: Using Which (if adb works in some terminals)

```bash
# If adb works in Android Studio terminal
which adb
```

## Verification

After adding to PATH, verify everything works:

```bash
# Check adb version
adb version

# List connected devices
adb devices

# Check if your phone is detected
adb devices -l
```

## Troubleshooting

### Issue: "command not found: adb"

**Solution**: PATH not set correctly

```bash
# Check current PATH
echo $PATH | grep android
# Should show your Android SDK path

# If not, double-check your ~/.zshrc file
cat ~/.zshrc | grep ANDROID
```

### Issue: "no permissions"

**Solution**: Enable USB Debugging on your phone

1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times to enable Developer Options
3. Go to **Settings** → **Developer Options**
4. Enable **USB Debugging**
5. Connect phone and approve debugging when prompted

### Issue: Device not showing

**Solution**:

```bash
# Kill and restart adb server
adb kill-server
adb start-server
adb devices
```

## Quick One-Liner Setup

If you're confident about the standard location:

```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc && echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc && source ~/.zshrc && adb version
```

## Testing Your Setup

```bash
# These commands should all work after setup:
adb version                    # Show adb version
adb devices                    # List connected devices  
adb shell getprop ro.product.model  # Get device model
adb install -r app-debug.apk   # Install APK
adb uninstall com.package.name # Uninstall app
adb logcat                     # View device logs
```

---

**Pro Tip**: After setup, you can use adb from any directory in Terminal, not just within Android
Studio!