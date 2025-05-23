# AI Interactions Rules and Next Steps

This document provides guidance on implementing AI interaction tracking across projects and
troubleshooting common issues.

## Universal Firebender Rules

These rules can be applied to any project using Firebender for AI-assisted development:

### Rule 1: Auto-Generate Interaction Logs

```json
{
  "trigger": "ai_session_start",
  "condition": "branch_name_contains_number",
  "action": "create_ai_interactions_log",
  "parameters": {
    "script": "make_ai_interactions_script.py",
    "command": "create",
    "branch_name": "{{current_branch}}",
    "session_title": "{{session_context}}"
  }
}
```

### Rule 2: Update Log During Sessions

```json
{
  "trigger": "prompt_processed",
  "condition": "ai_interactions_log_exists",
  "action": "update_current_session",
  "parameters": {
    "log_file": "{{branch_prefix}}_ai_interactions_log.md",
    "timestamp": "{{current_time}}",
    "prompt": "{{user_prompt}}",
    "actions": "{{ai_actions}}"
  }
}
```

### Rule 3: Finalize Session on Exit

```json
{
  "trigger": "ai_session_end",
  "condition": "ai_interactions_log_exists",
  "action": "finalize_session",
  "parameters": {
    "log_file": "{{branch_prefix}}_ai_interactions_log.md",
    "end_time": "{{current_time}}",
    "status": "{{session_status}}",
    "summary": "{{auto_generated_summary}}"
  }
}
```

## Universal LLM Prompt Template

Use this prompt template for any LLM interaction to ensure consistent logging:

```
[CONTEXT]
Project: {{project_name}}
Branch: {{branch_name}}
Session: {{session_number}}
Previous Context: {{previous_context}}

[LOGGING REQUIREMENT]
Please ensure this interaction is logged in the AI interactions file following this format:
- Timestamp: {{current_time}}
- Prompt: [Your request/question]
- Actions Taken: [List of actions performed]
- Challenges: [Any issues encountered]
- Status: [Current completion status]
- Next Steps: [What needs to be done next]

[YOUR REQUEST]
{{user_request}}

[AUTO-LOGGING]
If an ai_interactions_log.md file exists for this branch, please update it with this session's details.
```

## Project Integration Steps

### Step 1: Setup Scripts

1. Copy `make_ai_interactions_script.py` to project root
2. Run `python make_ai_interactions_script.py setup` to create templates
3. Make script executable: `chmod +x make_ai_interactions_script.py`

### Step 2: Configure Firebender

Add these rules to your `firebender.json`:

```json
{
  "rules": [
    {
      "name": "ai_interactions_auto_create",
      "trigger": "session_start",
      "conditions": ["is_feature_branch"],
      "actions": ["create_ai_log"]
    },
    {
      "name": "ai_interactions_auto_update", 
      "trigger": "prompt_complete",
      "conditions": ["log_exists"],
      "actions": ["update_log"]
    }
  ],
  "ai_interactions": {
    "enabled": true,
    "log_pattern": "{branch_prefix}_ai_interactions_log.md",
    "auto_create": true,
    "auto_update": true
  }
}
```

### Step 3: Update Project README

Add this section to your project README:

```markdown
## AI Interactions Tracking

This project tracks AI-assisted development sessions in `*_ai_interactions_log.md` files.

### Manual Logging
```bash
# Create new log for branch
python make_ai_interactions_script.py create <branch_name> "<session_title>"

# Setup template files
python make_ai_interactions_script.py setup
```

### Automatic Logging

AI interactions are automatically logged when using Firebender with the configured rules.

```

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Script Import Errors
**Problem**: `ModuleNotFoundError: No module named 'make_ai_interactions_script'`

**Solutions**:
- Ensure script is in Python path: `export PYTHONPATH="${PYTHONPATH}:$(pwd)"`
- Run from project root: `cd /path/to/project && python make_ai_interactions_script.py`
- Use absolute imports in script

#### 2. Permission Denied
**Problem**: `PermissionError: [Errno 13] Permission denied`

**Solutions**:
- Make script executable: `chmod +x make_ai_interactions_script.py`
- Run with Python explicitly: `python make_ai_interactions_script.py`
- Check file ownership: `ls -la make_ai_interactions_script.py`

#### 3. Template Not Found
**Problem**: Template files missing or corrupted

**Solutions**:
- Regenerate templates: `python make_ai_interactions_script.py setup`
- Check file permissions in project directory
- Verify script has write access to project root

#### 4. Branch Name Parsing Issues
**Problem**: Log files created with wrong names

**Solutions**:
- Use underscore-separated branch names: `5_feature_name`
- Avoid special characters in branch names
- Check branch naming convention in team guidelines

#### 5. Firebender Integration Failures
**Problem**: Firebender rules not triggering

**Solutions**:
- Validate `firebender.json` syntax with JSON validator
- Check rule conditions match your workflow
- Enable debug mode: `"debug": true` in firebender config
- Verify trigger events are firing

### Debugging Commands

```bash
# Test script functionality
python make_ai_interactions_script.py help

# Create test log
python make_ai_interactions_script.py create test_branch "Debug Session"

# Run unit tests
python test_ai_interactions_script.py

# Validate firebender config
firebender validate firebender.json

# Debug firebender execution
firebender run --debug
```

### Validation Checklist

Before deploying to a new project:

- [ ] Script runs without errors
- [ ] Templates are created correctly
- [ ] Unit tests pass
- [ ] Branch name parsing works for your naming convention
- [ ] Firebender rules match your workflow
- [ ] File permissions allow read/write access
- [ ] Team members can access and use the system

## Advanced Configuration

### Custom Template Modification

1. Edit `ai_interactions_template.md` to match your team's format
2. Update placeholder names in script if needed
3. Test with sample data

### Integration with CI/CD

```yaml
# GitHub Actions example
- name: Generate AI Interactions Summary
  run: |
    if [[ -f "*_ai_interactions_log.md" ]]; then
      echo "AI interactions documented for this PR"
      cat *_ai_interactions_log.md >> $GITHUB_STEP_SUMMARY
    fi
```

### Team Adoption Strategy

1. **Pilot Phase**: Start with one project/team
2. **Training**: Provide documentation and examples
3. **Feedback Loop**: Collect and address team feedback
4. **Rollout**: Gradually expand to other projects
5. **Monitoring**: Track adoption and effectiveness

## Best Practices

### For Development Teams

- Create consistent branch naming conventions
- Include AI interaction logs in PR reviews
- Use logs for knowledge sharing and onboarding
- Archive logs with completed features

### For Project Managers

- Review AI interaction patterns for efficiency insights
- Use logs for project timeline estimates
- Identify common challenges for team training
- Track AI-assisted vs manual development ratios

### For Documentation

- Include AI logs in project retrospectives
- Reference specific sessions in architectural decisions
- Maintain a library of successful AI interaction patterns
- Use logs for troubleshooting guides

## Future Enhancements

### Planned Features

1. **Web Dashboard**: Visual interface for browsing logs
2. **Analytics**: Metrics on AI interaction effectiveness
3. **Integration APIs**: Connect with project management tools
4. **Template Library**: Industry-specific templates
5. **Export Formats**: PDF, JSON, CSV export options

### Community Contributions

- Submit improvements via pull requests
- Share custom templates and rules
- Report bugs and feature requests
- Contribute to documentation

---

*This documentation is designed to be project-agnostic and can be adapted for any development
environment that uses AI assistance.*