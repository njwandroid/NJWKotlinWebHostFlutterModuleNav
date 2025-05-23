# Story: Validating Maestro Tests After Kotlin Refactoring

## Summary (TLDR)

* **Purpose**: Ensure Maestro tests remain functional after refactoring Kotlin code
* **Key Activities**: Update a Kotlin screen, verify tests still pass, add resilient test IDs
* **Deliverables**: Refactored Kotlin code, updated tests with improved selectors
* **Benefits**: Demonstrate test stability during refactoring, establish best practices

## Description

This story focuses on demonstrating how well-designed Maestro tests can remain stable during code
refactoring. We will refactor parts of our Kotlin UI code while maintaining or improving the test
coverage. This will help establish best practices for creating robust tests that don't break with
implementation changes.

## Tasks

1. **Review and Select Refactoring Target**
    - Identify a Kotlin screen that could benefit from refactoring
    - Review the existing tests that cover this screen
    - Document current implementation and test behavior
    - Define the scope of refactoring changes

2. **Implement Test IDs in Kotlin Code**
    - Add proper content descriptions to all interactive elements
    - Ensure test IDs follow a consistent naming convention
    - Document the test ID strategy for Kotlin views
    - Update existing tests to use these IDs if necessary

3. **Refactor Kotlin Implementation**
    - Refactor the selected screen (improve architecture, performance, etc.)
    - Ensure all refactored elements maintain their test IDs
    - Make at least one significant UI change that would break text-based tests
    - Maintain functionality while changing implementation details

4. **Verify and Update Tests**
    - Run existing Maestro tests against refactored code
    - Fix any test failures by improving selector robustness
    - Document changes required to make tests pass
    - Demonstrate the resilience of ID-based testing

5. **Document Best Practices**
    - Create guidelines for maintaining test stability during refactoring
    - Document patterns that worked well for test resilience
    - Create examples of good vs. bad test selectors
    - Share findings with the team

## Acceptance Criteria

- A Kotlin screen is successfully refactored with improved implementation
- Maestro tests continue to pass after refactoring (or are minimally updated)
- All UI elements have proper content descriptions for testing
- Documentation is created for best practices in test stability
- A demo shows how the tests remain functional despite code changes

## Technical Details

### Recommended Refactoring Approach:

1. First implement consistent content descriptions/test IDs
2. Update tests to use these IDs with text fallbacks
3. Then refactor the implementation with confidence

### Example Content Description in Kotlin:

```kotlin
// Before refactoring - add content descriptions
binding.myButton.apply {
    contentDescription = "action_submit"
    setOnClickListener { /* existing code */ }
}

// After refactoring - maintain the same content descriptions
CustomSubmitButton(context).apply {
    contentDescription = "action_submit"
    setOnClick { /* new implementation */ }
}
```

### Example Maestro Test Update:

```yaml
# Robust test with ID and text fallback
- tapOn:
    id: "action_submit"
    # Fallback if ID isn't found
    or:
      text: "Submit"

# More specific matching for better stability
- assertVisible:
    id: "user_profile"
    className: "androidx.appcompat.widget.LinearLayoutCompat"
```

## Dependencies

- Existing Kotlin screens to refactor
- Permission to modify production code
- Maestro tests already running against the target screen
- Previous Maestro setup stories must be completed

## Story Points

3 points (1-2 days of work)

## AI Assistance Analysis

### Claude 3.7 Sonnet

- **LOE with Firebender**: 6/10 (Less helpful for the Kotlin refactoring itself)
- **Likelihood of Success**: 9/10 (Straightforward with clear scope)
- **Likelihood of Frustration**: 4/10 (Minor challenges expected)
- **Likelihood of Manual Steps**: 8/10 (Refactoring requires manual work)
- **Estimated Hours**: 6-10 hours

### Gemini 2.5 Pro

- **LOE with Firebender**: 5/10 (Similar limitations for Kotlin refactoring)
- **Likelihood of Success**: 8/10 (Still high likelihood of success)
- **Likelihood of Frustration**: 5/10 (May need more specific guidance)
- **Likelihood of Manual Steps**: 8/10 (Similar manual refactoring needs)
- **Estimated Hours**: 7-12 hours

## Simplest Bare Minimum Test Cases

- Content descriptions added to key UI elements in Kotlin code
- At least one Kotlin screen is refactored (e.g., changing layout structure)
- Maestro tests for the refactored screen pass without text-based changes
- Documentation describes the ID-based testing approach
- A simple before/after comparison shows the refactoring changes