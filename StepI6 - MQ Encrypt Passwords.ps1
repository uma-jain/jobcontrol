# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 04 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Encrypt password used for Active MQ.
# The WeB Portal password is different and needs the use the jetty-util jar to encrypt
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$credentialsEncPath = "$rootPath\Apex_${environmentName}\Active MQ\conf\credentials-enc.properties"
$jettyRealmPath = "$rootPath\Apex_${environmentName}\Active MQ\conf\jetty-realm.properties"

$apexEncryptionPassword = [String]$configValues.apexEncryptionPassword


Show-Task "Encrypt MQ passwords"

Write-Host "Password type: mqApexPassword"

$mqApexPassword = [String]$configValues.mqApexPassword
$apexPassword = Invoke-ActiveMQEncyptPassword $apexEncryptionPassword $mqApexPassword
Invoke-ReplacePropertyValueInConfig "apex.password" $apexPassword $credentialsEncPath

Write-Host "Password type: mqClientPassword"

$mqClientPassword = [String]$configValues.mqClientPassword
$clientPassword = Invoke-ActiveMQEncyptPassword $apexEncryptionPassword $mqClientPassword
Invoke-ReplacePropertyValueInConfig "client.password" $clientPassword $credentialsEncPath

Write-Host "Password type: mqServerKeyStorePassword"

$mqServerKeyStorePassword = [String]$configValues.mqServerKeyStorePassword
$serverKeyStorePassword = Invoke-ActiveMQEncyptPassword $apexEncryptionPassword $mqServerKeyStorePassword
Invoke-ReplacePropertyValueInConfig "keystore.password" $serverKeyStorePassword $credentialsEncPath

Write-Host "Password type: mqSystemPassword"

$mqSystemPassword = [String]$configValues.mqSystemPassword
$systemPassword = Invoke-ActiveMQEncyptPassword $apexEncryptionPassword $mqSystemPassword
Invoke-ReplacePropertyValueInConfig "activemq.password" $systemPassword $credentialsEncPath

Write-Host "Password type: admin (Jetty)"

$mqWebPortalPassword = [String]$configValues.mqWebPortalPassword
$webPortalPassword = Invoke-JettyEncyptPassword admin $mqWebPortalPassword
$webNewLine = "admin: $webPortalPassword, admin"
Invoke-ReplaceWholeLineInConfig "admin:" $webNewLine $jettyRealmPath

# End Script (with Transcript)
Invoke-EndScript
