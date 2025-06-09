# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Replacing Apex Config Files
# \Apex\.installation-files\installation.properties
# \Apex\client\config\Client.local.properties
# \Apex\server\core\config\Server.local.properties
# \Apex\server\core\bin\env-local.cmd
# \Apex\server\connectivity\config\application.local.properties
# \Apex\server\connectivity\bin\env-local.cmd
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Perform Substitutions on all apex files config"

$apexRoot = "$rootPath\Apex_$environmentName\Apex"

Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\.installation-files\*"
Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\client\config\*"
Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\server\core\config\*"
Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\server\core\bin\*"
Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\server\connectivity\config\*"
Invoke-AllSubstitutionStringsInMultipleFiles "$apexRoot\server\connectivity\bin\*"

# End Script (with Transcript)
Invoke-EndScript
