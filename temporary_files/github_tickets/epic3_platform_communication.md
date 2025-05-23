# Epic: Cross-Platform Communication with Pigeon and JNIGen

## Summary (TLDR)

**Compare two cross-platform communication technologies with practical examples.**

* **Technologies**:
    * **Pigeon**: Type-safe message passing between Flutter and Kotlin
    * **JNIGen**: Direct native method binding for Flutter-Kotlin integration
* **Demo Examples**:
    * **App Bar Title Update**: Visual UI synchronization (bidirectional)
    * **Calculator**: Data processing across platform boundaries
* **Key Deliverables**:
    * Working implementations of both approaches
    * **Performance benchmarks** comparing the technologies
    * Decision framework for **choosing the right tool** for different scenarios
* **Time Estimate**: 20-25 hours total implementation

## Description

Implement and demonstrate efficient cross-platform communication between Flutter and native Kotlin
using both Pigeon and JNIGen. This epic focuses on creating clear, understandable examples that
showcase the advantages of type-safe platform channel communication while comparing different
implementation approaches.

## Core Requirements

- Implement two distinct examples using Pigeon for Flutter-Kotlin communication
- Convert one example to use JNIGen to demonstrate the differences
- Create clear, understandable examples that prioritize clarity and real-world applicability
- Document approach differences, performance implications, and development experiences
- Provide example code that can serve as a reference for future implementations

## Subtasks

### 1. Pigeon Setup and Integration

- [ ] Configure Pigeon in the project
- [ ] Set up code generation pipeline for Pigeon
- [ ] Create shared data models and API interfaces
- [ ] Implement base infrastructure for platform communication

### 2. Example 1: App Bar Title Update

- [ ] Create Flutter UI with button to update Android app bar title
- [ ] Implement Pigeon API for app bar title communication
- [ ] Develop Kotlin host implementation for title updates
- [ ] Add bidirectional support (Android can also update Flutter titles)
- [ ] Document the implementation process and usage

### 3. Example 2: Simple Calculator

- [ ] Create Flutter UI for number input
- [ ] Implement Pigeon API for calculation operations
- [ ] Develop Kotlin calculation implementation
- [ ] Add error handling for edge cases (overflow, division by zero)
- [ ] Create demonstration of complex data transfer
- [ ] Document the implementation process and usage

### 4. JNIGen Conversion

- [ ] Configure JNIGen in the project
- [ ] Convert the Calculator example to use JNIGen
- [ ] Compare implementation differences
- [ ] Benchmark performance differences
- [ ] Document the migration process and challenges

### 5. Documentation and Comparison

- [ ] Create comprehensive API documentation
- [ ] Develop side-by-side comparison of Pigeon vs JNIGen
- [ ] Document best practices for each approach
- [ ] Create decision framework for choosing between methods
- [ ] Document performance implications and tradeoffs

## Technical Considerations

- Code generation pipeline integration
- Type safety across language boundaries
- Error handling in cross-platform communication
- Performance implications of different approaches
- Developer experience and maintainability

## Acceptance Criteria

- [ ] Two functional Pigeon examples (App Bar Update and Calculator)
- [ ] Working JNIGen implementation of the Calculator example
- [ ] Documentation of implementation details for both approaches
- [ ] Comparison of development effort, performance, and maintenance concerns
- [ ] All examples work on both debug and release builds
- [ ] Comprehensive error handling for edge cases
- [ ] Clear, understandable code with appropriate comments

## Priority

Medium

## Estimated Effort

1 week

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 8/10
- **Likelihood of Frustration:** 6/10
- **Likelihood of Manual Steps:** 7/10

### Time Estimate

- **Estimated Hours:** 20-25 hours

### Notes

This epic involves implementing platform channel communication using modern tools that simplify the
integration between Flutter and native code. The key challenges include:

1. Setting up the code generation pipeline correctly for both Pigeon and JNIGen
2. Understanding the different programming paradigms between the approaches
3. Handling edge cases and errors across the platform boundary
4. Creating examples that are both simple and showcase real-world value

For a senior Flutter developer with some Kotlin background, the implementation should be
straightforward once the tooling is set up properly. The most challenging aspect will likely be the
JNIGen configuration and understanding the differences in how it handles native code integration
compared to Pigeon.

The selected examples (App Bar Title Update and Calculator) provide:

1. A UI-focused example that demonstrates visual feedback and interaction
2. A computational example that demonstrates data transfer and processing

These examples were chosen because they are conceptually simple to understand while demonstrating
practical aspects of cross-platform communication. The performance differences will be more apparent
in the Calculator example, making it the better candidate for the JNIGen conversion.