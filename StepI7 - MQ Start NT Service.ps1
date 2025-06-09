# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 07 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Start NT Services for Active MQ.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

<#
$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

Show-Task "Stop Apex Services"

$scriptBlock = {
	python main.py ..\config\testing\581_shutdown_apex_services.config
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError
#>

Show-Task "Start Active MQ Service"

$mqServiceName = "Apex ActiveMQ ${environmentName}"

Invoke-StartNTService $mqServiceName

<#
Show-Task "Start Apex Services"

$scriptBlock = {
	python main.py ..\config\testing\580_startup_apex_services.config
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError
#>

# End Script (with Transcript)
Invoke-EndScript
