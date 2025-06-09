# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assuming the Job Control database is inplace and configuration script has been created,
# this script will run the configuration script as the local user.
# NOTE: The local user will need database access and GATES rights
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Test if local user is an Administrator
Test-IfAdministrator

# Call SQL Server to run database configuration script
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort
$jobControlDbName = [String]$configValues.jobControlDatabaseName

# Set null user/password to make make sqlcmd use current user running the script
$apexUser = $null
$apexPassword = $null

$sqlPath = "${databaseWorkingPath}\SQL Server DB Initial Setup.sql"
                                          
Show-Task "Running database configuration script"

Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlPath}"

# End Script (with Transcript)
Invoke-EndScript
