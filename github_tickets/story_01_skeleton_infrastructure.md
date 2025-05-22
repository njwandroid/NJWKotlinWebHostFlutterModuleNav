# Story: Setup Base Hybrid App Infrastructure

## Summary (TLDR)

**Set up foundational infrastructure for combining Flutter and Kotlin in a single app.**

* **Key Setup**:
   * Android project with Kotlin support
   * Flutter module properly embedded in Android
   * Bottom navigation with 5 tabs
   * Platform channel for basic Flutter-Kotlin communication
* **Goal**: Create working project structure that supports future navigation features
* **Time Estimate**: 10-12 hours

## Description

Set up the foundational infrastructure for a hybrid Kotlin-Flutter application with a bottom
navigation bar. This includes initializing the Android Kotlin project, creating a Flutter module,
and establishing basic communication between the two.

## Requirements

- Initialize Android project with Kotlin support
- Create Flutter module that can be embedded in Android
- Implement basic bottom navigation bar in Flutter
- Configure Flutter embedding in Android
- Set up platform channels for basic communication between Kotlin and Flutter

## Technical Tasks

- [ ] Create Android project with appropriate dependencies (Kotlin, AndroidX, etc.)
- [ ] Set up Flutter module with dependency configuration
- [ ] Configure Flutter engine initialization in the Android host
- [ ] Implement basic FlutterActivity/FlutterFragment handling
- [ ] Create stub implementations of all 5 tab screens
- [ ] Implement basic platform channel for communication between Kotlin and Flutter
- [ ] Set up project structure for proper code organization
- [ ] Create documentation for project setup and architecture

## Acceptance Criteria

- [ ] Android app builds and launches successfully
- [ ] Flutter module builds and can be displayed within the Android app
- [ ] Bottom navigation bar displays with 5 tabs (My, Billing, Dashboard, Items, ThTif)
- [ ] Basic navigation between tabs works (no complex navigation yet)
- [ ] Simple data can be passed between Kotlin and Flutter
- [ ] Project structure supports future development of complex features

## Dependencies

- None (first story in the epic)

## Notes

This story focuses only on setting up the infrastructure and does not include implementation of the
specific tab functionalities or complex navigation patterns. These will be addressed in subsequent
stories.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 4/10
- **Likelihood of Manual Steps:** 6/10

### Time Estimate

- **Estimated Hours:** 10-12 hours

### Notes

This initial setup story focuses on establishing the project foundation. While most of these tasks
are well-documented in both Flutter and Android documentation, there are several manual
configuration steps required to ensure proper Flutter embedding in the Android host application.

Key challenges include:

1. Setting up proper module dependencies between Flutter and Android
2. Configuring the initial navigation structure
3. Establishing a clean architecture that will support the more complex navigation patterns in
   future stories

Consider using Flutter's official add-to-app documentation as a starting point, but be prepared to
make custom modifications for the specific navigation requirements of this project.