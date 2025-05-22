# Story: Set Up Pigeon and Implement App Bar Title Update Example

## Summary (TLDR)

**Set up Pigeon for type-safe Flutter-Kotlin communication with visual demonstration.**

* **Key Features**:
    * Configure Pigeon code generation pipeline
    * Create API for **bidirectional title updates**
    * Flutter → Android: Update app bar title
    * Android → Flutter: Update Flutter displayed title
* **Technical Focus**:
    * Visual demonstration of cross-platform communication
    * Immediate feedback when API calls succeed
* **Time Estimate**: 6-8 hours

## Description

Set up Pigeon in the project and implement the first example that demonstrates cross-platform
communication by allowing Flutter to update the Android app bar title and vice versa. This provides
a visual, easy-to-understand demonstration of bidirectional platform communication.

## Requirements

- Configure Pigeon in the Flutter-Android project
- Set up code generation pipeline
- Create a simple API for updating app bar titles
- Implement bidirectional communication (Flutter → Android and Android → Flutter)
- Provide visual feedback on both platforms when titles are updated

## Technical Tasks

- [ ] Add Pigeon dependency to pubspec.yaml
- [ ] Create Pigeon API definition file (e.g., app_bar_api.dart)
- [ ] Configure build process to generate Pigeon code
- [ ] Implement Flutter UI with input field and button for title updates
- [ ] Implement Android side handler for Flutter-initiated title updates
- [ ] Create mechanism for Android to trigger Flutter title updates
- [ ] Add animation or visual indicator when titles are updated
- [ ] Write unit tests for the API
- [ ] Document the API usage and implementation details

## Implementation Details

### Pigeon API Definition

```dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/app_bar_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/com/example/app/AppBarApi.kt',
  kotlinOptions: KotlinOptions(),
))

// Messages
class TitleMessage {
  String? title;
  bool? animate;
}

// Flutter → Android API
@HostApi()
abstract class AppBarHostApi {
  void updateAndroidAppBarTitle(TitleMessage message);
}

// Android → Flutter API
@FlutterApi()
abstract class AppBarFlutterApi {
  void updateFlutterAppBarTitle(TitleMessage message);
}
```

## Acceptance Criteria

- [ ] Pigeon is properly configured and generating code
- [ ] Flutter can update the Android app bar title
- [ ] Android can update Flutter's displayed title
- [ ] Visual feedback is provided when titles are updated
- [ ] Code is well-documented with comments
- [ ] Implementation handles edge cases (empty titles, null values)
- [ ] Unit tests verify the functionality

## Dependencies

- None (first story in the epic)

## Notes

This story demonstrates a real-world use case of cross-platform UI updates while keeping the
implementation simple and understandable. The bidirectional nature of the example showcases Pigeon's
ability to facilitate two-way communication between Flutter and native code.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium-Low
- **LOE with Firebender using Gemini 2.5 Pro:** Medium-Low

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 4/10
- **Likelihood of Manual Steps:** 6/10

### Time Estimate

- **Estimated Hours:** 6-8 hours

### Notes

For a senior Flutter developer with Kotlin background, setting up Pigeon should be relatively
straightforward. The main challenges will be:

1. Configuring the build pipeline correctly for code generation
2. Understanding Pigeon's programming model (HostApi vs FlutterApi)
3. Handling UI updates on both platforms gracefully

The app bar title update example was chosen because:

1. It's visually obvious when it works, providing immediate feedback
2. It demonstrates real UI changes across platform boundaries
3. It's conceptually simple to understand for developers new to platform channels
4. It showcases bidirectional communication, an important capability

Focus on making the API clean and well-documented, as this will serve as a reference for future
platform channel implementations. Consider adding optional parameters (like animation flags) to
demonstrate more complex data passing.