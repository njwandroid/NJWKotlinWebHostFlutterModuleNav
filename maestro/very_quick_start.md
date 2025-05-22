# Maestro Very Quick Start

For developers already familiar with Maestro, this is the fastest way to get started with our
project.

## 1. Run the Sample Test (Will Fail)

```bash
# Run the intentionally failing test to verify your setup
maestro test maestro/flows/hello_world.yaml
```

## 2. Create Your First Working Test

Create a file at `maestro/flows/basic_navigation.yaml`:

```yaml
appId: com.example.myflutternavbarapplication
---
# Launch the app
- launchApp

# Wait for the app to load
- waitForAnimationToEnd:
    timeout: 5000

# Verify the My tab is visible
- assertVisible:
    text: "My"
    
# Tap on the Billing tab
- tapOn:
    text: "Billing"
    
# Verify we navigated to the Billing tab
- assertVisible:
    text: "Billing"
```

## 3. Run Your Test with Video Recording

```bash
# Run with video recording
maestro test --video maestro/flows/basic_navigation.yaml
```

## 4. Generate AI-Enhanced Test Report

```bash
# First, collect screenshots and info
maestro test --format=json --output=test-results.json maestro/flows/basic_navigation.yaml

# Then use our report script (requires Python)
python scripts/generate_ai_report.py test-results.json
```

## 5. Add Test to CI Pipeline

Add the test to your PR by including it in your commit and ensuring the GitHub workflow runs.

## Next Steps

- View complete docs in [README.md](./README.md)
- Add more complex flows in `maestro/flows/`
- Check [FAQ](./faq.md) for common questions