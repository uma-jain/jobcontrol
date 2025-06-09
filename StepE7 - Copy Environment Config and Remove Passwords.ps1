# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 10 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Environment Config is correct and installation is completed without errors.
# Copy the Environment Config to the Apex_xxx directory for use un future scripts.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$apexRootPath = "$rootPath\Apex_${environmentName}"
$newEnvConfig = "${apexRootPath}\Jobs\environment.config"

Show-Task "Copy Environment Config to ${apexRootPath}"

Invoke-CopyFiles "${workingPath}\env.config" "${newEnvConfig}"

Show-Task "Remove unencrypted passwords from ${newEnvConfig}"

$newText = Get-Content "${newEnvConfig}" |
	Where-Object { -not $_.ToLower().Contains('password =') }

Set-Content -Path "${newEnvConfig}" -Value $newText

# End Script (with Transcript)
Invoke-EndScript
