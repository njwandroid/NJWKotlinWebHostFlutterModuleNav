# Story: Maestro Web Testing Demo

## Summary (TLDR)

* **Purpose**: Implement and demonstrate Maestro testing for the web version of our app
* **Key Activities**: Configure Maestro for web testing, adapt tests, create demo materials
* **Deliverables**: Working web test flows, demo video, documentation
* **Benefits**: Cross-platform test coverage, increased confidence in web deployment

## Description

As we expand our app to support web platforms, we need to ensure our testing strategy includes web
testing. This story focuses on setting up Maestro to test the web version of our app, adapting
existing tests where possible, and creating a demonstration of the web testing capabilities.

## Tasks

1. **Maestro Web Setup**
    - Research Maestro web testing capabilities and limitations
    - Install necessary prerequisites for web testing
    - Configure Chrome WebDriver for Maestro
    - Set up proper debugging tools for web tests

2. **Adapt Existing Tests for Web**
    - Create a web-specific test directory
    - Update accessibility selectors for web platform specifics
    - Adapt navigation tests to work with web DOM structure
    - Ensure proper handling of web-specific elements

3. **Create Web-Specific Test Flows**
    - Develop tests for web-specific features (responsive layouts)
    - Implement tests for browser navigation (back/forward)
    - Create tests for web-specific user interactions
    - Handle web viewport variations

4. **Web Testing Infrastructure**
    - Document web testing prerequisites
    - Prepare web test specific configuration files
    - Create documentation for running web tests locally
    - Enable web tests in the CI pipeline configuration (refer to prior CI story)

5. **Generate Demo Materials**
    - Run tests with video recording
    - Create a side-by-side comparison of Android vs Web tests
    - Document web-specific testing considerations
    - Create a demo presentation showcasing cross-platform testing

## Acceptance Criteria

- Maestro successfully runs tests against the web version of our app
- At least 3 core test flows are adapted to work on both Android and web
- Tests use accessibility IDs common across platforms where possible
- Web-specific test flows demonstrate responsive layout testing
- Demo materials show the value of cross-platform testing
- Documentation is updated with web testing instructions
- Web testing is configured in CI pipeline (but may not be activated yet)

## Technical Details

Maestro supports web testing but requires some specific considerations:

1. **Web-Specific Selectors**:
    - CSS selectors for web elements
    - Maestro web-specific commands
    - Use of `data-testid` attributes for cross-platform compatibility

2. **Example Web Test**:

```yaml
appUrl: http://localhost:5000
---
# Navigate to the app
- launchUrl: ${appUrl}
  
# Wait for the app to load
- waitForAnimationToEnd:
    timeout: 5000
  
# Verify navigation elements using testids
- assertVisible:
    id: "tab_my"
    
# Click on a navigation element
- tapOn:
    id: "tab_billing"
    
# Verify navigation worked
- assertVisible:
    id: "billing_screen_title"
```

3. **Cross-Platform Test Organization**:

```
maestro/
├── flows/
│   ├── android/   # Android-specific flows
│   ├── web/       # Web-specific flows
│   └── common/    # Platform-agnostic flows
```

## Dependencies

- Web version of the app must be deployable locally
- Chrome browser must be available for testing
- Web app must have proper test IDs implemented
- Prior Maestro setup story must be completed

## Story Points

4 points (2-4 days of work)

## AI Assistance Analysis

### Claude 3.7 Sonnet

- **LOE with Firebender**: 7/10 (Good for generating test flows, documentation)
- **Likelihood of Success**: 8/10 (Web testing is well-supported)
- **Likelihood of Frustration**: 5/10 (Some web-specific challenges expected)
- **Likelihood of Manual Steps**: 6/10 (Web environment setup may need manual tweaking)
- **Estimated Hours**: 8-12 hours

### Gemini 2.5 Pro

- **LOE with Firebender**: 7/10 (Similar capabilities for web testing)
- **Likelihood of Success**: 7/10 (May need more fine-tuning for web specifics)
- **Likelihood of Frustration**: 6/10 (More complex DOM structure may challenge test generation)
- **Likelihood of Manual Steps**: 7/10 (More manual intervention likely)
- **Estimated Hours**: 10-14 hours

## Simplest Bare Minimum Test Cases

- Maestro successfully launches the web app under test
- Tests can identify elements using test IDs in the web DOM
- Navigation between tabs works in the web version
- Screenshots are captured showing web UI
- A simple demo shows the same test working on both Android and web