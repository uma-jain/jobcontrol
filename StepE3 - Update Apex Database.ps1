# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 10 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Apex has been installed.
# Will run a python script to update the Apex database to sync with this version of apex.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Update Apex database via Python and JMX command"

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

$scriptBlock = {
	python main.py ..\config\maintenance\970_upgrade_apex_database.config -Force -NoAlert
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError

# End Script (with Transcript)
Invoke-EndScript
