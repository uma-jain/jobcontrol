# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Set Permissions for Directories
# Set root (D:\) drive Permission for AppAdm, ReadOnly and LOCAL SERVICE
# NOTE: For Administrators you need to add the <ServerName>_Administrators group to
# allow GATES users that are NOT elevated access to the apex files.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$groupDomain = [String]$configValues.groupDomain
$groupAppAdm = [String]$configValues.groupAppAdm
$groupReadOnly = [String]$configValues.groupReadOnly
$computerName = $env:COMPUTERNAME

$apexRoot = "$rootPath\Apex_$environmentName"

Show-Task "Set NTFS Permissions"

# Root Drive - e.g., D:\
Invoke-AddDirectoryACLPermission "$rootPath" "$groupDomain\$groupAppAdm" "Modify"
Invoke-AddDirectoryACLPermission "$rootPath" "$groupDomain\$groupReadOnly" "ReadAndExecute"
Invoke-AddDirectoryACLPermission "$rootPath" "NT AUTHORITY\LOCAL SERVICE" "Modify"
Invoke-AddDirectoryACLPermission "$rootPath" "${computerName}_Administrators" "Modify"

Show-Task "Enable HTFS Inheritance"

Invoke-EnableDirectoryACLInheritance "$apexRoot"

# End Script (with Transcript)
Invoke-EndScript
