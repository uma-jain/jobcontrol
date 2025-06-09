# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 04 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Create Key Store for Active MQ to give to the client.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$envName = ${environmentName}.ToLower()

$apexConConfigPath = "$rootPath\Apex_${environmentName}\Apex\server\connectivity\config\Keys\ActiveMQ"

$mqAlias = "sftc-${clientName}-${envName}-apexmq-server"

$mqServerKS = "sftc-${clientName}-${envName}-server.ks"
$mqServerCert = "sftc-${clientName}-${envName}-server.cert"
$mqClientTS = "sftc-${clientName}-${envName}-client.ts"

$mqServerKeyPassword = [String]$configValues.mqServerKeyStorePassword
$mqClientKeyPassword = [String]$configValues.mqClientTrustStorePassword

$mqDName = "CN=*.fisglobal.com, OU=SFTC, O=FIS, L=, S=, C=US"


## Create Keys directory
Show-Task "Create Keys directory under Connectivity Server"

Invoke-CreateDirectory "$apexConConfigPath"


# Create Server Key Store
Show-Task "Create Server Key Store"

Write-Host "Server Key Store: ${apexConConfigPath}\${mqServerKS}"

# If key exists, then do not create
If (!(Test-Path "${apexConConfigPath}\${mqServerKS}")) {
	# Use Java keytool to generate key store - Keytool exists in Java home\bin
	$scriptBlock = {
	keytool -genkey -noprompt -alias ${mqAlias} -keyalg RSA -keysize 2048 -validity 3650 -dname "${mqDName}" -keystore "${apexConConfigPath}\${mqServerKS}" -storetype PKCS12 -keypass ${mqServerKeyPassword} -storepass ${mqServerKeyPassword}
	}

	Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError
}
Else {
	Write-Host "Server Key Store already exists, skipping"
}


# Export Certificate
Show-Task "Export Certificate"

Write-Host "Server Certificate: ${apexConConfigPath}\${mqServerCert}"

# If cert exists, then do not create
If (!(Test-Path "${apexConConfigPath}\${mqServerCert}")) {
	$scriptBlock = {
	keytool -export -noprompt -alias ${mqAlias} -keystore "${apexConConfigPath}\${mqServerKS}" -file "${apexConConfigPath}\${mqServerCert}" -keypass ${mqServerKeyPassword} -storepass ${mqServerKeyPassword}
	}

	Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError
}
Else {
	Write-Host "Server Certificate already exists, skipping"
}


# Create Client Trust Store
Show-Task "Create Client Trust Store"

Write-Host "Client Trust Store: ${apexConConfigPath}\${mqClientTS}"

# If key exists, then do not create
If (!(Test-Path "${apexConConfigPath}\${mqClientTS}")) {
	$scriptBlock = {
	keytool -import -noprompt -alias ${mqAlias} -keystore "${apexConConfigPath}\${mqClientTS}" -file "${apexConConfigPath}\${mqServerCert}" -keypass ${mqClientKeyPassword} -storepass ${mqClientKeyPassword}
	}

	Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError
}
Else {
	Write-Host "Client Trust Store already exists, skipping"
}



# Delete certificate as this should be in a store
Show-Task "Delete certificate"

# If cert exists, then delete
If (Test-Path "${apexConConfigPath}\${mqServerCert}") {
	Remove-Item "${apexConConfigPath}\${mqServerCert}" -Verbose
	Write-Host "Server Certificate deleted"
}


# Validate ClientTrust Store
Show-Task "Validate Client Trust Store"

$scriptBlock = {
keytool -list -v -keystore "${apexConConfigPath}\${mqClientTS}" -storepass ${mqClientKeyPassword}
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError


# End Script (with Transcript)
Invoke-EndScript
