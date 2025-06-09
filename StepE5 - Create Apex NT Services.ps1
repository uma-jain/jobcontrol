# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Apex is configued.
# Performs installaton of Apex NT Services.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Install Job Control NT Services
Show-Task "Install Apex NT Services"

$apexRootPath = "$rootPath\Apex_${environmentName}\Apex"
$coreBinPath = "$apexRootPath\server\core\bin"

$groupDomain = [String]$configValues.groupDomain
$groupAppAdm = [String]$configValues.groupAppAdm
$level = "full"

$apexServiceName = "ApexCollateral${environmentName}"
$connectivityServiceName = "ApexConnectivity${environmentName}"
$optimzerServiceName = "ApexOptimization${environmentName}"


# Stop and Delete Apex Services if already exists
Show-Task "Delete Core Service Service"

if (Get-Service -Name $apexServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $apexServiceName -Verbose
	Remove-Service $apexServiceName
}

Show-Task "Delete Apex Connectivity Service"

if (Get-Service -Name $connectivityServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $connectivityServiceName -Verbose
	Remove-Service $connectivityServiceName
}

Show-Task "Delete Apex Optimizer Service"

if (Get-Service -Name $optimzerServiceName -ErrorAction SilentlyContinue) {
	Stop-Service -Name $optimzerServiceName -Verbose
	Remove-Service $optimzerServiceName
}


Show-Task "Install Core Service Service"

# Usage: service_MS.cmd {serviceAction} {serviceType} {environmentType}
$scriptBlock = {
	.\service_MS.cmd install SERVER $environmentName
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $coreBinPath -CheckForError


# Set permissions on Job Control Service
Show-Task "Set permissions on Job Control Service"

Invoke-GetNTServicePermissions -ServiceName $apexServiceName

Invoke-SetNTServicePermissions -ServiceName $apexServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

Invoke-GetNTServicePermissions -ServiceName $apexServiceName


# Install Apex Connectivity Service
Show-Task "Install Apex Connectivity Service"

# Usage: service_MS.cmd {serviceAction} {serviceType} {environmentType}
$scriptBlock = {
	.\service_MS.cmd install CONN $environmentName
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $coreBinPath -CheckForError


# Set permissions on Apex Connectivity Service
Show-Task "Set permissions on Apex Connectivity Service"

Invoke-GetNTServicePermissions -ServiceName $connectivityServiceName

Invoke-SetNTServicePermissions -ServiceName $connectivityServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

Invoke-GetNTServicePermissions -ServiceName $connectivityServiceName


# Install Apex Optimizer Service (If enabled)
Show-Task "Install Apex Optimizer Service"

$includeOptimizer = [String]$configValues.includeOptimizer

If ($includeOptimizer -ieq 'True') {
	# Usage: service_MS.cmd {serviceAction} {serviceType} {environmentType}
	$scriptBlock = {
		.\service_MS.cmd install OPT $environmentName
	}

	Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $coreBinPath -CheckForError


	# Set permissions on Apex Optimizer Service
	Show-Task "Set permissions on Apex Optimizer Service"

	Invoke-GetNTServicePermissions -ServiceName $optimzerServiceName

	Invoke-SetNTServicePermissions -ServiceName $optimzerServiceName -GroupName $groupDomain\$groupAppAdm -PermissionsLevel $level

	Invoke-GetNTServicePermissions -ServiceName $optimzerServiceName
}
Else {
	Write-Host "Apex Optimizer Service not configured for installation"
}

# End Script (with Transcript)
Invoke-EndScript
