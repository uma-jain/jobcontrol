# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 27 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assuming the env.config is present, will generate random passwords and update.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Generate passwords
$apexPassword = Invoke-GenerateRandomPassword 16
$connectivityPassword = Invoke-GenerateRandomPassword 16
$jobControlRestPassword = Invoke-GenerateRandomPassword 16

# Update passwords in env.config
Invoke-ReplacePropertyValueInConfig "databaseApexPassword" $apexPassword
Invoke-ReplacePropertyValueInConfig "connectivityPassword" $connectivityPassword
Invoke-ReplacePropertyValueInConfig "jobControlRestPassword" $jobControlRestPassword

# End Script (with Transcript)
Invoke-EndScript
