# Story: Maestro Setup & Quick Demo

## Summary (TLDR)

* **Purpose**: Quickly set up Maestro UI testing and create a basic demo video
* **Key Activities**: Install Maestro, run & fix sample test, generate demo materials
* **LOE**: Very low - just the essentials to get started
* **Deliverable**: Working Maestro setup, simple passing test, and shareable demo

## Description

This story covers the absolute minimum needed to get Maestro UI testing working with our app and
produce a simple demo to showcase the capability. The focus is on speed and simplicity, providing
just enough to demonstrate the value of UI testing for our hybrid Flutter-Kotlin app.

## Tasks

1. **Maestro Setup**
    - Install Maestro CLI using the one-line installer
    - Verify installation with `maestro --version`
    - Run the provided failing test to confirm the setup works

2. **Create a Passing Test**
    - Create a simple test that navigates through main app tabs
    - Fix the sample test to pass instead of fail
    - Run the passing test to capture screenshots

3. **Generate Demo Materials**
    - Run test with video recording enabled
    - Use the auto-generated screenshots to create a simple demo
    - (Optional) Use AI to annotate screenshots and create a narrative

4. **Documentation**
    - Document basic test creation process
    - Share with team via Slack/email

## Acceptance Criteria

- Maestro is installed and operational
- A simple test flows successfully without errors
- Basic demo materials are created (screenshot sequence or video)
- Team members can run the sample test with minimal effort

## Technical Details

This story focuses on using the existing `very_quick_start.md` guide to complete all tasks. No
advanced Maestro features are required at this stage.

Sample test code is already provided:

```yaml
appId: com.example.myflutternavbarapplication
---
# Launch the app
- launchApp
- waitForAnimationToEnd:
    timeout: 5000
- assertVisible:
    text: "My"
- tapOn:
    text: "Billing"
- assertVisible:
    text: "Billing"
```

## Dependencies

- Android emulator or physical device for testing
- Access to the app's source code
- Python 3.x (only if using the AI report generation script)

## Story Points

2 points (very small task)

## AI Assistance Analysis

### Claude 3.7 Sonnet

- **LOE with Firebender**: 8/10 (Excellent for generating demo materials from screenshots)
- **Likelihood of Success**: 10/10 (Very straightforward implementation)
- **Likelihood of Frustration**: 2/10 (Minimal complexity)
- **Likelihood of Manual Steps**: 4/10 (Mostly automated with a few manual steps)
- **Estimated Hours**: 2-3 hours

### Gemini 2.5 Pro

- **LOE with Firebender**: 7/10 (Good but may need more specific prompting)
- **Likelihood of Success**: 9/10 (High success rate with minimal complexity)
- **Likelihood of Frustration**: 3/10 (Slightly more complicated prompting)
- **Likelihood of Manual Steps**: 4/10 (Similar level of manual intervention)
- **Estimated Hours**: 2-4 hours

## Simplest Bare Minimum Test Cases

- Maestro installs successfully
- Sample test runs to completion
- Screenshots are captured during test execution
- A basic demo sequence can be viewed