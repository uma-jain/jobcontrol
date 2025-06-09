# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 02 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assuming the Job Control database is inplace and populated with default data,
# this script will create the SQL Agent Jobs for Housekeeping (H1,H2,H3,H4 and W1)
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Invoke-CreateDatabaseScriptWorkingArea

# Copy files to working area
Show-Task "Copying SQL Agent Job (Housekeeping) database scripts to working area"

Copy-Item -Path "${masterPath}\SQL Server Scripts\Job SQL Housekeeping*.sql" -Destination "${databaseWorkingPath}" -Verbose

# Perform Substitutions on all Job Control scripts
Invoke-AllSubstitutionStringsInMultipleFiles "${databaseWorkingPath}\Job SQL Housekeeping*.sql"

# Call SQL Server to create tables as apex user on Job Control database
$dbServer = [String]$configValues.databaseServer
$dbPort = [String]$configValues.databaseSQLPort
$jobControlDbName = [String]$configValues.jobControlDatabaseName
$jobPrefix = [String]$configValues.jobPrefix

# Set null user/password to make make sqlcmd use current user running the script
$apexUser = $null
$apexPassword = $null

$sqlPath = "${databaseWorkingPath}\"

Show-Task "Job Control Database - Creating SQL Agent Jobs (Housekeeing)"

$fileList = Get-ChildItem -Path "${sqlPath}\Job SQL Housekeeping*.sql" -Recurse
foreach ($thisFile in $fileList) {
	Invoke-RunSQLServerScriptFromFile $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${thisFile}"
}

# List Jobs to console for reference
Show-Task "List application SQL Agent Jobs"

$sqlQuery = @"
:setvar SQLCMDMAXVARTYPEWIDTH 45
:setvar SQLCMDMAXFIXEDTYPEWIDTH 45
SELECT
	S.name AS JOB_NAME,
	SS.name AS SCHEDULE_NAME,
	S.enabled AS JOB_ENABLED
FROM msdb.dbo.sysjobs S
	LEFT JOIN msdb.dbo.sysjobschedules SJ ON S.job_id = SJ.job_id
	LEFT JOIN msdb.dbo.sysschedules SS ON SS.schedule_id = SJ.schedule_id
WHERE S.name LIKE '${jobPrefix}%Batch_H%'
	OR S.name LIKE '${jobPrefix}%Batch_W%'
ORDER BY S.name, SS.name
"@

$sqlQuery = Invoke-AllSubstitutionStringsInString $sqlQuery

Invoke-RunSQLServerScriptFromQuery $dbServer $dbPort $jobControlDbName $apexUser $apexPassword "${sqlQuery}"

# End Script (with Transcript)
Invoke-EndScript
