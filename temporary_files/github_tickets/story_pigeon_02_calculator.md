# Story: Implement Simple Calculator Example with Pigeon

## Summary (TLDR)

**Create a calculator example with Flutter UI and Kotlin computation logic.**

* **Key Features**:
    * Flutter UI for numerical input and operation selection
    * **Pigeon API** for calculation operations
    * Kotlin implementation of math operations
    * **Error handling** for division by zero and other edge cases
    * **Complex data structures** for calculation history
* **Technical Focus**:
    * Data processing across platform boundaries
    * Returning results from native code to Flutter
* **Time Estimate**: 7-9 hours

## Description

Implement a simple calculator example that demonstrates data processing across platform boundaries
using Pigeon. This example will showcase sending numerical data from Flutter to Kotlin, performing
calculations in Kotlin, and returning the results back to Flutter.

## Requirements

- Create a Flutter UI for a simple calculator
- Implement Pigeon API for math operations
- Process calculations in native Kotlin code
- Return results to Flutter for display
- Handle error cases appropriately
- Demonstrate complex data types with calculation history

## Technical Tasks

- [ ] Create Pigeon API definition file for calculator operations
- [ ] Generate Pigeon code for Flutter and Kotlin
- [ ] Implement Flutter UI with number inputs and operation buttons
- [ ] Develop Kotlin implementation of calculator operations
- [ ] Add error handling for edge cases (division by zero, overflow)
- [ ] Implement calculation history tracking with complex data structures
- [ ] Create visual feedback for calculation process
- [ ] Write unit tests for the calculator API
- [ ] Document implementation details and API usage

## Implementation Details

### Pigeon API Definition

```dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/calculator_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/com/example/app/CalculatorApi.kt',
  kotlinOptions: KotlinOptions(),
))

// Input message for calculations
class CalculationRequest {
  double? firstNumber;
  double? secondNumber;
  String? operation; // "add", "subtract", "multiply", "divide"
}

// Result message with error handling
class CalculationResponse {
  double? result;
  String? errorMessage;
  bool? hasError;
}

// Complex history entry for demonstrating complex objects
class HistoryEntry {
  CalculationRequest? request;
  CalculationResponse? response;
  String? timestamp;
}

// History response for demonstrating complex data structures
class HistoryResponse {
  List<HistoryEntry?>? entries;
  int? totalCalculations;
}

// Calculator API
@HostApi()
abstract class CalculatorApi {
  CalculationResponse calculate(CalculationRequest request);
  HistoryResponse getCalculationHistory();
  void clearHistory();
}
```

## Acceptance Criteria

- [ ] Calculator UI allows input of two numbers and selection of operations
- [ ] All four basic operations (add, subtract, multiply, divide) work correctly
- [ ] Calculations are processed in Kotlin and results returned to Flutter
- [ ] Division by zero and other edge cases are handled appropriately
- [ ] Calculation history demonstrates complex data structure transfer
- [ ] Code includes comments and documentation
- [ ] Unit tests verify the functionality of the calculator

## Dependencies

- Story: Set Up Pigeon and Implement App Bar Title Update Example

## Notes

This story demonstrates a more computation-focused example of cross-platform communication, showing
how data can be processed in native code and returned to Flutter. The calculator example provides a
good foundation for the JNIGen conversion in the next story, as it involves numerical operations
that might benefit from native performance.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 8/10
- **Likelihood of Frustration:** 5/10
- **Likelihood of Manual Steps:** 6/10

### Time Estimate

- **Estimated Hours:** 7-9 hours

### Notes

This calculator example was chosen because:

1. It demonstrates clear data flow between platforms (input → processing → output)
2. It includes practical error handling scenarios (division by zero, etc.)
3. It's conceptually simple while still showing real computational work
4. It can be extended to demonstrate complex data structures (calculation history)
5. It provides a good candidate for JNIGen conversion in the next story

For a senior Flutter developer with Kotlin experience, the implementation should be straightforward.
The main challenges will be:

1. Designing a clean API that demonstrates Pigeon's capabilities without unnecessary complexity
2. Handling all error cases gracefully across the platform boundary
3. Implementing the complex data structures for calculation history

Consider adding a performance measurement mechanism to compare execution time between different
calculation approaches, as this will be useful for the JNIGen comparison in the next story. The UI
should focus on clarity rather than complex calculator features to keep the example understandable.