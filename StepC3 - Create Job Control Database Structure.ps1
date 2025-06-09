# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 27 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Create Job Control Database structure and populate with default data
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Invoke-CreateDatabaseScriptWorkingArea

# Copy databae script to working area for ubstitutions
Show-Task "Copying Job Control database scripts to working area"

Copy-Item -Path "${masterPath}\SQL Server Scripts\Job Control*.sql" -Destination "${databaseWorkingPath}" -Verbose

# Perform Substitutions on all Job Control scripts
Show-Task "Perform Substitutions on all Job Control scripts"

Invoke-AllSubstitutionStringsInMultipleFiles "${databaseWorkingPath}\Job Control*.sql"

# Call SQL Server to create tables as apex user on Job Control database
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort
$jobControlDbName = [String]$configValues.jobControlDatabaseName
$apexUser = [String]$configValues.databaseApexUser
$apexPassword = [String]$configValues.databaseApexPassword

$sqlPath = "${databaseWorkingPath}\"

Show-Task "Job Control Database - Creating Tables"
Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlPath}\Job Control - Create Tables.sql"

Show-Task "Job Control Database - Stored Procedures"
Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlPath}\Job Control - Stored Procedures.sql"

Show-Task "Job Control Database - Settings"
Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlPath}\Job Control - Settings.sql"

Show-Task "Job Control Database - Metric Defintions"
Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlPath}\Job Control - Metric Defintions.sql"

# End Script (with Transcript)
Invoke-EndScript
