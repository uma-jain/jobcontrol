# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 09 June 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Create Db Backup Directly on DB server (Remote RDP)
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Run a ScriptBlock on a remote server
$databaseServer = [String]$configValues.databaseServer
$timezoneApp = [String]$configValues.timezoneApp
$databaseBackupLocation=[String]$configValues.databaseBackupLocation

Show-Task "Setting Timezone and Locale on DB Server"

$timezoneApp = Get-TimeZone | Select-Object StandardName
Write-Host "App Timezone is" $timezoneApp.StandardName

$systemLocale = Get-WinSystemLocale | Select-Object Name
Write-Host "App System Locale is" $systemLocale.Name

$arguments = @($timezoneApp.StandardName, $systemLocale.Name,$databaseBackupLocation)

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {

	Try {
		If (!(Test-Path "$databaseBackupLocation")) {
			New-Item -Path "$databaseBackupLocation" -ItemType Directory -ErrorAction Stop | Out-Null
			Write-Host "Successfully created directory"
		}
		Else {
			Write-Host "Directory already exists"
		}
	}
	Catch {
		Write-Host "Unable to create directory"
	}
	
	
}

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $databaseServer $scriptBlock $arguments

# End Script (with Transcript)
Invoke-EndScript
