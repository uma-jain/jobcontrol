# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 07 Mar 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Set TimeZone and Language
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$timezoneStandardName = [String]$configValues.timezoneStandardName
Show-Task "Setting Timezone"

$timezone = Get-TimeZone | Select-Object StandardName
Write-Host "Current Timezone is" $timezone.StandardName

Try {
	Write-Host "Setting Timezone to" $timezoneStandardName -ErrorAction Stop
	Set-TimeZone -Name $timezoneStandardName
}
Catch {
	Invoke-AbortScriptWithMessage "Unable to set timezone"
}

$timezone = Get-TimeZone | Select-Object StandardName
Write-Host "Updated Timezone is" $timezone.StandardName

#------------------------------------------------------------------------------

$localeLanguage = [String]$configValues.localeLanguage
$localeCountry = [String]$configValues.localeCountry
$standardLocal = $localeLanguage + "-" + $localeCountry

Show-Task "Setting Locale/Culture"

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
	Invoke-AbortScriptWithMessage "Unable to set system locale"
}

Show-Task "Setting Languages to en-US and en-GB"

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

# End Script (with Transcript)
Invoke-EndScript
