# Story: Convert Calculator Example to JNIGen

## Summary (TLDR)

**Convert calculator from Pigeon to JNIGen for direct comparison of approaches.**

* **Key Tasks**:
   * Configure **JNIGen build pipeline**
   * Convert calculator functionality to use direct native method binding
   * Implement equivalent error handling in JNIGen context
   * Create **performance benchmarks** comparing both implementations
* **Technical Focus**:
   * Understanding conceptual differences between approaches
   * Measuring performance implications of different integration patterns
* **Time Estimate**: 8-10 hours

## Description

Convert the existing Pigeon-based calculator example to use JNIGen for platform communication. This
will demonstrate the differences between the two approaches and allow for performance comparison.
The focus is on maintaining the same functionality while implementing a different integration
method.

## Requirements

- Set up JNIGen in the project
- Convert the calculator example from Pigeon to JNIGen
- Maintain the same calculator functionality and UI
- Implement performance benchmarking for comparison
- Document differences in implementation approaches and developer experience

## Technical Tasks

- [ ] Add JNIGen dependency to the project
- [ ] Configure JNIGen build pipeline
- [ ] Define JNI interfaces for calculator operations
- [ ] Generate JNI bindings
- [ ] Implement native Kotlin calculation logic for JNIGen
- [ ] Update Flutter UI to use JNIGen implementation
- [ ] Implement error handling in JNIGen context
- [ ] Create performance benchmarks for comparison with Pigeon
- [ ] Document implementation process and challenges
- [ ] Write unit tests for the JNIGen implementation

## Implementation Details

### JNIGen Interface Example

```dart
// calculator_jni.dart
import 'package:jnigen/jnigen.dart';

@jni.JNIImport('com.example.app.CalculatorJNI')
abstract class CalculatorJNI {
  @jni.JNIConstructor()
  external factory CalculatorJNI();
  
  @jni.JNIMethod('calculateAdd')
  external double add(double a, double b);
  
  @jni.JNIMethod('calculateSubtract')
  external double subtract(double a, double b);
  
  @jni.JNIMethod('calculateMultiply')
  external double multiply(double a, double b);
  
  @jni.JNIMethod('calculateDivide')
  external double divide(double a, double b);
  
  @jni.JNIMethod('getLastError')
  external String? getLastError();
  
  @jni.JNIMethod('getCalculationHistoryJson')
  external String getCalculationHistoryJson();
  
  @jni.JNIMethod('clearHistory')
  external void clearHistory();
}
```

### Kotlin Implementation Example

```kotlin
// CalculatorJNI.kt
package com.example.app

class CalculatorJNI {
    private var lastError: String? = null
    private val calculationHistory = mutableListOf<Map<String, Any>>()
    
    fun calculateAdd(a: Double, b: Double): Double {
        val result = a + b
        addToHistory("add", a, b, result)
        return result
    }
    
    fun calculateSubtract(a: Double, b: Double): Double {
        val result = a - b
        addToHistory("subtract", a, b, result)
        return result
    }
    
    fun calculateMultiply(a: Double, b: Double): Double {
        val result = a * b
        addToHistory("multiply", a, b, result)
        return result
    }
    
    fun calculateDivide(a: Double, b: Double): Double {
        if (b == 0.0) {
            lastError = "Division by zero"
            addToHistory("divide", a, b, 0.0, true)
            return 0.0
        }
        val result = a / b
        addToHistory("divide", a, b, result)
        return result
    }
    
    fun getLastError(): String? {
        return lastError
    }
    
    fun getCalculationHistoryJson(): String {
       return "{\"entries\": ${
          org.json.JSONArray(calculationHistory).toString()
       }, \"totalCalculations\": ${calculationHistory.size}}"
    }
    
    fun clearHistory() {
        calculationHistory.clear()
    }
    
    private fun addToHistory(operation: String, a: Double, b: Double, result: Double, hasError: Boolean = false) {
        calculationHistory.add(mapOf(
            "operation" to operation,
            "firstNumber" to a,
            "secondNumber" to b,
            "result" to result,
            "hasError" to hasError,
            "timestamp" to System.currentTimeMillis()
        ))
    }
}
```

## Acceptance Criteria

- [ ] JNIGen is properly configured and generating code
- [ ] Calculator functionality works the same as the Pigeon implementation
- [ ] All four operations (add, subtract, multiply, divide) work correctly
- [ ] Error handling works for edge cases like division by zero
- [ ] Performance benchmarks demonstrate the comparison with Pigeon
- [ ] Documentation clearly explains implementation differences
- [ ] The same UI is maintained for user experience consistency

## Dependencies

- Story: Implement Simple Calculator Example with Pigeon

## Notes

This story focuses on demonstrating the differences between Pigeon and JNIGen implementation
approaches while maintaining the same functionality. The goal is to understand the tradeoffs in
terms of development experience, performance, and code structure.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium-High
- **LOE with Firebender using Gemini 2.5 Pro:** High

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 7/10
- **Likelihood of Frustration:** 7/10
- **Likelihood of Manual Steps:** 8/10

### Time Estimate

- **Estimated Hours:** 8-10 hours

### Notes

Converting from Pigeon to JNIGen introduces several challenges:

1. JNIGen uses a different programming model focused on direct method calls rather than message
   passing
2. The build process for JNIGen differs from Pigeon and may require more manual configuration
3. Error handling patterns differ between the two approaches
4. Complex data structures need different serialization approaches (JNIGen often uses JSON for
   complex objects)

For a Flutter developer with Kotlin experience, the most challenging aspects will be:

1. Understanding JNIGen's conceptual model and how it differs from Pigeon
2. Configuring the JNIGen code generation pipeline correctly
3. Adapting to JNIGen's more direct binding approach with Java/Kotlin methods

Key differences to highlight in documentation:

1. Pigeon uses a message-passing approach while JNIGen directly exposes native methods
2. JNIGen may offer better performance for computational tasks
3. Pigeon provides a more Flutter-like API experience
4. Error handling patterns differ significantly between the approaches

Consider implementing a simple performance test that executes a series of calculations multiple
times with both implementations and compares execution time to highlight the performance
characteristics.