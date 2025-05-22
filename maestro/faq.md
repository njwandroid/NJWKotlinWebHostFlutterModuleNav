# Maestro FAQ

## General Questions

**Q: What is Maestro?**
A: Maestro is a mobile UI testing framework that uses a simple YAML-based syntax to define test
flows. It's designed to be easy to use and maintain, even for teams without deep programming
knowledge.

**Q: Why are we using Maestro for this project?**
A: Maestro is well-suited for our hybrid Flutter-Kotlin/Swift app because it's cross-platform,
technology-agnostic (tests Flutter and native screens seamlessly), and easy to integrate with CI/CD
pipelines.

**Q: Do I need to know how to code to write Maestro tests?**
A: No, Maestro tests are written in YAML, which is a human-readable data serialization language.
Basic understanding of UI elements and user flows is more important than programming skills.

**Q: Can Maestro test both Android and iOS?**
A: Yes, Maestro supports both Android and iOS platforms with the same test flows, though you might
need platform-specific flows for certain features.

## Writing Tests

**Q: How do I identify UI elements for Maestro to interact with?**
A: Maestro can identify elements by text, accessibility ID, or by their position. The Maestro Studio
tool can also help in identifying elements.

**Q: Can Maestro handle complex gestures?**
A: Yes, Maestro supports common gestures like tap, long press, swipe, and pinch.

**Q: How does Maestro handle dynamic content or delays?**
A: Maestro has built-in commands like `waitFor`, `assertVisible`, and `assertNotVisible` with
timeout options to handle dynamic content and network delays.

**Q: Can I run platform-specific test steps?**
A: Yes, Maestro allows you to define platform-specific conditions for test steps using `runFlow`
with conditions or by organizing flows into platform-specific subdirectories.

## Running Tests

**Q: How do I run a single Maestro test flow?**
A: Use the command `maestro test flows/your_flow_name.yaml`.

**Q: How do I run all tests in a directory?**
A: Use `maestro test flows/` to run all YAML files in the `flows` directory and its subdirectories.

**Q: Can I get screenshots or videos of my test runs?**
A: Yes, Maestro automatically takes screenshots at each step. You can get videos by using the
`--video` flag: `maestro test --video flows/your_flow_name.yaml`.

**Q: What is Maestro Studio?**
A: Maestro Studio is a tool that helps you inspect your app's UI hierarchy and identify elements,
making it easier to write test flows. You can launch it with `maestro studio`.

## Integration

**Q: Can Maestro be integrated into our CI/CD pipeline?**
A: Yes, Maestro is designed for CI/CD integration. It can be run from the command line and generates
reports that can be consumed by CI systems. We plan to integrate it with GitHub Actions.

**Q: What is Maestro Cloud?**
A: Maestro Cloud is a service offered by the Maestro team for running your tests on real devices in
the cloud. It provides features like parallel execution and detailed reporting.

## Troubleshooting

**Q: My test is failing, but I don't know why. What should I do?**
A: Check the Maestro output in the console for detailed error messages. Review the screenshots
generated for each step to see the app's state when the failure occurred. You can also use Maestro
Studio to inspect the UI at the point of failure. Refer to our `troubleshooting.md` for more tips.

**Q: How do I find the `appId` for my application?**
A: For Android, it's the `applicationId` in your `app/build.gradle` file. For iOS, it's the
`Bundle Identifier` found in your Xcode project settings (General tab).