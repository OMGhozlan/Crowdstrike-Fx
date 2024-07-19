# CrowdStrike Fix Script

## Description
A simple PowerShell script for the CrowdStrike issue of June 2024. It performs the following actions:
1. Locate and delete files matching the pattern "C-00000291*.sys" in the CrowdStrike directory.

## Usage
1. Save the script to a convenient location on your system.
2. Open PowerShell as an administrator.
3. Run the script using the following command:
   ```powershell
   .\CrowdStrikeFix.ps1
   ```
4. Follow any prompts or instructions provided by the script.
5. 

## Notes
- Ensure that you have appropriate permissions to modify files and reboot the system.
- If the script fails due to permissions, try running it as admin or an elevated user
- The script will create a log file at `C:\Temp\script_log.txt`.
- If no matching files are found, the script will indicate so in the log and output.