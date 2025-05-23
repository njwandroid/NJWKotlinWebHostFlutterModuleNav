# Story: Implement My Tab with Mixed-Technology Navigation

## Summary (TLDR)

**Implement the My tab (Kotlin) with two distinct navigation patterns to Flutter views.**

* **Key Features**:
  * **"Review Contact Info" button**: Navigates to Flutter view **keeping bottom nav visible**
  * **"Add Person" button**: Navigates to Flutter view as **full-screen** (bottom nav hidden)
  * Loading spinner demonstration in Flutter view
* **Technical Focus**:
  * Maintaining proper backstack behavior between technologies
  * State preservation when returning to native view
* **Time Estimate**: 8-10 hours

## Description

Implement the "My" tab as a native Kotlin view with navigation to Flutter views, demonstrating both
in-tab navigation (with bottom navigation visible) and full-screen navigation (without bottom
navigation).

## Requirements

- Implement My tab as a native Kotlin view
- Add "Review Contact Info" button that navigates to a Flutter view while keeping bottom navigation
  visible
- Add "Add Person" button that navigates to a Flutter view without bottom navigation
- Implement spinner/loading state for the "Add Person" flow
- Ensure proper backstack management when returning from Flutter views

## Technical Tasks

- [ ] Create the main My tab UI in Kotlin
- [ ] Implement "Review Contact Info" button with navigation to Flutter view
- [ ] Configure Flutter view for contact info review that preserves bottom navigation
- [ ] Implement "Add Person" button with navigation to full-screen Flutter view
- [ ] Create Flutter "Add Person" view with spinner/loading state
- [ ] Implement proper backstack handling for both navigation patterns
- [ ] Add appropriate transition animations between views
- [ ] Handle state preservation when returning from Flutter views

## Acceptance Criteria

- [ ] My tab displays correctly with both navigation buttons
- [ ] "Review Contact Info" button navigates to a Flutter view with bottom navigation still visible
- [ ] "Add Person" button navigates to a full-screen Flutter view (without bottom navigation)
- [ ] "Add Person" view shows a loading spinner
- [ ] Back button works correctly in all scenarios:
    - From "Review Contact Info" view back to My tab
    - From "Add Person" view back to My tab
- [ ] State is preserved when navigating back to My tab
- [ ] No visual glitches during transitions

## Dependencies

- Story 1: Setup Base Hybrid App Infrastructure

## Notes

This story demonstrates two key navigation patterns:

1. In-tab navigation where the bottom navigation remains visible
2. Full-screen navigation where the bottom navigation is hidden

Both patterns need to maintain proper backstack behavior and state preservation.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium-High
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 8/10
- **Likelihood of Frustration:** 5/10
- **Likelihood of Manual Steps:** 7/10

### Time Estimate

- **Estimated Hours:** 8-10 hours

### Notes

This story introduces the first complex navigation patterns between Kotlin and Flutter. The main
challenges will be:

1. Configuring Flutter views to either preserve or hide the bottom navigation bar
2. Ensuring proper backstack behavior when navigating between different technology stacks
3. Handling state preservation when returning to the My tab

The spinner/loading state in Flutter should be implemented using standard Flutter widgets like
CircularProgressIndicator, but will require careful coordination with the navigation transitions to
avoid jarring visual effects.

The Flutter embedding API provides mechanisms for this type of integration, but there are edge cases
around lifecycle management that may require custom solutions.