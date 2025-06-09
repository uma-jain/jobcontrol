# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 01 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control and Python is installed and configured.
# Performs a set of tests by running Python commands and checking for errors.
# Also checks the Job Control database to see correct number of records are written.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Prepare Job Control database for testing"

# Setup database values for later calls
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort
$jobControlDbName = [String]$configValues.jobControlDatabaseName
$apexUser = [String]$configValues.databaseApexUser
$apexPassword = [String]$configValues.databaseApexPassword

# Prepare database for testing
$sqlQuery = @"
USE [[[JobControlDatabaseName]]]
GO
DELETE from [JOB_TRACKING]
DELETE from [ALERT_TRACKING]
GO
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery

Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

Show-Task "Perform Job Control Tests"

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

Show-Task "Test - T001 Sleep"

$scriptBlock = {
	python main.py ..\config\testing\T001_sleep_1_seconds.config
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError

# --------------------------------------------------------------------------------

Show-Task "Test - T002 Send Email"

$scriptBlock = {
	python main.py ..\config\testing\T002_send_test_email.config
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError

# --------------------------------------------------------------------------------

Show-Task "Test - T009 Generate Alert (Will send Email)"

$scriptBlock = {
	python main.py ..\config\testing\T009_generate_alert.config
}

# DONT check for errors and this is expected to fail
Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath

# --------------------------------------------------------------------------------

Show-Task "Check for three rows in JOB_TRACKING table"

# Prepare database for testing
$sqlQuery = @"
USE [[[JobControlDatabaseName]]]
GO
DECLARE @resultCount NUMERIC(38,0)
SELECT @resultCount = COUNT(*) FROM JOB_TRACKING
PRINT 'Rows found in JOB_TRACKING: ' + CAST(@resultCount AS VARCHAR)
IF @resultCount <> 3
BEGIN
	THROW 99001, 'ERROR - Expected 4 rows in [JOB_TRACKING]', 1
END

SELECT @resultCount = COUNT(*) FROM ALERT_TRACKING
PRINT 'Rows found in ALERT_TRACKING: ' + CAST(@resultCount AS VARCHAR)
IF @resultCount <> 1
BEGIN
	THROW 99001, 'ERROR - Expected 1 row in [ALERT_TRACKING]', 1
END
GO
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery

Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

# End Script (with Transcript)
Invoke-EndScript
