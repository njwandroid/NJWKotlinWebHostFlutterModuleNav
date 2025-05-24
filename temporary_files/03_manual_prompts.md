# Manual Prompts - Story 03: Billing Tab Implementation

## 9:05pm - Plan Adjustment: Deep Links as Stretch Goal

### Original Plan Issue

The initial plan included deep linking as a core requirement, but this adds significant complexity
and should be treated as a stretch goal.

### Manual Prompt/Direction

**Rearrange the implementation plan so that deep links become a stretch goal to be done AFTER
everything else is 100% done, including passing Maestro tests.**

### Revised Priority Order

1. **Core Functionality First** (Must be 100% complete before moving to stretch):
    - Flutter billing tab with bill list
    - Navigation from Flutter to Kotlin detail page
    - Proper backstack management
    - State preservation when returning to Flutter
    - **All Maestro tests passing** (excluding deep link tests)

2. **Stretch Goal** (Only after core is 100% complete):
    - Deep linking support for direct navigation to bill details
    - Deep link Maestro tests

### Rationale

- Deep linking requires complex URI scheme setup and intent handling
- Core navigation functionality is more important for the MVP
- Deep links can be added incrementally after the foundation is solid
- Reduces scope creep and allows focus on getting basic functionality working first

### Action Required

Update the DITL file and implementation plan to reflect this prioritization.