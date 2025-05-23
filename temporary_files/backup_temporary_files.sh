#!/bin/bash

# Backup Temporary Files Script
# This script backs up the contents of the temporary_files directory to a separate Git repository.

# --- Configuration ---
# Target repository for backup (replace with your actual backup repo URL)
BACKUP_REPO_URL="git@github.com:your_username/project_backup_repo.git"

# Subdirectory within the backup repo to store these files
# (uses project name and current date to avoid conflicts)
PROJECT_NAME=$(basename "$(pwd)")
BACKUP_SUBDIR="${PROJECT_NAME}_$(date +%Y-%m-%d_%H-%M-%S)"

# Temporary clone location for the backup repo
TEMP_CLONE_DIR="/tmp/${PROJECT_NAME}_backup_clone"

# --- Script Logic ---

# 1. Ensure we are in the project root
if [ ! -d ".git" ]; then
    echo "Error: This script must be run from the root of your project directory." >&2
    exit 1
fi

# 2. Check if temporary_files directory exists
if [ ! -d "temporary_files" ]; then
    echo "Info: temporary_files directory not found. Nothing to back up." >&2
    exit 0
fi

# 3. Check if temporary_files directory is empty
if [ -z "$(ls -A temporary_files/)" ]; then
   echo "Info: temporary_files directory is empty. Nothing to back up." >&2
   exit 0
fi

# 4. Clean up any previous temporary clone
if [ -d "$TEMP_CLONE_DIR" ]; then
    echo "Cleaning up previous temporary clone directory..." >&2
    rm -rf "$TEMP_CLONE_DIR"
fi

# 5. Clone the backup repository
echo "Cloning backup repository from $BACKUP_REPO_URL..." >&2
git clone "$BACKUP_REPO_URL" "$TEMP_CLONE_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone backup repository. Check URL and permissions." >&2
    exit 1
fi

cd "$TEMP_CLONE_DIR"

# 6. Create subdirectory for this backup
if [ -d "$BACKUP_SUBDIR" ]; then
    echo "Warning: Backup subdirectory $BACKUP_SUBDIR already exists. Merging changes." >&2
else
    mkdir -p "$BACKUP_SUBDIR"
    echo "Created backup subdirectory: $BACKUP_SUBDIR" >&2
fi

# 7. Copy temporary files to the backup subdirectory
# Using rsync to preserve structure and handle updates efficiently
echo "Copying files from project's temporary_files to backup repo subdirectory..." >&2
rsync -av --delete "../../temporary_files/" "./${BACKUP_SUBDIR}/"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy temporary files to backup directory." >&2
    cd ..
    rm -rf "$TEMP_CLONE_DIR" # Clean up
    exit 1
fi

# 8. Commit and push changes to the backup repository
# Check if there are any changes to commit
git add "${BACKUP_SUBDIR}/"
if git diff --staged --quiet; then
    echo "No new changes to commit to backup repository." >&2
else
    echo "Committing changes to backup repository..." >&2
    git commit -m "Backup temporary files for $PROJECT_NAME on $(date +%Y-%m-%d %H:%M:%S)"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to commit changes to backup repository." >&2
        cd ..
        rm -rf "$TEMP_CLONE_DIR" # Clean up
        exit 1
    fi

    echo "Pushing changes to backup repository..." >&2
    git push origin
    if [ $? -ne 0 ]; then
        echo "Error: Failed to push changes to backup repository." >&2
        # Optionally, offer to retry or handle the error
    else
        echo "Backup successful!" >&2
    fi
fi

# 9. Clean up temporary clone directory
cd ..
rm -rf "$TEMP_CLONE_DIR"

echo "Backup process completed." >&2

# --- Instructions for Use (from important_readme.md) ---
# 1. Configure BACKUP_REPO_URL: Set the SSH or HTTPS URL of your backup Git repository.
# 2. Ensure Git is Configured: Your Git environment should be set up for pushing to the backup repo (e.g., SSH keys).
# 3. Run from Project Root: Execute this script from the main project's root directory.
#    Example: ./temporary_files/backup_temporary_files.sh
# 4. Permissions: Make the script executable: `chmod +x temporary_files/backup_temporary_files.sh`
#
# --- Alternative: Git Submodule Approach (Conceptual) ---
# If you prefer a Git submodule approach for managing temporary files:
#
# 1. Initialize a new Git repo in your `temporary_files` directory:
#    cd temporary_files
#    git init
#    git add .
#    git commit -m "Initial commit of temporary files"
#    git remote add origin <URL_of_dedicated_temp_files_repo>
#    git push -u origin main
#    cd ..
#
# 2. Remove the existing `temporary_files` from the main project's tracking (if already tracked):
#    git rm -r --cached temporary_files
#    # Add temporary_files/ to .gitignore if it's not already (it is in this project)
#
# 3. Add the `temporary_files` repo as a submodule to your main project:
#    git submodule add <URL_of_dedicated_temp_files_repo> temporary_files
#    git commit -m "Add temporary_files as a submodule"
#
# 4. Workflow with submodule:
#    - To update temporary files:
#      cd temporary_files
#      git add .
#      git commit -m "Update temporary docs for feature X"
#      git push
#      cd ..
#      git add temporary_files # This records the new commit hash of the submodule
#      git commit -m "Update temporary_files submodule to latest"
#
#    - To pull changes (e.g., on another machine or by another team member):
#      git submodule update --init --recursive
#
# This script currently implements the CLONE AND PUSH method, not the submodule method.
# The submodule method requires manual setup but offers tighter integration if preferred.