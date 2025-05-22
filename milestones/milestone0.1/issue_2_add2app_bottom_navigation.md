# ISSUE 2: Add2App Bottom Navigation Demo

## Description

Create a demonstration of Flutter's Add2App functionality by implementing a bottom navigation bar in
a native Android application with Flutter modules embedded as screens. This will showcase how
Flutter can be incrementally adopted within existing native applications.

## Time Allocation

- 80 minutes

## Objectives

- Implement a native Android bottom navigation bar
- Create Flutter modules to be embedded as screens
- Demonstrate seamless navigation between native and Flutter components
- Set up communication between native and Flutter parts

## Tasks

1. Set up native Android project with BottomNavigationView (15 min)
    - Configure basic native Android application
    - Implement BottomNavigationView with 3-4 navigation items
    - Create placeholder fragments for each navigation item

2. Create Flutter modules (20 min)
    - Set up a Flutter module project
    - Create 2 simple Flutter screens with distinct UI
    - Add basic interaction elements to demonstrate Flutter functionality

3. Integrate Flutter modules into native Android app (25 min)
    - Configure the Android app to embed Flutter modules
    - Replace 2 of the native fragments with Flutter views
    - Ensure proper lifecycle management

4. Implement communication between native and Flutter (20 min)
    - Set up MethodChannel for bidirectional communication
    - Create example of data passing from Android to Flutter
    - Create example of Flutter triggering native functionality

## Deliverables

- Native Android app with bottom navigation
- Flutter modules embedded as screens
- Working navigation between native and Flutter screens
- Demonstration of data passing between platforms
- Pull request with implementation and documentation

## Acceptance Criteria

1. Bottom navigation bar successfully navigates between tabs
2. Flutter modules are properly embedded in the native app
3. Navigation maintains proper state across tab switches
4. Communication between native and Flutter works bidirectionally
5. Code follows best practices for both Android and Flutter
6. PR includes documentation on the integration approach

## Dependencies

- Android development environment
- Flutter development environment
- Understanding of Android BottomNavigationView
- Basic knowledge of Flutter's Add2App functionality