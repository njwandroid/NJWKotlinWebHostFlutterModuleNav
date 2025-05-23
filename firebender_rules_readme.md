# Firebender Rules README

This document provides guidance on using Firebender rules for AI-assisted development, with specific
focus on AI interactions tracking and project automation.

## Overview

Our simplified Firebender configuration focuses on AI interactions tracking rather than complex
automation rules. This approach provides better maintainability and clearer debugging capabilities.

## Current Configuration

### Simplified Structure

```json
{
  "ai_interactions": {
    "enabled": true,
    "log_pattern": "{branch_prefix}_ai_interactions_log.md",
    "auto_create": true,
    "script_path": "make_ai_interactions_script.py"
  },
  "automation_rules": {
    "session_logging": {
      "trigger": "ai_session_start",
      "action": "create_or_update_log"
    }
  }
}
```

### Key Simplifications Made

1. **Removed Complex Rules**: Eliminated overly specific trigger conditions
2. **Focused on Core Functionality**: AI interactions tracking only
3. **Clear Metadata**: Project status and achievements clearly documented
4. **Maintainable Structure**: Easy to understand and modify

## Troubleshooting Firebender Rules

### General Rule Troubleshooting

#### 1. JSON Syntax Issues

**Problem**: Firebender fails to parse configuration

```bash
# Validate JSON syntax
python3 -m json.tool firebender.json
# or
jq . firebender.json
```

**Common Issues**:

- Missing commas between objects
- Trailing commas (not allowed in standard JSON)
- Incorrect bracket/brace matching
- Unescaped quotes in strings

#### 2. Rule Trigger Failures

**Problem**: Rules not executing when expected

**Debugging Steps**:

```bash
# Check if firebender is running
ps aux | grep firebender

# Enable debug mode (if supported)
firebender --debug --config firebender.json

# Check log files
tail -f firebender.log
```

#### 3. Path Resolution Issues

**Problem**: Scripts or files not found

**Solutions**:

- Use absolute paths for critical files
- Verify working directory when firebender runs
- Test path resolution manually:

```bash
# Test script path
python3 make_ai_interactions_script.py help

# Test template path  
ls -la ai_interactions_template.md
```

### AI Interactions Specific Troubleshooting

#### 1. Log File Creation Issues

**Problem**: AI interactions logs not being created

**Diagnostic Commands**:

```bash
# Test script directly
python3 make_ai_interactions_script.py create test_branch "Debug Session"

# Check permissions
ls -la *_ai_interactions_log.md

# Verify template exists
ls -la ai_interactions_template.md
```

**Common Solutions**:

- Ensure Python script is executable
- Verify template file exists and is readable
- Check working directory permissions
- Confirm branch naming follows expected pattern (number_prefix)

#### 2. Session Update Failures

**Problem**: Existing logs not being updated

**Troubleshooting**:

```bash
# Test add session functionality
python3 -c "
from make_ai_interactions_script import AIInteractionsLogger
logger = AIInteractionsLogger()
logger.add_session('5_ai_interactions_log.md', {
    'session_number': 99,
    'title': 'Debug Test'
})
"
```

#### 3. Branch Pattern Recognition

**Problem**: Rules not triggering for certain branch names

**Branch Naming Requirements**:

- Must start with number: `5_flutter_integration` ✅
- Cannot be just number: `main`, `feature` ❌
- Underscore required: `5-flutter` ❌, `5_flutter` ✅

**Test Pattern**:

```python
# Test branch name parsing
branch_name = "5_flutter_integration"
prefix = branch_name.split('_')[0] if '_' in branch_name else branch_name
print(f"Branch: {branch_name}, Prefix: {prefix}")
# Expected: Branch: 5_flutter_integration, Prefix: 5
```

## Next Steps for Firebender Rules

### For This Project - Future Sessions

#### 1. Enhanced Session Tracking

```json
{
  "session_enhancement": {
    "auto_timestamp": true,
    "duration_tracking": true,
    "outcome_classification": ["success", "partial", "failed"],
    "auto_screenshots": true
  }
}
```

