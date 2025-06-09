# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 10 Mar 2023 - MF - Initial
# v002 - 11 Apr 2023 - MF - Added script 980
# --------------------------------------------------------------------------------
# Assumes Apex has been installed.
# Will run a python script to copy the PS customisations from the connectivity\bin
# directory into the Jobs area.
# Runs python script to set the environment name in the database.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"


Show-Task "Copy PS Customisations via Python and JMX command"

$scriptBlock = {
	python main.py ..\config\maintenance\977_copy_customer_job_control_configs -Force -NoAlert
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError


Show-Task "Update environment name in database via Python"

$scriptBlock = {
	python main.py ..\config\maintenance\980_set_environment_name_in_database -Force -NoAlert
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError


# End Script (with Transcript)
Invoke-EndScript
