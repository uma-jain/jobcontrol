# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 04 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Create NT Services for Active MQ and set permissions.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$mqRootPath = "$rootPath\Apex_${environmentName}\Active MQ"
$mqBinPath = "$mqRootPath\bin\win64"


# Install MQ NT Service
Show-Task "Install Active MQ Service"

$groupDomain = [String]$configValues.groupDomain
$groupAppAdm = [String]$configValues.groupAppAdm
$level = "full"

$mqServiceName = "Apex ActiveMQ ${environmentName}"

# Stop and Delete MQ Service if already exists
Show-Task "Delete MQ Service"

if (Get-Service -Name $mqServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $mqServiceName -Verbose
	Remove-Service $mqServiceName
}

Show-Task "Install MQ Service"

# Use Apache Active MQ command for this
$scriptBlock = {
	.\InstallService.bat
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError


# Set permissions on MQ Service
Show-Task "Set permissions on MQ Service"

Invoke-GetNTServicePermissions -ServiceName $mqServiceName

Invoke-SetNTServicePermissions -ServiceName $mqServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

Invoke-GetNTServicePermissions -ServiceName $mqServiceName


# End Script (with Transcript)
Invoke-EndScript
