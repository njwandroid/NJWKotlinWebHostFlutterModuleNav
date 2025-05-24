# Maestro UI Testing for Hybrid Navigation App

## What is Maestro?

Maestro is a mobile UI testing framework that simplifies creating, running, and maintaining UI tests
for mobile applications. It uses a simple YAML-based syntax to define test flows, making it easy to
write and understand tests without deep programming knowledge.

## Why Maestro for Our Hybrid App?

Maestro offers several advantages for testing our hybrid Flutter-Kotlin navigation app:

- **Cross-Platform**: Works with both Android and iOS
- **Technology Agnostic**: Tests Flutter and native screens seamlessly
- **Easy Syntax**: Simple YAML format is readable and maintainable
- **Visual Verification**: Captures screenshots at each step
- **CI Integration**: Easy to integrate with GitHub Actions
- **Rich Reports**: Generates detailed test reports and videos

## Directory Structure

```
maestro/
├── README.md           # This overview file
├── quickstart.md       # Getting started guide
├── faq.md              # Frequently asked questions
├── troubleshooting.md  # Common issues and solutions
├── maestro_safe_demo_mode.md  # Privacy protection guide for recordings
├── flows/              # Test flow definition files
│   ├── hello_world.yaml   # Simple test to verify setup
│   ├── navigation/        # Navigation test flows
│   ├── deep_linking/      # Deep linking test flows
│   └── cross_platform/    # Tests that work on both iOS and Android
└── scripts/            # Helper scripts for running tests
    ├── run_maestro_test.sh         # Standard test runner
    └── robust_run_maestro_test.sh  # Enhanced multi-device runner
```

## Key Resources

- [Maestro Documentation](https://maestro.mobile.dev/)
- [Installation Guide](https://maestro.mobile.dev/getting-started/installing-maestro)
- [YAML Flow Syntax](https://maestro.mobile.dev/api-reference/commands)
- [CI Integration Guide](https://maestro.mobile.dev/getting-started/maestro-cloud)
- [Maestro Safe Demo Mode Guide](./maestro_safe_demo_mode.md)

## Getting Started

See our [Quickstart Guide](./quickstart.md) to install Maestro and run your first test.

For common issues, check the [Troubleshooting Guide](./troubleshooting.md).

## Running Tests Locally

```bash
# Run a specific test flow
maestro test flows/hello_world.yaml

# Run all test flows
maestro test flows/

# Run with video recording
maestro record --local flows/hello_world.yaml output_video.mp4
```

## 🔒 Privacy Protection for Recordings

When recording demos or creating test videos, it's crucial to protect personal information. See our
comprehensive [**Safe Demo Mode Guide**](./maestro_safe_demo_mode.md) for:

- **Privacy Risk Prevention**: Avoid exposing personal notifications, calls, or data
- **Safe Recording Setup**: Pre-recording checklists and environment preparation
- **Post-Recording Verification**: How to check recordings for privacy issues
- **Emergency Response**: What to do if privacy issues are found

**⚠️ Always review recordings before sharing to ensure no personal information is exposed.**

## Test Runner Scripts

We provide two test runner scripts to streamline the testing process:

### Standard Test Runner

The standard script provides basic functionality for single-device scenarios:

```bash
# Run a test with default options
./maestro/scripts/run_maestro_test.sh flows/hello_world.yaml

# Run with AI-enhanced test report
./maestro/scripts/run_maestro_test.sh --ai-report flows/hello_world.yaml

# Clean build before running test
./maestro/scripts/run_maestro_test.sh --clean flows/hello_world.yaml

# Run without video recording
./maestro/scripts/run_maestro_test.sh --no-video flows/hello_world.yaml
```

### Robust Multi-Device Test Runner ⭐

The robust script provides enhanced device management for complex scenarios with multiple connected
devices:

```bash
# Basic usage (interactive device selection if multiple devices)
./maestro/scripts/robust_run_maestro_test.sh flows/hello_world.yaml

# Target specific device by ID
./maestro/scripts/robust_run_maestro_test.sh --device emulator-5554 flows/hello_world.yaml

# Auto-select first available device (no prompts)
./maestro/scripts/robust_run_maestro_test.sh --first flows/hello_world.yaml

# Prefer emulators over physical devices
./maestro/scripts/robust_run_maestro_test.sh --emulator-first flows/hello_world.yaml

# Enable verbose logging for troubleshooting
./maestro/scripts/robust_run_maestro_test.sh --verbose --device emulator-5554 flows/hello_world.yaml

# Combined options for CI environments
./maestro/scripts/robust_run_maestro_test.sh --first --clean --ai-report flows/hello_world.yaml
```

#### Robust Script Features

**Enhanced Device Selection:**

- **Single Device**: Automatically selected
- **Multiple Devices**: Interactive menu with device details (type, model, API level)
- **Specific Device**: Target by device ID with `--device`
- **Auto Selection**: Use `--first` or `--emulator-first` for automated environments

**Device Information Display:**

```
Found 3 connected device(s):
  1. emulator-5554 - Emulator: Pixel_3a_API_33 (API 33)
  2. 48050DLAQ0091E - Physical: SM-G991B (API 31)
  3. emulator-5556 - Emulator: Pixel_6_API_34 (API 34)
```

**Smart Device Preferences:**

- Emulator detection and preference with `--emulator-first`
- Physical device model and manufacturer information
- API level compatibility checking

**Enhanced Error Handling:**

- Detailed device availability logging
- Better error messages for device connection issues
- Graceful fallback when preferred device types aren't available

**Verbose Mode:**

- Detailed logging with `--verbose` flag
- SDK path detection information
- Device selection decision logging
- Helpful for CI/CD troubleshooting

#### When to Use Each Script

**Use Standard Script When:**

- Single device development environment
- Simple test execution needs
- Quick local testing

**Use Robust Script When:**

- Multiple devices connected (emulators + physical devices)
- CI/CD environments with varying device configurations
- Need specific device targeting
- Troubleshooting device selection issues
- Team environments with shared test devices

## Script Capabilities

Both scripts automatically:

- Detect and set up Android SDK tools
- Check for available devices and provide selection options
- Start an emulator if no device is available
- Build and install the app on the selected device
- Execute the specified Maestro test
- Record a video of the test (unless disabled)
- Generate an AI-enhanced report (if requested)

## Troubleshooting Device Issues

If you encounter device detection problems:

1. **List devices manually**: `adb devices`
2. **Check emulators**: `emulator -list-avds`
3. **Use verbose mode**: `--verbose` flag with robust script
4. **Verify SDK setup**: Check `ANDROID_SDK_ROOT` environment variable
5. **Device authorization**: Accept USB debugging prompts on physical devices

For more troubleshooting tips, see our [Troubleshooting Guide](./troubleshooting.md).

For more details on contributing to Maestro testing, see
our [Contributing Guide](./CONTRIBUTING.md).
