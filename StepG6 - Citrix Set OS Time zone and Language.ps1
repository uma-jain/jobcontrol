# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 09 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Set Time zone and Language of Citrix Server remotely.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Run a ScriptBlock on a remote server
$citrixServer = [String]$configValues.citrixServer
$timezoneApp = [String]$configValues.timezoneApp

Show-Task "Setting Timezone and Locale on Citrix Server"

$timezoneApp = Get-TimeZone | Select-Object StandardName
Write-Host "App Timezone is" $timezoneApp.StandardName

$systemLocale = Get-WinSystemLocale | Select-Object Name
Write-Host "App System Locale is" $systemLocale.Name

$arguments = @($timezoneApp.StandardName, $systemLocale.Name)

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {

	$timezoneApp = $($args[0])
	$standardLocal = $($args[1])

	Write-Host "Setting Timezone"

	$timezone = Get-TimeZone | Select-Object StandardName
	Write-Host "Current Timezone is" $timezone.StandardName

	Try {
		Write-Host "Setting Timezone of Citrix to" $timezoneApp

		Set-TimeZone -Name $timezoneApp
		$timezoneCitrix = Get-TimeZone | Select-Object StandardName
		Write-Host "Updated Timezone of Citrix is" $timezoneCitrix.StandardName
	}
	Catch {
		Invoke-AbortScriptWithMessage "Unable to set timezone on Citrix server"
	}


	Write-Host "Setting Locale on Citrix Server"
	
	$systemCulture = Get-Culture | Select-Object Name
	$systemLocale = Get-WinSystemLocale | Select-Object Name

	Write-Host "Current Culture:" $systemCulture.Name
	Write-Host "Current Locale:" $systemLocale.Name

	Try {
		# Set the System-locale setting for the current computer.
		Write-Host "Setting SystemLocale to $standardLocal"

		Set-WinSystemLocale -SystemLocale $standardLocal

		Write-Host "Setting Windows Display Language to $standardLocal"

		Set-WinUILanguageOverride -Language $standardLocal

		$systemCulture = Get-Culture | Select-Object Name

		# Get-WinSystemLocale - Changes take effect after the computer is restarted.
		$systemLocale = Get-WinSystemLocale | Select-Object Name

		Write-Host "New Culture:" $systemCulture.Name
		Write-Host "New Locale:" $systemLocale.Name
	}
	Catch {
		Invoke-AbortScriptWithMessage "Unable to set locale"
	}
	
	Write-Host "Setting Languages to en-US and en-GB"

	Try {
		$currentLP = Get-WinUserLanguageList |  Format-Table -Property LanguageTag,Autonym | Out-String
		Write-Host "Current Language Packs: $currentLP"

		$LanguageList = Get-WinUserLanguageList 
		$LanguageList.Clear()
		$LanguageList.Add("en-US") 
		$LanguageList.Add("en-GB") 
		Set-WinUserLanguageList $LanguageList -Force

		$newLP = Get-WinUserLanguageList |  Format-Table -Property LanguageTag,Autonym | Out-String
		Write-Host "New Language Packs: $newLP"
	}
	Catch {
		Invoke-AbortScriptWithMessage "Unable to set languages"
	}	
}

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $citrixServer $scriptBlock $arguments

# End Script (with Transcript)
Invoke-EndScript
