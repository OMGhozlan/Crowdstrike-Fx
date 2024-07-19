<#
.SYNOPSIS
    CrowdStrike Fix script

.DESCRIPTION
    This script performs the following actions:
    1. Sets Windows to boot into Safe Mode.
    2. Locates and deletes files matching the pattern "C-00000291*.sys" in the CrowdStrike directory.
    3. Restores the boot configuration.
    4. Logs actions to a log file.

.EXAMPLE
    .\CrowdStrikeFix.ps1

.NOTES
    Ensure that you have appropriate permissions to modify files and reboot the system.
    If the script fails due to permissions, try running it as admin or an elevated user.
    The script will create a log file at C:\Temp\script_log_<timestamp>.txt.
    If no matching files are found, the script will indicate so in the log and output.
#>
Write-Output "======================"
Write-Output "CrowdStrike Fix"
Write-Output "======================"

# Set system to boot into Safe Mode
Write-Output "Setting Windows to boot into Safe Mode..."
Invoke-Expression "bcdedit /set {current} safeboot minimal"
Invoke-Expression "bcdedit /set {current} safebootalternateshell yes"
$rebootChoice = Read-Host "Windows configured to boot into Safe Mode. Reboot now? (Y/N)"
if ($rebootChoice -eq "Y" -or $rebootChoice -eq "y") {
    Restart-Computer -Force
}
else {
    Write-Output "Please reboot your computer into Safe Mode manually."
}

$drive = $env:SystemDrive
$directoryPath = "$($drive)\Windows\System32\drivers\CrowdStrike"
$filePattern = "C-00000291*.sys"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFilePath = "$($drive)\Temp\csfix_script_log_$timestamp.txt"

# Check if the Temp directory exists, create it if not
if (-Not (Test-Path "$($drive)\Temp")) {
    New-Item -ItemType Directory -Path "$($drive)\Temp" | Out-Null
}

# Log actions to the log file
try {
    "[$(Get-Date)] Script started." | Out-File -Append -FilePath $logFilePath

    # Navigate to the specified directory
    Set-Location -Path $directoryPath

    # Get the list of files matching the pattern
    $matchingFiles = Get-ChildItem -Filter $filePattern

    # Log matching files to the log file and print to output
    if ($matchingFiles.Count -eq 0) {
        "[$(Get-Date)] No matching files found." | Out-File -Append -FilePath $logFilePath
        Write-Output "No matching files found."
    }
    else {
        $matchingFiles | ForEach-Object {
            $fileName = $_.Name
            "[$(Get-Date)] Found matching file: $fileName" | Out-File -Append -FilePath $logFilePath
            Write-Output "Found matching file: $fileName"
        }

        # Delete the matching files
        $matchingFiles | ForEach-Object {
            $fileName = $_.Name
            Remove-Item -Path $_.FullName -Force
            "[$(Get-Date)] Deleted file: $fileName" | Out-File -Append -FilePath $logFilePath
            Write-Output "Deleted file: $fileName"
        }
    }
    # Restore boot configuration
    Invoke-Expression "bcdedit /deletevalue {current} safeboot"
    Invoke-Expression "bcdedit /deletevalue {current} safebootalternateshell"
    Write-Output "Script completed successfully. Log file saved at $logFilePath. Please reboot your PC."
}
catch {
    Write-Output "Error occurred: $_"
}

