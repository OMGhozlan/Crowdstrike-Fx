Write-Output "======================"
Write-Output "CrowdStrike Fix by OG"
Write-Output "======================"

$drive = $env:SystemDrive
$directoryPath = "$($drive)\Windows\System32\drivers\CrowdStrike"
$filePattern = "C-00000291*.sys"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFilePath = "$($drive)\Temp\csfix_script_log_$timestamp.txt"

# Check if the Temp directory exists, create it if not
if (-Not (Test-Path "$($drive)\Temp")) {
    New-Item -ItemType Directory -Path "$($drive)\Temp" | Out-Null
}

try {
    "[$(Get-Date)] Script started." | Out-File -Append -FilePath $logFilePath

    Set-Location -Path $directoryPath

    # Get the list of files matching the pattern
    $matchingFiles = Get-ChildItem -Filter $filePattern

    # Log matching files to the log file and print to output
    if ($matchingFiles.Count -eq 0) {
        "[$(Get-Date)] No matching files found." | Out-File -Append -FilePath $logFilePath
        Write-Output "No matching files found."
    } else {
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

    Write-Output "Script completed successfully. Log file saved at $logFilePath"
} catch {
    Write-Output "Error occurred: $_"
    Write-Output "Please ensure that your computer is in Safe Mode and rerun the script."
}
