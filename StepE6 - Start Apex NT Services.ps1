# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 02 Mar 2023 - MF - Initial
# v002 - 12 Jun 2023 - ST - Test - T004_monitor_apex_ping.config added
# --------------------------------------------------------------------------------
# Assumes Apex NT Services exist and Apex is working.
# Sets the Apex NT Services to Automatic and starts them.
# Check if Apex Collateral is running
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$apexServiceName = "ApexCollateral${environmentName}"
$connectivityServiceName = "ApexConnectivity${environmentName}"
$optimzerServiceName = "ApexOptimization${environmentName}"
$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

Show-Task "Start Apex NT Services"

Invoke-StartNTService $apexServiceName

Invoke-StartNTService $connectivityServiceName

# --------------------------------------------------------------------------------
# Check if Apex Collateral is running
Show-Task "Test - T004_monitor_apex_ping.config"

$scriptBlock = {
	python main.py ..\config\testing\T004_monitor_apex_ping.config
}

# DONT check for errors and this is expected to fail
Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath


# End Script (with Transcript)
Invoke-EndScript
