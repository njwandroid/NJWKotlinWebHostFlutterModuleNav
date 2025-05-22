# Epic: Multi-Technology Hybrid App with Advanced Navigation Patterns

## Summary (TLDR)

**Create a hybrid Android application demonstrating seamless navigation between Flutter and Kotlin
views.**

* **Core Tech**: Flutter module embedded in Kotlin Android app
* **Key Features**:
    * Bottom navigation with 5 tabs (My, Billing, Dashboard, Items, ThTif)
    * Both **in-tab navigation** (nav bar visible) and **full-screen** flows (nav bar hidden)
    * **Cross-technology transitions** in both directions (Flutter↔Kotlin)
    * **Deep linking** to specific screens regardless of technology
* **Primary Goal**: Demonstrate consistent backstack behavior across technology boundaries
* **Time Estimate**: 50-70 hours total implementation

## Description

Implement a comprehensive hybrid application that combines native Kotlin and Flutter views with
sophisticated navigation patterns. The app will demonstrate various navigation scenarios including
in-tab navigation, full-screen views, and deep linking capabilities across different technology
implementations.

## Core Requirements

- Bottom navigation bar with 5 tabs: My, Billing, Dashboard, Items, and ThTif
- Navigation bar implemented in Flutter
- Consistent backstack behavior across technology boundaries
- Deep linking support to specific screens

## Subtasks

### 1. Setup Project Infrastructure

- [ ] Initialize Android Kotlin host project
- [ ] Create Flutter module
- [ ] Configure Flutter embedding in Android
- [ ] Set up platform channels for communication
- [ ] Implement bottom navigation framework

### 2. My Tab (Kotlin Host View)

- [ ] Implement base Kotlin host view
- [ ] Add "Review Contact Info" CTA button that navigates to a Flutter view while keeping bottom
  navigation visible
- [ ] Add "Add Person" button that navigates to a Flutter view without bottom navigation (separate
  section)
- [ ] Implement spinner/loading state for the "Add Person" flow
- [ ] Ensure proper backstack management when returning from Flutter views

### 3. Billing Tab (Flutter View with Kotlin Navigation)

- [ ] Implement base Flutter Billing view
- [ ] Create navigation to a Kotlin Item Detail Page for a bill
- [ ] Implement deep linking capabilities to the bill detail page
- [ ] Configure proper backstack behavior when navigating between Flutter and Kotlin

### 4. Dashboard Tab

- [ ] Implement base Dashboard view
- [ ] Add "Request Service" button that navigates to a Flutter view without bottom navigation bar
- [ ] Ensure proper state management when returning to Dashboard from the service request flow

### 5. Items Tab (Flutter ListView)

- [ ] Implement Flutter ListView displaying multiple items
- [ ] Create Item Detail page in Flutter
- [ ] Configure special behavior for Item7 that links to the detail page
- [ ] Implement deep linking capabilities to the Item7 detail page
- [ ] Ensure proper list state preservation when navigating back

### 6. ThTif Tab (Cross-Technology Navigation Demo)

- [ ] Implement Flutter view with title "To Host Then Inner Flutter"
- [ ] Add "To Host" button that navigates to a Kotlin view
- [ ] Add "To Inner Flutter View" button for Flutter-to-Flutter navigation
- [ ] Demonstrate both in-tab and full-screen navigation variants
- [ ] Ensure clean backstack behavior across all navigation scenarios

### 7. Deep Linking Infrastructure

- [ ] Implement deep link handlers in the Android host
- [ ] Configure Flutter to respond to deep links
- [ ] Create test cases for direct navigation to:
    - [ ] Bill detail page (Kotlin)
    - [ ] Item7 detail page (Flutter)
- [ ] Document deep link URL formats

### 8. Backstack Management

- [ ] Ensure consistent back button behavior across all views
- [ ] Maintain tab state when switching between tabs
- [ ] Handle proper state restoration when returning from full-screen views
- [ ] Test complex navigation scenarios involving multiple technology transitions

## Technical Considerations

- Integration between Kotlin host and Flutter views should be seamless
- Activity/Fragment lifecycle must be properly managed
- Consider memory management in complex navigation scenarios
- Implement proper error handling for cross-technology communication

## Acceptance Criteria

- [ ] All tabs function as specified with their respective technology implementations
- [ ] Navigation works smoothly between Kotlin and Flutter views in all scenarios
- [ ] Bottom navigation bar appears/disappears according to requirements for each screen
- [ ] Deep links correctly navigate to specified screens
- [ ] Back button behaves consistently and predictably throughout the app
- [ ] App maintains proper state when navigating between tabs
- [ ] No visual glitches or UI anomalies during transitions

## Priority

High

## Estimated Effort

1.5-2 weeks

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium-Low

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 6/10
- **Likelihood of Manual Steps:** 8/10

### Time Estimate

- **Estimated Hours:** 50-70 hours

### Notes

This hybrid integration project involves complex navigation patterns across two different technology
stacks. The most challenging aspects will be:

1. Maintaining consistent backstack behavior when crossing technology boundaries
2. Implementing deep linking correctly for both Kotlin and Flutter views
3. Managing lifecycle events when transitioning between technologies
4. Ensuring UI consistency between native and Flutter components

Flutter-Android integration has improved significantly in recent releases, but this particular
implementation with multiple navigation patterns will require careful architecture planning. Expect
to spend approximately 30% of development time working through integration edge cases and backstack
management.