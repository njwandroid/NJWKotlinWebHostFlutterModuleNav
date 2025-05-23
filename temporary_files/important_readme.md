# Important: Temporary Files Directory

This directory (`temporary_files`) is used to store transient files related to the development
process, such as AI interaction logs, DITL notes, and other temporary artifacts.

## Backup Script

The `backup_temporary_files.sh` script is provided to archive the contents of this directory.

### Usage

To back up the files, run the following command from the root of the repository:

```bash
./temporary_files/backup_temporary_files.sh
```

This will create a timestamped tarball of the `temporary_files` directory in the
`archived_temporary_files` directory (which will be created if it doesn't exist).