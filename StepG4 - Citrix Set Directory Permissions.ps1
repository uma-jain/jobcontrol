# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# For CTX Add Infosec Group
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$citrixServer = [String]$configValues.citrixServer
$prodGroup = [String]$configValues.groupAppAccess
$clientDomain = [String]$configValues.clientDomain
$groupDomain = [String]$configValues.groupDomain
$groupAppAdm = [String]$configValues.groupAppAdm
$groupReadOnly = [String]$configValues.groupReadOnly

$arguments = @($environmentName, $clientDomain, $prodGroup, $rootPath , $groupDomain, $groupAppAdm, $groupReadOnly )

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {
	$environmentName = $($args[0])
	$groupAppAccess = $($args[2])
	$clientDomain = $($args[1])
	$rootPath = $($args[3])
	$groupDomain = $($args[4])
	$groupAppAdm = $($args[5])
	$groupReadOnly = $($args[6])

	# ------------------------- D:\
	Try {
		Write-Host "Add Modify Permissions to $groupDomain\$groupAppAdm"
		$rule = [System.Security.AccessControl.FileSystemAccessRule]::new("$groupDomain\$groupAppAdm", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")   
		$acl = Get-Acl -Path "$rootPath"   
		$acl.SetAccessRule($rule)   
		$acl | Set-Acl "$rootPath" -ErrorAction Stop 

		$acl = Get-Acl -Path "$rootPath"   
		$acl_post = $acl | Format-List | Out-String   
		Write-Host "Permissions post AccessRule addition: $acl_post"

	}
	Catch {
		Write-Host "Unable to create Access Rule on '$rootPath'"
		Exit 1
	}

	# ------------------------- D:\
	Try {
		Write-Host "Add ReadOnly Permissions to $groupDomain\$groupReadOnly"
		$rule = [System.Security.AccessControl.FileSystemAccessRule]::new("$groupDomain\$groupReadOnly", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")   
		$acl = Get-Acl -Path "$rootPath"   
		$acl.SetAccessRule($rule)   
		$acl | Set-Acl "$rootPath" -ErrorAction Stop 

		$acl = Get-Acl -Path "$rootPath"   
		$acl_post = $acl | Format-List | Out-String   
		Write-Host "Permissions post AccessRule addition: $acl_post"
	}
	Catch {
		Write-Host "Unable to create Access Rule on '$rootPath'"
		Exit 1
	}

	# ------------------------- D:\\Apex_XXX\Apex\Client
	Try {
		Write-Host "Add ReadOnly Permissions to $clientDomain\$groupAppAccess"
		$rule = [System.Security.AccessControl.FileSystemAccessRule]::new("$clientDomain\$groupAppAccess", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")   
		$acl = Get-Acl -Path "$rootPath\Apex_$environmentName\Apex\Client" 

		$acl.SetAccessRule($rule)   
		$acl | Set-Acl "$rootPath\Apex_$environmentName\Apex\Client" -ErrorAction Stop

		$acl = Get-Acl -Path "${rootPath}Apex_$environmentName\Apex\Client"   
		$acl_post = $acl | Format-List | Out-String   

		Write-Host "Permission post AccessRule addition $acl_post"

	}
	Catch {
		Write-Host "Unable to create Access Rule on '$rootPath\Apex_$environmentName\Apex\Client'" $_.Exception.Message -ForegroundColor Red
		Exit 1
	}

	# ------------------------------------D:\\Apex_XXX\Apex\Client\log
	Try {
		Write-Host "Add Modify Permissions to $clientDomain\$groupAppAccess"
		$rule = [System.Security.AccessControl.FileSystemAccessRule]::new("$clientDomain\$groupAppAccess", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")   
		$acl = Get-Acl -Path "$rootPath\Apex_$environmentName\Apex\Client\log" -ErrorAction Stop 
		$acl.SetAccessRule($rule)   
		$acl | Set-Acl "$rootPath\Apex_$environmentName\Apex\Client\log"  
		$acl = Get-Acl -Path "$rootPath\Apex_$environmentName\Apex\Client\log"   
		$acl_post = $acl | Format-List | Out-String   
		Write-Host "Permission post AccessRule addition $acl_post"       

	}
	Catch {
		Write-Host "Unable to create Access Rule on '$rootPath\Apex_$environmentName\Apex\Client\log'"
		Exit 1
	}

}

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $citrixServer $scriptBlock $arguments

# End Script (with Transcript)
Invoke-EndScript
