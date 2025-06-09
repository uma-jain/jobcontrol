# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 01 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control exists and working and Job Control NT Services are installed.
# Sets the Job Control NT Services to Automatic and starts them.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$jcServiceName = "ApexJobControlService${environmentName}"
$smtpServiceName = "ApexDummySMTPService${environmentName}"

Show-Task "Start Job Control NT Services"

Invoke-StartNTService $jcServiceName

Invoke-StartNTService $smtpServiceName

# End Script (with Transcript)
Invoke-EndScript
