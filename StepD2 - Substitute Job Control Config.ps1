# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control struture exists, and will perform substitution
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Performing substitution on Job Control configs"

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$envConfig = "$jcRootPath\config\apex_${environmentName}.config"
$globalConfig = "$jcRootPath\config\global.config"

Invoke-AllSubstitutionStringsInFile "$envConfig"
Invoke-AllSubstitutionStringsInFile "$globalConfig"

# End Script (with Transcript)
Invoke-EndScript
