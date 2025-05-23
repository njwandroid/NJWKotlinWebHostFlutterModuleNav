# Contributing to Maestro Testing

This guide provides information on how to contribute to our Maestro testing framework, including how
to use and extend the test runner script, create new test flows, and propose improvements.

## Table of Contents

- [Test Runner Script](#test-runner-script)
    - [Overview](#overview)
    - [Command-Line Options](#command-line-options)
    - [How It Works](#how-it-works)
    - [Example Usages](#example-usages)
- [Creating Test Flows](#creating-test-flows)
- [Video Recording](#video-recording)
    - [Current Limitations](#current-limitations)
    - [Local Recording Proposal](#local-recording-proposal)
- [AI-Enhanced Reports](#ai-enhanced-reports)

## Test Runner Script

### Overview

The `run_maestro_test.sh` script provides a comprehensive solution for running Maestro tests,
handling the entire workflow from device preparation to test execution and result capture. It
eliminates the need for manual device setup, app building, and other preparatory steps.

### Command-Line Options

```bash
./scripts/run_maestro_test.sh [OPTIONS] <test_flow_file>
```

**Arguments:**

- `<test_flow_file>` - Path to the Maestro flow YAML file to run (required)

**Options:**

- `-h, --help` - Show help message and exit
- `-a, --ai-report` - Generate an AI-enhanced test report (default: false)
- `-c, --clean` - Clean build before running tests (default: false)
- `-n, --no-video` - Skip video recording (default: record video)

### How It Works

The script performs the following steps:

1. **Environment Detection**
    - Locates Android SDK tools
    - Sets up required environment variables
    - Verifies essential tools like `adb` are available

2. **Device Preparation**
    - Checks for connected devices (physical or emulated)
    - Automatically starts an emulator if no device is available
    - Waits for emulator to boot completely

3. **App Build and Installation**
    - Optionally cleans previous builds
    - Builds the app using Gradle
    - Installs the app on the selected device

4. **Test Execution**
    - Runs the specified Maestro test flow
    - Captures test results and exit status

5. **Result Capture**
    - Records a video of the test (unless disabled)
    - Optionally generates an AI-enhanced test report
    - Saves outputs to organized directories

### Example Usages

**Basic test run with default options:**

```bash
./scripts/run_maestro_test.sh ../flows/hello_world.yaml
```

**Run a test with clean build and AI report:**

```bash
./scripts/run_maestro_test.sh --clean --ai-report ../flows/basic_navigation.yaml
```

**Run a test without video recording:**

```bash
./scripts/run_maestro_test.sh --no-video ../flows/performance_test.yaml
```

## Creating Test Flows

When creating new test flows:

1. Place YAML files in the `flows/` directory
2. Use appropriate subdirectories for organizational purposes
3. Follow the naming convention: `descriptive_name.yaml`
4. Include clear comments in your test flow
5. Test on multiple device types when possible
6. Consider adding both success and failure cases

Example basic structure:

```yaml
appId: com.yourcompany.appname
---
# Test description
- launchApp
- waitForAnimationToEnd
- assertVisible:
    text: "Expected Text"
- tapOn:
    text: "Button Text"
```

## Video Recording

### Current Limitations

Currently, video recording relies on Maestro's cloud service, which:

- Requires an internet connection
- May have privacy implications for sensitive apps
- Can be slower due to upload/download times

### Local Recording Proposal

We're exploring options for local recording without cloud dependencies. See
our [Local Recording Proposal](./local_recording_proposal.md) for detailed information on proposed
approaches using:

- scrcpy for Android recording
- ADB's screenrecord utility
- iOS simulator recording features
- FFmpeg for cross-platform recording

To contribute to this effort, consider implementing and testing one of these approaches and
submitting a pull request.

## AI-Enhanced Reports

The `--ai-report` flag enables generation of AI-enhanced test reports using our custom report
generator. This feature:

1. Captures detailed test execution data
2. Analyzes test results, screenshots, and logs
3. Provides insights on test failures and potential issues
4. Generates a comprehensive HTML report

To contribute to the AI reporting functionality:

1. Examine the `generate_ai_report.py` script in the `scripts/` directory
2. Consider enhancing the analysis algorithms
3. Improve the report visualization
4. Add support for new types of test insights

---

For any questions or suggestions regarding our Maestro testing framework, please open an issue in
the repository or contact the testing team.