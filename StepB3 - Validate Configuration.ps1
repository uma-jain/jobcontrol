# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Check for Administrator rights
# Validate all mandatory and password configuration settings have been completed.
# Check that the application server (IP) is the one listed in the config - Should be THIS server.
# All the servers specified exist, and can be remotely connected to (Remote PowerShell).
# Database can be connected and check that ApexCollateral_xxx and JobControl_xxx exist.
# Check all AD group exist for this server, (AppAdm, ReadOnly and AppAccess)
# Check all server related AD group exists, <servername>_Administrators, RemoteDesktop, Share groups (MoveIT)
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$citrixServer = [String]$configValues.citrixServer
$applicationServer = [String]$configValues.applicationServer
$databaseServer = [String]$configValues.databaseServer

#-------------------------------------------------------------------------------------

Show-Task "Testing if current user is administrator"
Test-IfAdministrator

#-------------------------------------------------------------------------------------

Invoke-ValidateServerWithPing "Citrix" $citrixServer
Invoke-ValidateServerWithRemoteConnection "Citrix" $citrixServer

Invoke-ValidateServerWithPing "Application" $applicationServer
Invoke-ValidateServerWithRemoteConnection "Application" $applicationServer

Invoke-ValidateServerWithPing "Database" $databaseServer

#-------------------------------------------------------------------------------------
$currentIP = Test-Connection -ComputerName ((Get-CimInstance -ClassName Win32_ComputerSystem).Name) -Count 1 | Select-Object Address
$applicationServerIp = Test-Connection -ComputerName ($applicationServer) -Count 1 | Select-Object Address

Show-Task "Testing if current server is same as application server"
Write-Host "Current Server - IP " $currentIP.Address
Write-Host "Application Server - IP " $applicationServerIp.Address

if ($currentIP.Address -eq $applicationServerIp.Address) {
	Write-Host "This server matches application server specifies in config"
}
else {
	Invoke-AbortScriptWithMessage "Application server doesn't match with CurrentServer"
}

#-------------------------------------------------------------------------------------
# Call SQL Server to create tables as apex user
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort

$jobControlDbName = [String]$configValues.jobControlDatabaseName

# Set null user/password to make make sqlcmd use current user running the script
$apexUser = $null
$apexPassword = $null

#Check If ApexCollateral_XXX exist
$sqlQuery = @"
PRINT 'Testing if [[[collateralDatabaseName]]] exist'
USE [[[collateralDatabaseName]]]
PRINT 'Database [[[collateralDatabaseName]]] exist'
GO
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery
Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

#Check If JobControl_XXX exist
$sqlQuery = @"
PRINT 'Testing if [[[jobControlDatabaseName]]] exist'
USE [[[jobControlDatabaseName]]]
PRINT 'Database [[[jobControlDatabaseName]]] exist'
GO
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery
Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

#-------------------------------------------------------------------------------------
Show-Task "Checking mandatory and password configuration settings"

$findData = Get-ChildItem -Path "$rootPath\INITIAL SETUP\env.config" -Recurse | Select-String -Pattern "TODO"

if (!$findData) {
	Write-Host "Configuration settings are completed."

	Show-Task "Checking if provided values are correct"

	$environmentType = [String]$configValues.environmentType
	$localeLanguage = [String]$configValues.localeLanguage
	$localeCountry = [String]$configValues.localeCountry
	$standardLocal = $localeLanguage + "-" + $localeCountry
	$timezoneStandardName = [String]$configValues.timezoneStandardName

	Invoke-ValidateEnvParameter 'environmentType' $environmentType
	Invoke-ValidateEnvParameter 'standardLocal' $standardLocal
	Invoke-ValidateEnvParameter 'timezoneStandardName' $timezoneStandardName

	Write-Host "All Configuration settings are correct."
}
else {
	Invoke-AbortScriptWithMessage "Configuration settings are not completed. $findData "
}

$findData = Get-ChildItem -Path "$rootPath\INITIAL SETUP\env.config" -Recurse | Select-String -Pattern "AUTO GENERATED"

if (!$findData) {
	Write-Host "All passwords are set."
}
else {
	Invoke-AbortScriptWithMessage "Passwords are not correctly set $findData "
}

#-------------------------------------------------------------------------------------
Show-Task "Checking for Apex AD Group"

$groupReadOnly = [String]$configValues.groupReadOnly
$groupAppAdm = [String]$configValues.groupAppAdm
$groupAppAccess = [String]$configValues.groupAppAccess

#Checking for Readonly ADGroup

Show-Task "Checking for $groupReadOnly Group"

$apexReadOnlyADGroup = Get-ADGroup -LDAPFilter "(name=$groupReadOnly)" -Server "prod.local" | Select-Object Name

If ($apexReadOnlyADGroup) {
	Write-Host "AD Group $groupReadOnly exists"
}
Else {
	Invoke-AbortScriptWithMessage "AD Group $groupReadOnly DOES NOT exists"
}

#Checking for AppAdm ADGroup

Show-Task "Checking for $groupAppAdm Group"

$apexAppAdmADGroup = Get-ADGroup -LDAPFilter "(name=$groupAppAdm)" -Server "prod.local" | Select-Object Name

If ($apexAppAdmADGroup) {
	Write-Host "AD Group $groupAppAdm exists"
}
Else {
	Invoke-AbortScriptWithMessage "AD Group $groupAppAdm DOES NOT exists"
}

#Checking for ApplicationAccess ADGroup

Show-Task "Checking for $groupAppAccess Group"

$apexApplicationAccessADGroup = Get-ADGroup -LDAPFilter "(name=$groupAppAccess)" -Server "client.local" | Select-Object Name

If ($apexApplicationAccessADGroup) {
	Write-Host "AD Group $groupAppAccess exists"
}
Else {
	Invoke-AbortScriptWithMessage "AD Group $groupAppAccess DOES NOT exists"
}

#Checking for Server ADGroup
$applicationServer = "$applicationServer"
$strip = $applicationServer.split('.')[0] + "_Administrators"

Show-Task "Checking for $strip Group"

$apexServerADGroup = Get-ADGroup -LDAPFilter "(name=$strip)" -Server "client.local" | Select-Object Name

If ($apexServerADGroup) {
	Write-Host "AD Group $strip exists"
}
Else {
	Invoke-AbortScriptWithMessage "AD Group $strip DOES NOT exists"
}

#-------------------------------------------------------------------------------------
Show-Task "Checking for Java"

$version = (Get-Command java | Select-Object -ExpandProperty Version).toString()
$versionStrip = [int]$version.toString().split('.')[0]
If ($versionStrip -gt 0) {
	Write-Host "Java" $version "exists"
}
Else {
	Invoke-AbortScriptWithMessage "Java DOES NOT exists"
}

#-------------------------------------------------------------------------------------
Show-Task "Checking for Python"

$version = (Get-Command python | Select-Object -ExpandProperty Version).toString()
$versionStrip = [int]$version.toString().split('.')[0]
If ($versionStrip -gt 0) {
	Write-Host "Python" $version "exists"
}
Else {
	Invoke-AbortScriptWithMessage "Python DOES NOT exists"
}

# End Script (with Transcript)
Invoke-EndScript
