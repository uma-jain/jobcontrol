# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Process and Replace value in env.config
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript

Invoke-LoadEnvironmentConfig

Show-Task "Process Environment Config"

Invoke-AllSubstitutionStringsInFile "${workingPath}\env.config"

# End Script (with Transcript)
Invoke-EndScript
