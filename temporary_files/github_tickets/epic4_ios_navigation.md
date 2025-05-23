# Epic: iOS-Flutter Hybrid Navigation App

## Summary (TLDR)

**Create a hybrid iOS application demonstrating seamless navigation patterns between Swift and
Flutter views.**

* **Core Tech**:
    * Flutter module embedded in Swift iOS app
    * **UIKit-based** navigation with FlutterViewController integration
* **Key Features**:
    * Bottom tab bar with 5 tabs (My, Billing, Dashboard, Items, ThTif)
    * Both **in-tab navigation** (tab bar visible) and **modal presentations** (tab bar hidden)
    * **Cross-technology transitions** in both directions (Flutter↔Swift)
    * **Deep linking** to specific screens using Universal Links
* **Primary Goal**: Demonstrate consistent navigation experience across technology boundaries
* **Optimization**: Focused on iOS Simulator experience for easier testing
* **Time Estimates**:
    * For developer with limited iOS/Swift experience: **80-100 hours**
    * For experienced iOS/Swift developer: **50-70 hours**

## Description

Implement a comprehensive hybrid application that combines native Swift and Flutter views with
sophisticated navigation patterns on iOS. The app will demonstrate various navigation scenarios
including in-tab navigation, modal presentations, and deep linking capabilities across different
technology implementations.

## Core Requirements

- Bottom tab bar with 5 tabs: My, Billing, Dashboard, Items, and ThTif
- Tab bar implemented natively in UIKit
- Consistent backstack behavior across technology boundaries
- Deep linking support to specific screens using Universal Links
- Optimized for demonstration in iOS Simulator

## Subtasks

### 1. Setup Project Infrastructure

- [ ] Initialize iOS Swift project with proper architecture
- [ ] Create Flutter module
- [ ] Configure Flutter embedding in iOS using FlutterEngine
- [ ] Set up method channels for communication
- [ ] Implement bottom tab bar framework in UIKit

### 2. My Tab (Swift Host View)

- [ ] Implement base Swift host view
- [ ] Add "Review Contact Info" button that navigates to a Flutter view while keeping tab bar
  visible
- [ ] Add "Add Person" button that navigates to a Flutter view without tab bar (modal presentation)
- [ ] Implement activity indicator for the "Add Person" flow
- [ ] Ensure proper navigation stack management when returning from Flutter views

### 3. Billing Tab (Flutter View with Swift Navigation)

- [ ] Implement base Flutter Billing view
- [ ] Create navigation to a Swift Item Detail Page for a bill
- [ ] Implement deep linking capabilities to the bill detail page
- [ ] Configure proper navigation behavior when moving between Flutter and Swift

### 4. Dashboard Tab

- [ ] Implement base Dashboard view
- [ ] Add "Request Service" button that navigates to a Flutter view without tab bar
- [ ] Ensure proper state management when returning to Dashboard from the service request flow

### 5. Items Tab (Flutter ListView)

- [ ] Implement Flutter ListView displaying multiple items
- [ ] Create Item Detail page in Flutter
- [ ] Configure special behavior for Item7 that links to the detail page
- [ ] Implement deep linking capabilities to the Item7 detail page
- [ ] Ensure proper list state preservation when navigating back

### 6. ThTif Tab (Cross-Technology Navigation Demo)

- [ ] Implement Flutter view with title "To Host Then Inner Flutter"
- [ ] Add "To Host" button that navigates to a Swift view
- [ ] Add "To Inner Flutter View" button for Flutter-to-Flutter navigation
- [ ] Demonstrate both in-tab and modal presentation variants
- [ ] Ensure clean navigation stack behavior across all navigation scenarios

### 7. Deep Linking Infrastructure

- [ ] Implement Universal Links handlers in the iOS host
- [ ] Configure Flutter to respond to deep links
- [ ] Create test cases for direct navigation to:
    - [ ] Bill detail page (Swift)
    - [ ] Item7 detail page (Flutter)
- [ ] Document deep link URL formats

### 8. Navigation Stack Management

- [ ] Ensure consistent back button behavior across all views
- [ ] Maintain tab state when switching between tabs
- [ ] Handle proper state restoration when returning from modal views
- [ ] Test complex navigation scenarios involving multiple technology transitions

### 9. Firebase App Distribution (Stretch Goal)

- [ ] Configure Firebase in the iOS project
- [ ] Set up code signing and provisioning profiles
- [ ] Create build scripts for App Distribution
- [ ] Document the deployment process
- [ ] Create a test group and distribute the app

## Technical Considerations

- Integration between Swift host and Flutter views using FlutterViewController
- UIViewController lifecycle management with Flutter integration
- Memory management in complex navigation scenarios
- iOS-specific navigation patterns (push, modal, tab-based)
- Universal Links configuration for deep linking
- Development focused on Simulator for easier testing

## Acceptance Criteria

- [ ] All tabs function as specified with their respective technology implementations
- [ ] Navigation works smoothly between Swift and Flutter views in all scenarios
- [ ] Tab bar appears/disappears according to requirements for each screen
- [ ] Universal Links correctly navigate to specified screens
- [ ] Back button behaves consistently and predictably throughout the app
- [ ] App maintains proper state when navigating between tabs
- [ ] No visual glitches or UI anomalies during transitions
- [ ] App can be easily demonstrated in iOS Simulator
- [ ] (Optional) App can be distributed to testers via Firebase App Distribution

## Priority

Medium

## Estimated Effort

1.5-2.5 weeks (depending on iOS/Swift experience)

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** High
- **LOE with Firebender using Gemini 2.5 Pro:** High

### Project Metrics for Developer with Limited iOS/Swift Experience (Scale 1-10)

- **Likelihood of Success:** 6/10
- **Likelihood of Frustration:** 8/10
- **Likelihood of Manual Steps:** 9/10

### Project Metrics for Experienced iOS/Swift Developer (Scale 1-10)

- **Likelihood of Success:** 8/10
- **Likelihood of Frustration:** 6/10
- **Likelihood of Manual Steps:** 8/10

### Time Estimate

- **For developer with limited iOS/Swift experience:** 80-100 hours
- **For experienced iOS/Swift developer:** 50-70 hours

### Notes

This iOS hybrid integration project presents several unique challenges compared to the Android
version:

1. iOS has different navigation paradigms (push navigation, modal presentations) that must be
   properly integrated with Flutter
2. FlutterViewController lifecycle management is more complex than Android's FlutterActivity
3. Universal Links configuration requires proper entitlements and associated domains
4. Memory management between Swift and Flutter requires careful attention

Due to the limited Swift/iOS experience, expect significant time investment in understanding iOS
architecture concepts and Flutter integration patterns. The Firebase App Distribution stretch goal
adds complexity due to iOS code signing and provisioning requirements.

Key differences from the Android version:

1. UIKit navigation stack vs Android's activity/fragment stack
2. Universal Links vs Android deep links
3. Different embedding mechanism for Flutter
4. iOS simulator-specific considerations

The focus on simulator testing will simplify development by avoiding device-specific issues and code
signing requirements until the optional Firebase distribution step.