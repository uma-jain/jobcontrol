# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 11 Apr 2023 - MF - Initial
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


Show-Task "Generate passwords for MQ"

# Generate passwords
$mqApexPassword = Invoke-GenerateRandomPassword 16
$mqClientPassword = Invoke-GenerateRandomPassword 16
$mqServerKeyStorePassword = Invoke-GenerateRandomPassword 16
$mqClientTrustStorePassword = Invoke-GenerateRandomPassword 16
$mqSystemPassword = Invoke-GenerateRandomPassword 16

# Update passwords in env.config
Invoke-ReplacePropertyValueInConfig "mqApexPassword" $mqApexPassword
Invoke-ReplacePropertyValueInConfig "mqClientPassword" $mqClientPassword

Invoke-ReplacePropertyValueInConfig "mqServerKeyStorePassword" $mqServerKeyStorePassword
Invoke-ReplacePropertyValueInConfig "mqClientTrustStorePassword" $mqClientTrustStorePassword

Invoke-ReplacePropertyValueInConfig "mqSystemPassword" $mqSystemPassword


# End Script (with Transcript)
Invoke-EndScript
