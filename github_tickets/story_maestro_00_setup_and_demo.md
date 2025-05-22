# Story: Maestro Setup & Quick Demo

## Summary (TLDR)
* **Purpose**: Quickly set up Maestro UI testing and create a basic demo video
* **Key Activities**: Install Maestro, run & fix sample test, generate demo materials
* **LOE**: Very low - just the essentials to get started
* **Deliverable**: Working Maestro setup, simple passing test with proper test IDs, and shareable
  demo

## Description

This story covers the absolute minimum needed to get Maestro UI testing working with our app and
produce a simple demo to showcase the capability. The focus is on speed and simplicity, providing
just enough to demonstrate the value of UI testing for our hybrid Flutter-Kotlin app. We'll also
ensure the test is robust by using proper accessibility IDs instead of just text matching.

## Tasks

1. **Maestro Setup**
   - Install Maestro CLI using the one-line installer
   - Verify installation with `maestro --version`
   - Run the provided failing test to confirm the setup works

2. **Create a Passing Test with Accessibility Support**
   - Create a simple test that navigates through main app tabs
   - Fix the sample test to pass instead of fail
   - Add proper test/accessibility IDs to Flutter widgets
   - Add content descriptions to Kotlin views
   - Update tests to use IDs instead of text when possible
   - Run the passing test to capture screenshots

3. **Generate Demo Materials**
   - Run test with video recording enabled
   - Use the auto-generated screenshots to create a simple demo
   - (Optional) Use AI to annotate screenshots and create a narrative

4. **Documentation**
   - Document basic test creation process
   - Document best practices for adding test IDs
   - Share with team via Slack/email

## Acceptance Criteria
- Maestro is installed and operational
- A simple test flows successfully without errors
- Flutter widgets have appropriate `semanticsLabel` or `key` properties
- Kotlin views have content descriptions where appropriate
- Tests use accessibility IDs where available, with text as fallback
- Basic demo materials are created (screenshot sequence or video)
- Team members can run the sample test with minimal effort

## Technical Details

This story focuses on using the existing `very_quick_start.md` guide to complete all tasks, with
added emphasis on accessibility.

Sample test code with accessibility IDs:

```yaml
appId: com.example.myflutternavbarapplication
---
# Launch the app
- launchApp
- waitForAnimationToEnd:
    timeout: 5000
# Check for My tab using ID instead of text
- assertVisible:
    id: "tab_my"
    # Fallback if ID isn't found
    or:
      text: "My"
# Tap on Billing tab using ID
- tapOn:
    id: "tab_billing"
    # Fallback if ID isn't found
    or:
      text: "Billing"
# Verify navigation worked
- assertVisible:
    id: "billing_screen_title"
    # Fallback if ID isn't found
    or:
      text: "Billing"
```

### Flutter Widget Test IDs

In Flutter, add test IDs to widgets using keys or semantics:

```
// Using keys for test identification
ElevatedButton(
  key: Key('tab_billing'),
  child: Text('Billing'),
  onPressed: () {},
)

// Using Semantics widget for accessibility and testing
Semantics(
  label: 'tab_my',
  child: Text('My'),
)
```

### Kotlin/Android Test IDs

In Kotlin/Android, add content descriptions:

```
// Add content description in XML
<Button
    android:id="@+id/tab_my"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:contentDescription="tab_my"
    android:text="My" />

// Or add content description programmatically
findViewById<Button>(R.id.tab_my).contentDescription = "tab_my"
```

## Dependencies
- Android emulator or physical device for testing
- Access to the app's source code
- Permission to add test IDs to the codebase
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
- Test runs to completion using at least one accessibility ID
- Screenshots are captured during test execution
- A basic demo sequence can be viewed