# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Copy Softwares on Citrix server (Remotely)
# Adobe Reader
# Open Office
# KDiff
# Java JRE latest compatible with Apex Collateral
# Powershell
# 7Zip
# Notepad++
# Microsoft Edge
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Run a ScriptBlock on a remote server
$citrixServer = [String]$configValues.citrixServer
$softwarePath = [String]$configValues.softwarePath


# Create the Software directory
$arguments = @($rootPath)

# Copy Software
$fromPath = "$softwarePath\PowerShellCommonLibrary.psm1"
$remotePath = "$softwarePath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "7Zip*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\7Zip*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Powershell*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Powershell*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Notepad++*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Notepad++*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Java JRE*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Java JRE*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "KDiff*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\KDiff*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Adobe*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Adobe*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Apache Open Office*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Apache Open Office*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Microsoft Edge*" } | Select-Object Name
$folderPath = $folderPath.Name
$fromPath = "$softwarePath\Microsoft Edge*"
$remotePath = "$softwarePath\$folderPath"
Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

# End Script (with Transcript)
Invoke-EndScript
