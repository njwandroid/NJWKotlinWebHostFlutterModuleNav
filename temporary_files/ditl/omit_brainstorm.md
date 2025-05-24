# AI Interactions Log - Omit Functionality Brainstorm

## Concept: [OMIT] and [PRIVATE] Prefixes

Allow developers to mark certain prompts for exclusion from the AI interactions log using special
prefixes.

## Implementation Ideas

### Option 1: Prefix-Based System

```
[OMIT] Please help me with this sensitive task...
[PRIVATE] This contains confidential information...
```

### Option 2: Command-Based System

```
AI_LOG_OMIT: Please help me with this sensitive task...
AI_LOG_PRIVATE: This contains confidential information...
```

### Option 3: Structured Format

```markdown
---
log_status: omit
reason: sensitive_content
---
Please help me with this task...
```

## Handling Strategies

### 1. Temporary Directory Approach

- Omitted prompts go to `temporary_files/omitted_prompts/`
- Directory is gitignored
- Prompts still tracked locally but not committed
- Allows for later review and potential inclusion

### 2. Summary-Only Approach

- Replace full prompt with summary: `[OMITTED PROMPT - Administrative/Personal/Sensitive]`
- Maintain session continuity without exposing content
- Include timestamp and basic categorization

### 3. Private Log Approach

- Create parallel private log file: `5_ai_interactions_private.md`
- Private file goes in gitignore
- Public log references private entries: `See private log entry #X`

## Categories for Omission

### Administrative

- Personal scheduling/coordination
- Internal team discussions
- Process refinements

### Sensitive Content

- Proprietary information
- Personal data
- Security considerations

### Experimental/Rough Ideas

- Half-formed thoughts
- Brainstorming sessions
- Ideas not ready for documentation

## Automation Possibilities

### Git Pre-commit Hook

```bash
#!/bin/bash
# Check for omitted content markers
if grep -r "\[OMIT\]" --exclude-dir=temporary_files .; then
    echo "Warning: Found [OMIT] markers in committed files"
    exit 1
fi
```

### AI Script Integration

```python
def process_prompt(prompt):
    if prompt.startswith('[OMIT]'):
        save_to_temporary_files(prompt)
        return None  # Don't add to main log
    elif prompt.startswith('[PRIVATE]'):
        save_to_private_log(prompt) 
        add_reference_to_main_log()
    else:
        add_to_main_log(prompt)
```

## Workflow Examples

### Development Session

1. Start session normally
2. Encounter sensitive task: `[OMIT] Please help with internal tool X...`
3. AI processes but doesn't log to main file
4. Continue with normal logging
5. Before commit: Review temporary files, decide what to include

### Review Process

1. Weekly review of omitted prompts
2. Categorize: truly private vs. can be generalized
3. Create sanitized versions for main log
4. Update documentation with lessons learned

## Benefits

### Privacy Protection

- Keep sensitive information out of public repos
- Maintain professional documentation standards
- Allow for internal-only discussions

### Flexibility

- One-time exceptions without changing process
- Context-sensitive privacy controls
- Maintains session continuity

### Documentation Quality

- Cleaner public logs
- More focused content
- Professional presentation

## Implementation Priority

1. **Phase 1**: Manual tagging with `[OMIT]` prefix
2. **Phase 2**: Temporary file handling
3. **Phase 3**: Automated detection and routing
4. **Phase 4**: Integration with git hooks and pre-commit checks

## Considerations

### Session Context

- How to maintain context when omitting prompts?
- Should responses to omitted prompts also be omitted?
- Impact on session continuity and understanding

### Tooling Integration

- IDE plugins for easy tagging
- CLI tools for prompt processing
- Integration with existing AI interfaces

### Team Workflows

- Consistent tagging across team members
- Shared understanding of what should be omitted
- Review processes for omitted content