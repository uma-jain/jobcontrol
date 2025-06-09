# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 07 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Validate Active MQ is running
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


Show-Task "Validating MQ is running"

$mqConnectivityPort = [String]$configValues.mqConnectivityPort
$mqAdminPort = [String]$configValues.mqAdminPort

Write-Host "Checking for main MQ port $mqConnectivityPort"

$mqPortCheck = Get-NetTCPConnection -State Listen -LocalPort $mqConnectivityPort | Select-Object local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}

if ($null -eq $mqPortCheck){
	Invoke-AbortScriptWithMessage "Unable to find Apache Active MQ running on port $mqConnectivityPort"
}
else {
	Write-Host "Apache Active MQ running on port $mqConnectivityPort"
}


Write-Host "Checking for admin MQ port $mqAdminPort"

$mqAdminPortCheck = Get-NetTCPConnection -State Listen -LocalPort $mqAdminPort | Select-Object local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}

if ($null -eq $mqAdminPortCheck){
	Invoke-AbortScriptWithMessage "Unable to find Apache Active MQ Admin Console running on port $mqAdminPortCheck"
}
else {
	Write-Host "Apache Active MQ Admin Console running on port $mqAdminPort"
}


# End Script (with Transcript)
Invoke-EndScript
