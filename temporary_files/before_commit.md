# ⚠️ BEFORE COMMIT CHECKLIST ⚠️

## Items to Remove/Review Before Git Push

- [ ] **Flutter Animation**: Remove red blinking/spinning animation from Flutter module
    - File: `../njw_flutter_navigation_demo/lib/main.dart`
    - Revert to simple "Hello World from Flutter!" text
    - Current animation is for demonstration purposes only

- [ ] **Temporary Files**: Review temporary_files directory
    - Check if any content should be moved to main documentation
    - Ensure no sensitive information is accidentally included

- [ ] **DITL Files**: Review DITL files for sensitive content
  - Check `ditl/human_analysis.md` for appropriate public content
  - Verify all human observations are suitable for public repo

- [ ] **Backup Temporary Files**: Consider backing up `temporary_files/` directory to separate repo
  - See `temporary_files/important_readme.md` for instructions
  - Use `temporary_files/backup_temporary_files.sh` script

## Notes

This file serves as a reminder for items that need attention before committing to the remote
repository. The current Flutter animation is intentionally eye-catching to ensure it gets noticed
and removed before production.

## ⚠️ WARNING: DO NOT COMMIT IF THIS FILE HAS CONTENT ⚠️
