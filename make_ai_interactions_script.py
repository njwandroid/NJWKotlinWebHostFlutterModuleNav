#!/usr/bin/env python3
"""
AI Interactions Log Generator Script

This script helps create and maintain AI interaction logs for development sessions.
It provides templates and utilities for tracking AI-assisted development work.
"""

import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional


class AIInteractionsLogger:
    """Handles creation and management of AI interactions log files."""
    
    def __init__(self, project_root: str = "."):
        self.project_root = Path(project_root)
        self.template_file = self.project_root / "ai_interactions_template.md"
        self.example_file = self.project_root / "ai_interactions_example.md"
    
    def create_log_file(self, branch_name: str, session_title: str = "New Session") -> str:
        """
        Create a new AI interactions log file for a branch.
        
        Args:
            branch_name: Name of the branch (used as prefix)
            session_title: Title for the first session
            
        Returns:
            Path to the created log file
        """
        # Extract branch prefix (e.g., "5" from "5_feature_branch")
        branch_prefix = branch_name.split('_')[0] if '_' in branch_name else branch_name
        log_filename = f"{branch_prefix}_ai_interactions_log.md"
        log_path = self.project_root / log_filename
        
        # Load template
        template_content = self._load_template()
        
        # Replace placeholders
        content = template_content.format(
            branch_name=branch_name,
            branch_prefix=branch_prefix,
            session_title=session_title,
            date=datetime.now().strftime("%d-%b-%Y"),
            time=datetime.now().strftime("%I:%M %p"),
            duration="[Ongoing]"
        )
        
        # Write to file
        with open(log_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"Created AI interactions log: {log_filename}")
        return str(log_path)
    
    def add_session(self, log_file: str, session_data: Dict) -> None:
        """
        Add a new session to an existing log file.
        
        Args:
            log_file: Path to existing log file
            session_data: Dictionary containing session information
        """
        session_template = self._get_session_template()
        
        # Format session data
        session_content = session_template.format(
            session_number=session_data.get('session_number', 'N'),
            title=session_data.get('title', 'Untitled Session'),
            date=session_data.get('date', datetime.now().strftime("%d-%b-%Y")),
            time=session_data.get('time', datetime.now().strftime("%I:%M %p")),
            assistant=session_data.get('assistant', 'Claude 4 Sonnet'),
            duration=session_data.get('duration', '[Duration]'),
            prompts=session_data.get('prompts', '[Prompts]'),
            actions=session_data.get('actions', '[Actions taken]'),
            challenges=session_data.get('challenges', '[Challenges encountered]'),
            status=session_data.get('status', '[Current status]'),
            next_steps=session_data.get('next_steps', '[Next steps]'),
            code_changes=session_data.get('code_changes', '[Code changes]'),
            commands=session_data.get('commands', '[Commands executed]')
        )
        
        # Append to file
        with open(log_file, 'a', encoding='utf-8') as f:
            f.write(f"\n\n{session_content}")
        
        print(f"Added session to {log_file}")
    
    def _load_template(self) -> str:
        """Load the template file content."""
        if self.template_file.exists():
            return self.template_file.read_text(encoding='utf-8')
        else:
            return self._get_default_template()
    
    def _get_default_template(self) -> str:
        """Return default template if template file doesn't exist."""
        return """# AI Interactions Log - Branch {branch_prefix}

This file tracks AI interactions, prompts, and outcomes for development work on branch {branch_name}.

## Session 1: {session_title}
**Date**: {date}  
**Time**: {time}  
**AI Assistant**: Claude 4 Sonnet  
**Duration**: {duration}  

### Initial Prompt
```
[Initial prompt will be added here]
```

### Follow-up Prompts
[Follow-up prompts and interactions]

### Actions Taken
[List of actions performed by AI]

### Technical Challenges Encountered
[Challenges and how they were resolved]

### Current Status
[Current status with checkboxes]

### Next Steps
[What needs to be done next]

### Lessons Learned
[Key insights from this session]

### Code Changes Made
[Files that were modified]

### Build Commands Executed
```bash
[Commands that were run]
```

### Error Messages Encountered
```
[Any error messages that came up]
```

---

## Session Template for Future Entries

### Session N: [Title]
**Date**: [Date]  
**Time**: [Time]  
**AI Assistant**: [Assistant Name]  
**Duration**: [Duration]  

### Prompts
[Initial and follow-up prompts]

### Actions Taken
[List of actions]

### Challenges
[Technical challenges encountered]

### Status
[Current status with checkboxes]

### Next Steps
[What needs to be done next]

### Code Changes
[Files modified]

### Commands
[Commands executed]
"""
    
    def _get_session_template(self) -> str:
        """Return template for individual sessions."""
        return """## Session {session_number}: {title}
**Date**: {date}  
**Time**: {time}  
**AI Assistant**: {assistant}  
**Duration**: {duration}  

### Prompts
{prompts}

### Actions Taken
{actions}

### Challenges
{challenges}

### Status
{status}

### Next Steps
{next_steps}

### Code Changes
{code_changes}

### Commands
{commands}"""

    def create_template_files(self) -> None:
        """Create template and example files if they don't exist."""
        # Create template file
        if not self.template_file.exists():
            template_content = self._get_default_template()
            self.template_file.write_text(template_content, encoding='utf-8')
            print(f"Created template file: {self.template_file}")
        
        # Create example file
        if not self.example_file.exists():
            example_content = self._get_example_content()
            self.example_file.write_text(example_content, encoding='utf-8')
            print(f"Created example file: {self.example_file}")
    
    def _get_example_content(self) -> str:
        """Return example AI interactions log content."""
        return """# AI Interactions Log - Branch 1

This file tracks AI interactions, prompts, and outcomes for development work on branch 1_flutter_integration.

## Session 1: Initial Flutter Setup
**Date**: 23-May-2025  
**Time**: 10:00 AM  
**AI Assistant**: Claude 4 Sonnet  
**Duration**: 30 minutes  

### Initial Prompt
```
Please help me integrate a Flutter module into my existing Android app. 
I want to create a simple "Hello World" screen that can be accessed 
from a button in the Android app.
```

### Follow-up Prompts
- "The build is failing with dependency errors"
- "How do I fix the FlutterActivity import?"
- "Can you create a Maestro test for this?"

### Actions Taken
- Created Flutter module using `flutter create -t module`
- Updated Android project configuration
- Added menu button to launch Flutter screen
- Fixed import issues
- Created Maestro test

### Technical Challenges Encountered
1. **Dependency Resolution**: Flutter artifacts weren't built yet
2. **Import Issues**: FlutterActivity import couldn't be resolved automatically
3. **Repository Configuration**: Gradle conflicts between Android and Flutter

### Current Status
- ✅ Flutter module created
- ✅ Android integration configured  
- ✅ Menu button added
- ⏳ Build issues being resolved
- ❌ Maestro test pending

### Next Steps
1. Resolve Flutter artifact dependencies
2. Complete Maestro test
3. Verify end-to-end functionality

### Lessons Learned
- Flutter integration requires careful Gradle setup
- Include approach needs Flutter SDK on all dev machines
- AI tools may struggle with complex import scenarios

### Code Changes Made
- `settings.gradle.kts`: Added Flutter module
- `MainActivity.kt`: Added menu handling
- `main_menu.xml`: Created menu resource

### Build Commands Executed
```bash
flutter create -t module flutter_module
./gradlew assembleDebug
flutter packages get
```

### Error Messages Encountered
```
Could not find io.flutter:flutter_embedding_debug:1.0.0-xyz
Build was configured to prefer settings repositories
```
"""


def main():
    """Main entry point for the script."""
    if len(sys.argv) < 2:
        print("Usage: python make_ai_interactions_script.py <command> [args]")
        print("Commands:")
        print("  create <branch_name> [session_title] - Create new log file")
        print("  setup - Create template and example files")
        print("  help - Show this help message")
        return
    
    command = sys.argv[1]
    logger = AIInteractionsLogger()
    
    if command == "create":
        if len(sys.argv) < 3:
            print("Error: branch_name is required")
            return
        
        branch_name = sys.argv[2]
        session_title = sys.argv[3] if len(sys.argv) > 3 else "Initial Session"
        log_file = logger.create_log_file(branch_name, session_title)
        print(f"Log file created: {log_file}")
        
    elif command == "setup":
        logger.create_template_files()
        print("Template files created successfully")
        
    elif command == "help":
        print(__doc__)
        print("\nCommands:")
        print("  create <branch_name> [session_title] - Create new log file")
        print("  setup - Create template and example files")
        print("  help - Show this help message")
        
    else:
        print(f"Unknown command: {command}")
        print("Use 'help' command to see available options")


if __name__ == "__main__":
    main()