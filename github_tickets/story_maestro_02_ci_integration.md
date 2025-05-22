# Story: GitHub Actions Integration for Maestro Tests

## Summary (TLDR)
* **Purpose**: Automate Maestro UI tests in the CI/CD pipeline using GitHub Actions
* **Key Activities**: Set up workflow for Android, iOS, and web platforms
* **Deliverables**: Working GitHub Actions workflow, test reports as artifacts, status checks
* **Benefits**: Cross-platform validation of UI, early detection of regressions, visual test
  evidence

## Description

We need to integrate our Maestro UI tests into our GitHub Actions CI/CD pipeline to ensure that UI
tests run automatically on pull requests and main branch merges. This will help catch regressions
early and provide visual evidence of the app's functionality through screenshots and videos. The
workflow will support Android testing initially, with preparation for web testing that will be
implemented in a separate story.

## Tasks

1. **GitHub Actions Workflow Configuration**
   - Create a new workflow file for Maestro tests
   - Configure the workflow to run on pull requests and pushes to the main branch
   - Set up appropriate triggers and conditions for running tests
   - Structure workflow to accommodate both Android and web platforms
   - Configure caching for dependencies to speed up builds

2. **Android Emulator Setup**
   - Configure an appropriate Android emulator in the GitHub Actions environment
   - Ensure the emulator is set up with the right API level and configuration
   - Optimize emulator settings for CI environment (memory, disk space)
   - Set up scripts to wait for emulator readiness

3. **Maestro Integration**
   - Install Maestro in the GitHub Actions environment
   - Configure Maestro to run against the built app on the emulator
   - Set up test selection logic based on platform (Android vs web)
   - Ensure tests use accessibility IDs for stable identification
   - Configure video recording for test runs

4. **Web Testing Preparation**
   - Add configuration for web platform in the workflow (to be activated later)
   - Ensure workflow structure supports running web tests
   - Document requirements for web Maestro testing
   - Prepare for the web testing story that will follow

5. **Artifact Management**
   - Configure artifact collection for test reports
   - Set up screenshot and video artifact storage
   - Ensure artifacts are retained for an appropriate period
   - Organize artifacts by platform (Android/web)
   - Create clear and descriptive artifact names

6. **Status Checks and Reporting**
   - Configure status checks based on test outcomes
   - Set up notifications for test failures
   - Create summary reports of test results
   - Add links to artifacts in PR comments

## Acceptance Criteria

- GitHub Actions workflow successfully runs Maestro tests on Android for PRs
- Tests execute on an appropriate Android emulator
- Tests use accessibility IDs when available instead of just text matchers
- Screenshots and videos are captured and stored as artifacts
- Workflow structure supports future web testing integration
- Pull requests receive a status check based on test results
- Test failures provide clear information about the failure point
- Workflow completes in a reasonable time (< 15 minutes)
- Artifacts are accessible and organized logically by platform

## Technical Details
The workflow should:

- Use a matrix strategy to define platform configurations
- Use appropriate caching for dependencies and build outputs
- Leverage GitHub Actions' built-in artifact storage
- Have proper retry mechanisms for flaky tests or environment setup
- Execute only relevant tests based on changed files (optional)

Example workflow structure with platform support:

```yaml
name: Maestro UI Tests

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  maestro-tests:
    strategy:
      matrix:
        platform: [android] # web will be added later
        include:
          - platform: android
            runs-on: macos-latest
            test-path: maestro/flows/android
    
    runs-on: ${{ matrix.runs-on }}
    timeout-minutes: 30
    
    steps:
      - uses: actions/checkout@v3
      
      # Setup steps (Java, Flutter, Android SDK, etc.)
      
      # Platform-specific build and setup
      - name: Build app for ${{ matrix.platform }}
        run: |
          if [ "${{ matrix.platform }}" == "android" ]; then
            ./gradlew assembleDebug
          fi
      
      # Start emulator (Android only)
      - name: Start Android emulator
        if: matrix.platform == 'android'
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 29
          script: echo "Emulator started"
      
      # Install Maestro
      - name: Install Maestro
        run: curl -Ls "https://get.maestro.mobile.dev" | bash
      
      # Run tests
      - name: Run Maestro tests
        run: |
          source ~/.maestro/bin/maestro-env.sh
          maestro test --format=junit ${{ matrix.test-path }}
      
      # Upload artifacts
      - name: Upload test results
        uses: actions/upload-artifact@v3
        with:
          name: maestro-${{ matrix.platform }}-results
          path: .maestro/
```

## Dependencies
- Android app building in GitHub Actions
- Emulator configuration optimized for CI
- Maestro test flows already created with accessibility IDs
- Consistent app behavior in CI environment

## Story Points
5 points (3-5 days of work)

## AI Assistance Analysis

### Claude 3.7 Sonnet
- **LOE with Firebender**: 8/10 (Excellent for GitHub Actions YAML generation)
- **Likelihood of Success**: 9/10 (Well-documented process with many examples)
- **Likelihood of Frustration**: 6/10 (Emulator configuration can be tricky)
- **Likelihood of Manual Steps**: 5/10 (Mostly automatable with some trial and error)
- **Estimated Hours**: 10-15 hours

### Gemini 2.5 Pro
- **LOE with Firebender**: 8/10 (Good for workflow configurations and examples)
- **Likelihood of Success**: 8/10 (High but may require more tweaking)
- **Likelihood of Frustration**: 7/10 (May need more specific guidance)
- **Likelihood of Manual Steps**: 6/10 (Similar manual setup requirements)
- **Estimated Hours**: 12-18 hours

## Simplest Bare Minimum Test Cases
- The workflow successfully starts and configures an Android emulator
- Maestro is properly installed in the GitHub Actions environment
- At least one test using accessibility IDs runs successfully in CI
- Screenshots are captured and saved as artifacts
- Test results are reported back to the PR as a status check
- Workflow structure allows for future web testing implementation