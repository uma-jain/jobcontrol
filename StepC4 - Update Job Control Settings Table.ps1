# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 27 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assuming the Job Control database is inplace and populated with default data,
# this script updated the Settings table with specific values set in env.config.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Call SQL Server to updated specific values as the apex user on Job Control database
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort
$jobControlDbName = [String]$configValues.jobControlDatabaseName
$apexUser = [String]$configValues.databaseApexUser
$apexPassword = [String]$configValues.databaseApexPassword

$sqlQuery = @"
USE [[[JobControlDatabaseName]]]
GO
UPDATE [SETTINGS] SET [VALUE] = '[[clientName]]' WHERE [KEY] = 'Client'
UPDATE [SETTINGS] SET [VALUE] = '[[applicationServer]]:[[jobControlRestPort]]' WHERE [KEY] = 'JobControlServer'
UPDATE [SETTINGS] SET [VALUE] = '[[jobControlRestPassword]]' WHERE [KEY] = 'RestPassword'
UPDATE [SETTINGS] SET [VALUE] = '[[collateralDatabaseName]]' WHERE [KEY] = 'ApexDatabaseName'
UPDATE [SETTINGS] SET [VALUE] = '[[databaseBackupLocation]]' WHERE [KEY] = 'DatabaseBackupLocation'
UPDATE [SETTINGS] SET [VALUE] = '[[jobPrefix]]' WHERE [KEY] = 'JobPrefix'
GO
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery

Show-Task "Job Control Database - Updating [Settings] table from env.config"
Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

# End Script (with Transcript)
Invoke-EndScript
