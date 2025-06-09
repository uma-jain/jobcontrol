# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 01 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes the initial Apex directory structure is created and configured.
# Will generate an auto-install.xml file for Apex.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$autoInstallFile = "${workingPath}\auto-install.xml"

Show-Task "Copying auto-xml to working area"
Copy-Item "${masterPath}\Auto Install Scripts\auto-install_template.xml" -Destination "${autoInstallFile}" -Verbose

Invoke-AllSubstitutionStringsInFile "${autoInstallFile}"

# End Script (with Transcript)
Invoke-EndScript