#### 2. Integration with Development Tools

```json
{
  "tool_integration": {
    "git_hooks": {
      "pre_commit": "update_ai_log_status",
      "post_merge": "create_session_summary"
    },
    "maestro_integration": {
      "test_results": "append_to_log",
      "screenshots": "auto_embed"
    }
  }
}
```

#### 3. Outcome Analysis

```json
{
  "analytics": {
    "success_patterns": "auto_detect",
    "common_challenges": "categorize",
    "time_estimation": "improve_accuracy",
    "knowledge_extraction": "generate_summaries"
  }
}
```

### For Future Projects - General Application

#### 1. Project Template Creation

```json
{
  "project_templates": {
    "flutter_android": "current_config",
    "react_native": "adapted_config", 
    "web_development": "web_specific_config",
    "data_science": "analysis_focused_config"
  }
}
```

#### 2. Team Collaboration Features

```json
{
  "team_features": {
    "shared_logs": true,
    "knowledge_base": "auto_build",
    "best_practices": "extract_and_share",
    "onboarding": "auto_generate_guides"
  }
}
```

#### 3. CI/CD Integration

```json
{
  "cicd_integration": {
    "build_notifications": "include_ai_context",
    "deployment_logs": "link_to_ai_sessions",
    "test_results": "correlate_with_ai_assistance",
    "documentation": "auto_update_from_logs"
  }
}
```

## Implementation Priorities

### Phase 1: Stabilization (Current)

- [x] Simplified firebender.json working
- [x] Basic AI interactions logging functional
- [x] Troubleshooting documentation complete
- [ ] Test all documented troubleshooting steps

### Phase 2: Enhancement (Next 2-4 weeks)

- [ ] Implement enhanced session tracking
- [ ] Add Maestro test result integration
- [ ] Create auto-screenshot capability
- [ ] Develop outcome analysis features

### Phase 3: Scaling (1-3 months)

- [ ] Create project templates for different tech stacks
- [ ] Implement team collaboration features
- [ ] Develop CI/CD integration patterns
- [ ] Build knowledge base extraction system

## Best Practices

### Rule Design

1. **Keep Rules Simple**: Prefer clear, single-purpose rules
2. **Test Incrementally**: Add one rule at a time
3. **Document Everything**: Include reasoning for each rule
4. **Use Descriptive Names**: Make intent clear from rule names

### Debugging Approach

1. **Start with Manual Testing**: Verify scripts work independently
2. **Check Dependencies**: Ensure all required files exist
3. **Validate JSON**: Always test JSON syntax before deployment
4. **Monitor Logs**: Set up proper logging and monitoring

### Maintenance Strategy

1. **Regular Reviews**: Check rules quarterly for relevance
2. **Usage Analytics**: Track which rules are actually helpful
3. **Version Control**: Keep firebender.json in version control
4. **Backup Configs**: Maintain working backup configurations

## Troubleshooting Quick Reference

| Issue | Quick Fix | Documentation Section |
|-------|-----------|----------------------|
| JSON syntax error | Run `python3 -m json.tool firebender.json` | General Rule Troubleshooting #1 |
| Script not found | Check path with `ls -la make_ai_interactions_script.py` | General Rule Troubleshooting #3 |
| Log not created | Run script manually to test | AI Interactions Troubleshooting #1 |
| Branch not recognized | Verify naming pattern `number_text` | AI Interactions Troubleshooting #3 |
| Rule not triggering | Enable debug mode and check logs | General Rule Troubleshooting #2 |

## Getting Help

1. **Check This Document**: Most issues covered in troubleshooting sections
2. **Test Manually**: Try running components independently
3. **Check Logs**: Look for error messages in system logs
4. **Simplify**: Remove complex rules and add back incrementally
5. **Community**: Share learnings with team for collaborative debugging

---

**Document Version**: 1.0  
**Last Updated**: 23-May-2025  
**Maintained By**: AI Interactions System