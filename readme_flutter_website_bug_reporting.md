# How to Report Flutter Website Documentation Bugs

This guide provides step-by-step instructions for reporting documentation bugs to the Flutter team,
following their official bug reporting guidelines.

## When to Report Documentation Bugs

Report documentation bugs when you encounter:

- **Missing Information**: Critical steps not documented
- **Incorrect Information**: Documentation doesn't match actual behavior
- **Broken Examples**: Code samples that don't work as shown
- **Confusing Instructions**: Unclear or ambiguous guidance
- **Integration Failures**: Documentation leads to non-working implementations

## Step 1: Prepare Your Bug Report

### Gather Required Information

Before creating an issue, collect:

1. **Flutter Doctor Output**
   ```bash
   flutter doctor -v
   ```
   Copy the complete output to include in your report.

2. **Specific Documentation URLs**
    - Note the exact pages with issues
    - Include section headings if relevant

3. **Code Examples**
    - Create minimal reproducible examples
    - Show both "what documentation says" vs "what actually works"

4. **Error Messages**
    - Include any build errors, runtime errors, or console output
    - Use verbose mode: `flutter build --verbose` or `flutter run --verbose`

### Create a Minimal Reproduction

For complex issues, create a minimal Flutter app:

```bash
flutter create bug_reproduction
cd bug_reproduction
# Modify main.dart to demonstrate the issue
```

Or use [DartPad](https://dartpad.dev) for simple examples.

## Step 2: Choose the Correct Repository

### For Documentation Issues:

- **Repository**: https://github.com/flutter/website
- **Issue Template**: Use "Documentation Bug Report" template

### For Flutter Framework Issues:

- **Repository**: https://github.com/flutter/flutter
- **Issue Template**: Use "Bug Report" template

### For Plugin/Package Issues:

- **Repository**: https://github.com/flutter/packages
- **Issue Template**: Varies by plugin

## Step 3: Create the Bug Report

### Navigate to Issue Creation

1. Go to https://github.com/flutter/website/issues/new/choose
2. Select "Documentation Bug Report" template
3. Fill out all sections completely

### Required Sections

#### **Title**

- Be specific and descriptive
- Include the documentation area affected
- Example: "Add-to-app Android/Kotlin documentation missing AndroidManifest.xml requirements"

#### **Summary**

- Concise description of the documentation problem
- Include impact on developers (time cost, failure rate, etc.)

#### **Affected Documentation**

- List specific URLs with issues
- Include section names or headings

#### **Steps to Reproduce**

- Exact steps following the documentation
- Include commands and expected outcomes

#### **Expected vs Actual Behavior**

- What the documentation suggests should happen
- What actually happens when following the docs

#### **Code Samples**

```markdown
**Current documentation suggests:**
```kotlin
// Code from docs that doesn't work
```

**Working solution requires:**

```kotlin
// Additional code needed but not documented
```

```

#### **Flutter Doctor Output**
```bash
# Paste complete flutter doctor -v output here
```

#### **Screenshots** (if applicable)

- Error messages
- UI issues
- Before/after comparisons

## Step 4: Format Your Report

### Use Clear Formatting

- **Headers**: Use `##` for sections
- **Code blocks**: Use triple backticks with language specification
- **Lists**: Use `-` for bullet points or `1.` for numbered lists
- **Emphasis**: Use `**bold**` for important information

### Example Structure:

```markdown
# Bug Report: [Specific Issue Title]

## Summary
Brief description of the documentation issue and its impact.

## Steps to reproduce
1. Follow documentation at [URL]
2. Create new project: `flutter create test_app`
3. Follow integration steps
4. Observe failure

## Expected behavior
- Documentation should provide working integration
- Build should succeed
- Feature should function as described

## Actual behavior
- Integration fails silently
- Missing critical configuration steps
- Developers spend hours debugging

## Code sample
[Minimal reproduction code]

## Flutter Doctor output
[Complete output]

## Affected documentation pages
1. Primary: [URL]
2. Secondary: [URL]

## Proposed solution
[Specific improvements needed]
```

## Step 5: Submit and Follow Up

### Before Submitting

- [ ] Review your report for completeness
- [ ] Check for typos and formatting
- [ ] Verify all code examples are correct
- [ ] Test reproduction steps if possible

### After Submitting

- **Monitor the issue** for team responses
- **Provide additional information** if requested
- **Test proposed fixes** when available
- **Update the issue** if you find additional details

## Step 6: Best Practices

### Make It Actionable

- Provide specific suggestions for improvement
- Include exact code examples that should be added
- Reference successful implementations when available

### Be Professional

- Use respectful, constructive language
- Focus on the issue, not frustration
- Acknowledge the team's efforts

### Include Context

- Explain the business impact (developer time, adoption barriers)
- Note how widespread the issue might be
- Reference related issues if they exist

## Common Documentation Bug Categories

### 1. Missing Critical Steps

- Required configuration files
- Essential import statements
- Platform-specific requirements

### 2. Outdated Information

- API changes not reflected in docs
- Deprecated methods still shown
- Version compatibility issues

### 3. Incomplete Examples

- Partial code samples
- Missing error handling
- No troubleshooting guidance

### 4. Platform-Specific Gaps

- Android vs iOS differences
- Kotlin vs Java variations
- Different Flutter versions

## Example Labels to Request

When creating your issue, suggest appropriate labels:

- `d: documentation` - Documentation issue
- `a: android` / `a: ios` - Platform specific
- `add-to-app` - Integration feature
- `good first issue` - If fix is straightforward
- `P1` / `P2` - Priority based on impact

## Resources

- **Flutter Bug Reports Guide**: https://docs.flutter.dev/resources/bug-reports
- **GitHub Issue Templates**: https://github.com/flutter/website/issues/new/choose
- **Community Guidelines**: https://github.com/flutter/flutter/blob/master/CONTRIBUTING.md
- **DartPad for Examples**: https://dartpad.dev

## Template Checklist

Before submitting, verify you've included:

- [ ] Clear, specific title
- [ ] Complete summary with impact assessment
- [ ] Step-by-step reproduction instructions
- [ ] Expected vs actual behavior
- [ ] Minimal code sample demonstrating issue
- [ ] Complete `flutter doctor -v` output
- [ ] Specific documentation URLs affected
- [ ] Proposed solution or improvements
- [ ] Appropriate labels requested

---

**Remember**: High-quality bug reports lead to faster fixes and better documentation for the entire
Flutter community. Take the time to create comprehensive, actionable reports that help the team
understand and resolve the issue efficiently.