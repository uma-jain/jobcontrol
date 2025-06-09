# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Make Database Configure Script in the working directory.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Invoke-CreateDatabaseScriptWorkingArea

Show-Task "Moving database script to working area"
Copy-Item "${masterPath}\SQL Server Scripts\SQL Server DB Initial Setup.sql" -Destination "${databaseWorkingPath}" -Verbose

Invoke-AllSubstitutionStringsInFile "${databaseWorkingPath}\SQL Server DB Initial Setup.sql"

# End Script (with Transcript)
Invoke-EndScript