# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control exists and working.
# Performs installaton of Python NT Services.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Install Job Control NT Services
Show-Task "Install Job Control NT Services"


$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

$groupDomain = [String]$configValues.groupDomain
$groupAppAdm = [String]$configValues.groupAppAdm
$level = "full"

$jcServiceName = "ApexJobControlService${environmentName}"
$smtpServiceName = "ApexDummySMTPService${environmentName}"


# Stop and Delete Job Control Services if already exists
Show-Task "Delete Job Control Service"

if (Get-Service -Name $jcServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $jcServiceName -Verbose
	Remove-Service $jcServiceName
}


Show-Task "Delete Dummy SMTP Service"

if (Get-Service -Name $smtpServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $smtpServiceName -Verbose
	Remove-Service $smtpServiceName
}


# Install Job Control Service
Show-Task "Install Job Control Service"

$scriptBlock = {
	python jobControlService.py install
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError


# Set permissions on Job Control Service
Show-Task "Set permissions on Job Control Service"

Invoke-GetNTServicePermissions -ServiceName $jcServiceName

Invoke-SetNTServicePermissions -ServiceName $jcServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

Invoke-GetNTServicePermissions -ServiceName $jcServiceName


# Install Dummy SMTP Service
Show-Task "Install Dummy SMTP Service"

$scriptBlock = {
	python dummySMTPService.py install
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError


# Set permissions on Dummy SMTP Service
Show-Task "Set permissions on Dummy SMTP Service"

Invoke-GetNTServicePermissions -ServiceName $smtpServiceName

Invoke-SetNTServicePermissions -ServiceName $smtpServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

Invoke-GetNTServicePermissions -ServiceName $smtpServiceName

# End Script (with Transcript)
Invoke-EndScript
