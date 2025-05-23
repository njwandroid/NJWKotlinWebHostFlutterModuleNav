# Story: Implement Dashboard Tab with Request Service Navigation

## Summary (TLDR)

**Implement Dashboard tab with a button that navigates to a full-screen Flutter view.**

* **Key Features**:
  * Dashboard implementation (technology TBD)
  * **"Request Service" button** that launches a Flutter view
  * Full-screen navigation with **bottom navigation hidden**
* **Technical Focus**:
  * Proper state management between main flow and service request flow
  * Smooth transitions between views
* **Time Estimate**: 6-8 hours

## Description

Implement the "Dashboard" tab with a "Request Service" button that navigates to a full-screen
Flutter view without the bottom navigation bar.

## Requirements

- Implement Dashboard tab (technology choice TBD based on team decision)
- Add "Request Service" button that navigates to a full-screen Flutter view without bottom
  navigation bar
- Ensure proper state management when returning to Dashboard from the service request flow

## Technical Tasks

- [ ] Create the main Dashboard tab UI
- [ ] Implement dashboard metrics and visualizations
- [ ] Create "Request Service" button with appropriate styling
- [ ] Implement full-screen Flutter view for service request
- [ ] Configure navigation to hide bottom navigation when showing service request
- [ ] Implement proper backstack handling when returning from service request
- [ ] Add appropriate transition animations between views
- [ ] Ensure state preservation when returning to Dashboard

## Acceptance Criteria

- [ ] Dashboard tab displays correctly with metrics and "Request Service" button
- [ ] Clicking "Request Service" navigates to full-screen Flutter view
- [ ] Bottom navigation bar is hidden in service request view
- [ ] Back button correctly returns to Dashboard tab
- [ ] Dashboard state is preserved when returning from service request
- [ ] No visual glitches during transitions

## Dependencies

- Story 1: Setup Base Hybrid App Infrastructure

## Notes

The technology choice for the Dashboard tab itself (Kotlin or Flutter) is TBD and should be decided
based on the team's expertise and project requirements. The service request flow should be a Flutter
implementation regardless of the Dashboard tab implementation choice.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 4/10
- **Likelihood of Manual Steps:** 6/10

### Time Estimate

- **Estimated Hours:** 6-8 hours

### Notes

This story is somewhat simpler than the others as it involves a more straightforward navigation
pattern (main view to full-screen view). The main challenges will be:

1. Creating a visually appealing dashboard with metrics
2. Configuring proper hiding/showing of the bottom navigation bar
3. Ensuring smooth transitions between the dashboard and service request views

If the team decides to implement the Dashboard in Flutter, this will simplify the integration with
the service request flow. If implementing in Kotlin, additional platform channel setup will be
required.

The service request form should follow material design principles and include appropriate validation
to demonstrate best practices in form handling.