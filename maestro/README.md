# Maestro UI Testing for Hybrid Navigation App

## What is Maestro?

Maestro is a mobile UI testing framework that simplifies creating, running, and maintaining UI tests
for mobile applications. It uses a simple YAML-based syntax to define test flows, making it easy to
write and understand tests without deep programming knowledge.

## Why Maestro for Our Hybrid App?

Maestro offers several advantages for testing our hybrid Flutter-Kotlin navigation app:

- **Cross-Platform**: Works with both Android and iOS
- **Technology Agnostic**: Tests Flutter and native screens seamlessly
- **Easy Syntax**: Simple YAML format is readable and maintainable
- **Visual Verification**: Captures screenshots at each step
- **CI Integration**: Easy to integrate with GitHub Actions
- **Rich Reports**: Generates detailed test reports and videos

## Directory Structure

```
maestro/
├── README.md           # This overview file
├── quickstart.md       # Getting started guide
├── faq.md              # Frequently asked questions
├── troubleshooting.md  # Common issues and solutions
├── flows/              # Test flow definition files
│   ├── hello_world.yaml   # Simple test to verify setup
│   ├── navigation/        # Navigation test flows
│   ├── deep_linking/      # Deep linking test flows
│   └── cross_platform/    # Tests that work on both iOS and Android
└── scripts/            # Helper scripts for running tests
```

## Key Resources

- [Maestro Documentation](https://maestro.mobile.dev/)
- [Installation Guide](https://maestro.mobile.dev/getting-started/installing-maestro)
- [YAML Flow Syntax](https://maestro.mobile.dev/api-reference/commands)
- [CI Integration Guide](https://maestro.mobile.dev/getting-started/maestro-cloud)

## Getting Started

See our [Quickstart Guide](./quickstart.md) to install Maestro and run your first test.

For common issues, check the [Troubleshooting Guide](./troubleshooting.md).

## Running Tests Locally

```bash
# Run a specific test flow
maestro test flows/hello_world.yaml

# Run all test flows
maestro test flows/

# Run with video recording
maestro test --video flows/hello_world.yaml
```