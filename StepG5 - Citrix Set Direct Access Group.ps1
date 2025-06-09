# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 10 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# For Citrix Installation, sets the "Direct Access Users" users group to allow
# Remote Desktop access without brokers connection.  This is when Citrix is installed,
# without this group you cannot log in as a normal user with RDP.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$citrixServer = [String]$configValues.citrixServer

$clientDomain = [String]$configValues.clientDomain
$rduGroup = "$clientDomain\" + $citrixServer.split('.')[0] + "_RemoteDesktopUsers"

$arguments = @( $rduGroup )

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {
	$rduGroup = $($args[0])

	Write-Host "Checking for 'Direct Access Users' group"
	$dacGroup = Get-LocalGroup -Name "Direct Access Users" -ErrorAction SilentlyContinue

	If (!$dacGroup) {
		Write-Host "'Direct Access Users' group not found, so Citrix may not yet be installed"
		Exit 0
	}

	Write-Host "'Direct Access Users' group found, check for '$rduGroup'"

	$dacMembers = Get-LocalGroupMember -Group "Direct Access Users" -Member "${rduGroup}" -ErrorAction SilentlyContinue

	If ($dacMembers) {
		Write-Host "'$rduGroup' found, so no action to be taken"
		Exit 0
	}

	Write-Host "Adding '$rduGroup' to 'Direct Access Users'"

	Add-LocalGroupMember -Group "Direct Access Users" -Member "$rduGroup"	-ErrorAction Stop
}

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $citrixServer $scriptBlock $arguments

# End Script (with Transcript)
Invoke-EndScript
