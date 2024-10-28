# Images bulk downloading from AWS

# AWS SSO login
aws sso login --profile nv-automation

# Set the S3 base path and destination path
$S3BasePath = "s3://nv-firefly-ett-ds1-prod-image-upload-api/"
$DestPath = "C:\sugi\images\"

# Initialize counters
$TotalFiles = (Get-Content -Path "file_list.txt").Count
$DownloadedFiles = 0
$StartTime = Get-Date

# Read the file list and process each file
Get-Content -Path "file_list.txt" | ForEach-Object {
    $FileName = $_

    # Extract folder path and date from filename
    $Parts = $FileName -split '_'
    $FolderPath = $Parts[0]
    $DateFolder = $Parts[1]

    # Combine everything into the full S3 path
    $S3FullPath = "$S3BasePath$FolderPath/$DateFolder/$FileName"

    # Set local path to the same folder for all files
    $LocalPath = "$DestPath$FileName"

    # Download the file from S3
    Write-Host -NoNewline "[$DownloadedFiles/$TotalFiles] Downloading $FileName..."
    aws s3 cp $S3FullPath $LocalPath | Out-Null

    # Update progress
    $DownloadedFiles++
    $Progress = [math]::Round(($DownloadedFiles / $TotalFiles) * 100, 2)
    
    # Calculate ETA
    $ElapsedTime = (Get-Date) - $StartTime
    $TimePerFile = $ElapsedTime.TotalSeconds / $DownloadedFiles
    $RemainingTime = $TimePerFile * ($TotalFiles - $DownloadedFiles)
    $ETA = [TimeSpan]::FromSeconds($RemainingTime).ToString("hh\:mm\:ss")

    Write-Host " Done. Progress: $Progress% | ETA: $ETA | $DownloadedFiles/$TotalFiles"
}

Write-Host "All downloads complete."

# Wait for user input before closing
pause
