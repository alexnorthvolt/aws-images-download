Images bulk downloading script

Before start using:

  0. "AWS Command Line Interface v2" app should be installed (from the Company Portal, tested with version 2.4.25.0)
  1. Check the S3 base path ($S3BasePath), which is by default "s3://nv-firefly-ett-ds1-prod-image-upload-api/"
  2. Check and edit the destination folder path ($DestPath)
  3. Put the file list into the "file_list.txt"
  4. Run the script with the PowerShell, it will request authentication (AWS SSO login)
