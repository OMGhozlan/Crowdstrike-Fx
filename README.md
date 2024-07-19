# CrowdStrike Fix Script

## Description
A simple PowerShell script for the CrowdStrike issue of June 2024. It performs the following actions:
1. Sets Windows to boot into Safe Mode.
2. Locates and deletes files matching the pattern "C-00000291*.sys" in the CrowdStrike directory.
3. Restores the boot configuration.

## Usage
1. Save the script to a convenient location on your system.
2. Open PowerShell as an administrator.
3. Navigate to the directory where the script is saved.
   ```powershell
   .\CrowdStrikeFix.ps1
   ```
4. Follow any prompts or instructions provided by the script.

## Notes
- Ensure that you have appropriate permissions to modify files and reboot the system.
- If the script fails due to permissions, try running it as admin or an elevated user.
- The script will create a log file at `SYSTEMDRIVE:\Temp\script_log_<timestamp>.txt`.
- If no matching files are found, the script will indicate so in the log and output.