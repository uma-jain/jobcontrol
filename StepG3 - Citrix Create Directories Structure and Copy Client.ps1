# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Create Directory Structures on Citrix server (Remotely)
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

$arguments = @($environmentName, $rootPath, ${clientName})

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {

	$environmentName = $($args[0])
	$rootPath = $($args[1])
	$clientName = $($args[2])

	# Rename Drives
	Write-Host "Renaming C: Drive to '${clientName} ${environmentName} Citrix'"

	Label C: ${clientName} ${environmentName} Citrix

	Write-Host "Renaming D: Drive to 'Data'"

	Label D: Data

	# Create Backups Directory
	Write-Host "Creating directory '${rootPath}\Backups'"

	Try {
		If (!(Test-Path "${rootPath}\Backups")) {
			New-Item -Path "${rootPath}\Backups" -ItemType Directory -ErrorAction Stop | Out-Null
			Write-Host "Successfully created directory"
		}
		Else {
			Write-Host "Directory already exists"
		}
	}
	Catch {
		Write-Host "Unable to create directory"
	}

	# Create Temp Directory
	Write-Host "Creating directory '${rootPath}\Temp'"

	Try {
		If (!(Test-Path "${rootPath}\Temp")) {
			New-Item -Path "${rootPath}\Temp" -ItemType Directory -ErrorAction Stop | Out-Null
			Write-Host "Successfully created directory"
		}
		Else {
			Write-Host "Directory already exists"
		}
	}
	Catch {
		Write-Host "Unable to create directory"
	}

	# Create Apex_xxx Directory
	Write-Host "Creating directory '$rootPath\Apex_$environmentName'"

	Try {
		If (!(Test-Path "$rootPath\Apex_$environmentName")) {
			New-Item -Path "$rootPath\Apex_$environmentName" -ItemType Directory -ErrorAction Stop | Out-Null
			Write-Host "Successfully created directory"
		}
		Else {
			Write-Host "Directory already exists"
		}
	}
	Catch {
		Write-Host "Unable to create directory"
	}

	# Create Apex\client Directory
	Write-Host "Creating directory '$rootPath\Apex_$environmentName\Apex\client'"

	Try {
		If (!(Test-Path "$rootPath\Apex_$environmentName\Apex\client")) {
			New-Item -Path "$rootPath\Apex_$environmentName\Apex\client" -ItemType Directory -ErrorAction Stop | Out-Null
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

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $citrixServer $scriptBlock $arguments

# Copy the newly install Client to Citrix server (Watch out for D:\\ as it needs to be D:\)
$fromPath = "${rootPath}Apex_$environmentName\Apex\client\*"
$remotePath = "${rootPath}Apex_$environmentName\Apex\client\"

Invoke-CopyFilesToRemoteComputer $citrixServer $fromPath $remotePath -Recurse

# End Script (with Transcript)
Invoke-EndScript
