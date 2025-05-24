# ISSUE 3: Android Native <-> Flutter Navigation

## Description

Implement bidirectional navigation between native Android components and Flutter screens,
demonstrating how to launch specific Flutter routes from Android and how to trigger native Android
actions from Flutter screens.

## Time Allocation

- 70 minutes

## Objectives

- Demonstrate navigation from native Android to specific Flutter screens
- Implement communication from Flutter back to native Android
- Validate backstack behavior between native and Flutter components

## Tasks

1. Implement launching a Flutter route from native Android (30 min)
    - Create a simple native Android Activity
    - Add code to launch a specific Flutter route (e.g., NativeDemoScreen)
    - Ensure proper parameter passing if applicable

2. Implement Flutter to native Android communication (30 min)
    - Set up MethodChannel for Flutter-to-native communication
    - Add a button on the Flutter screen to trigger a native action
    - Implement a simple native action (e.g., show Toast or log message)

3. Test backstack behavior (10 min)
    - Verify back button correctly returns from Flutter to native
    - Check that native-to-Flutter-to-native navigation preserves state
    - Document any issues or unexpected behaviors

## Deliverables

- Native Android Activity with Flutter launch capability
- Flutter screen with native action trigger
- Documentation of the navigation flow and implementation approach
- Working demo of bidirectional navigation

## Acceptance Criteria

1. Native Android can successfully launch a specific Flutter screen
2. Flutter screen can trigger an action in the native Android code
3. Back button navigation works correctly in both directions
4. State is preserved appropriately during navigation
5. Implementation follows Android and Flutter best practices

## Dependencies

- Completion of issues #1 and #2
- Basic understanding of Android Activities and Flutter MethodChannel