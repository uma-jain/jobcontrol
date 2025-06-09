# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 01 Mar 2023 - MF - Initial
# v002 - 22 Mar 2023 - MF - Fixed sort order
# --------------------------------------------------------------------------------
# Assumes the initial Apex directory structure is created and configured.
# Will run the Apex installer using the auto-install.xml file
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$autoInstallFile = "${workingPath}\auto-install.xml"
$imagesPath = "D:\Images"

Show-Task "Set Encryption Algorithm and Master password)"

$env:FINACE_ENCRYPTION_ALGORITHM = 'PBEWITHHMACSHA512ANDAES_256'
$env:FINACE_ENCRYPTION_PASSWORD = [String]$configValues.apexEncryptionPassword

Write-Host "Encryption Algorithm File: $env:FINACE_ENCRYPTION_ALGORITHM"


Show-Task "Determine Apex Version (newest installer)"

$newestFile = Get-ChildItem "$imagesPath\*installer*.jar" | Sort-Object -Descending -Property LastWriteTime | Select -First 1

Write-Host "Newest Installer File: $newestFile"

If (!$newestFile) {
	Invoke-AbortScriptWithMessage "Could not find latst installler in '$imagesPath' directory"
}

Show-Task "Install Apex"

$scriptBlock = {
	java -jar "$newestFile" "$autoInstallFile"
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $imagesPath -CheckForError

# End Script (with Transcript)
Invoke-EndScript
