# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 07 Mar 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Assumes the directory strcutures are created.
# Checks to the Apex and Drop Share AG groups, and they they exist checks for the
# shares, creating them if the dont exist, then corrects the NTFS permissions.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$clientDomain = [String]$configValues.clientDomain
$skipShareCreation = [String]$configValues.skipShareCreation 
$skipShareCreation = [bool]::Parse("$skipShareCreation")
$computerName = $env:COMPUTERNAME

$dateStr = $((Get-Date).ToLocalTime()).ToString("yyyy-MMM-dd HHmmss")
$apexRoot = "${rootPath}"

$apexShareName = "Apex_${environmentName}"
$apexShareDesc = "Created by SFTC Automation on $dateStr"
$apexSharePath = "${apexRoot}Apex_${environmentName}"

$dropShareName = "Apex_Drop_${environmentName}"
$dropShareDesc = "Created by SFTC Automation on $dateStr"
$dropSharePath = "${apexRoot}Apex_${environmentName}\Drop"

$apexShareReadOnlyName = "${computerName}_Apex_${environmentName}-R"
$apexShareChangeName = "${computerName}_Apex_${environmentName}-C"
$dropShareReadOnlyName = "${computerName}_Apex_Drop_${environmentName}-R"
$dropShareChangeName = "${computerName}_Apex_Drop_${environmentName}-C"

# ---- Apex Share

$canProcessApexShare = $True

Show-Task "skipShareCreation : $skipShareCreation"
If($skipShareCreation -eq $False){
		
	Show-Task "Checking for Apex Share AD Group '${apexShareReadOnlyName}'"

	$apexShareReadOnlyADGroup = Get-ADGroup -Identity "${apexShareReadOnlyName}" -Server "$clientDomain"	
	If ($apexShareReadOnlyADGroup) {
		Write-Host "AD Group ${apexShareReadOnlyName} exists"
	}
	Else {
		Write-Host "AD Group ${apexShareReadOnlyName} DOES NOT exists"
		$canProcessApexShare = $False
	}

	Show-Task "Checking for Apex Share AD Group '${apexShareChangeName}'"

	$apexShareChangeADGroup = Get-ADGroup -Identity "${apexShareChangeName}" -Server "$clientDomain"

	If ($apexShareChangeADGroup) {
		Write-Host "AD Group ${apexShareChangeName} exists"
	}
	Else {
		Write-Host "AD Group ${apexShareChangeName} DOES NOT exists"
		$canProcessApexShare = $False
	}

	If ($canProcessApexShare) {
		Write-Host "Both Apex Share AD Groups exist"

		Show-Task "Checking for Apex Share '${apexShareName}'"

		$apexShare = Get-SmbShare -Name "${apexShareName}" 

		If ($apexShare) {
			Write-Host "Share ${apexShareName} exists, no action to be taken"
		}
	 Else {
			Write-Host "Share ${apexShareName} DOES NOT exists"

			Show-Task "Creating Share '${apexShareName}' on directory '${apexSharePath}'"

			try {
				$Parameters = @{
					Name         = "${apexShareName}"
					Path         = "${apexSharePath}"
					ReadAccess   = "${apexShareReadOnlyName}"
					ChangeAccess = "${apexShareChangeName}"
					Description  = "${apexShareDesc}"
				}
				$apexShare = New-SmbShare @Parameters -ErrorAction Stop

				Write-Host "Share Details: ${apexShare}"
			}
			Catch {
				Invoke-AbortScriptWithMessage "Unable to create Share '${apexShareName}'"
			}

			Show-Task "Setting Share '${apexShareName}' permissions"

			try {
				Invoke-AddDirectoryACLPermission "${apexSharePath}" "${apexShareReadOnlyName}" "Read"
				Invoke-AddDirectoryACLPermission "${apexSharePath}" "${apexShareChangeName}" "Modify"
			}
			Catch {
				Invoke-AbortScriptWithMessage "Unable to set permissions on directory '${apexSharePath}'"
			}
		}

	}
	Else {
		Write-Host "One or more AD Groups do not exist, so cannot create '${apexShareName} share"
	}

	# ---- Drop Share

	$canProcessDropShare = $True

	Show-Task "Checking for Apex Drop Share AD Group '${dropShareReadOnlyName}'"

	$dropShareReadOnlyADGroup = Get-ADGroup -Identity "${dropShareReadOnlyName}" -Server "$clientDomain"

	If ($dropShareReadOnlyADGroup) {
		Write-Host "AD Group ${dropShareReadOnlyName} exists"
	}
	Else {
		Write-Host "AD Group ${dropShareReadOnlyName} DOES NOT exists"
		$canProcessDropShare = $False
	}

	Show-Task "Checking for Apex Drop Share AD Group '${dropShareChangeName}'"

	$dropShareChangeADGroup = Get-ADGroup -Identity "${dropShareChangeName}" -Server "$clientDomain"

	If ($dropShareChangeADGroup) {
		Write-Host "AD Group ${dropShareChangeName} exists"
	}
	Else {
		Write-Host "AD Group ${dropShareChangeName} DOES NOT exists"
		$canProcessDropShare = $False
	}

	If ($canProcessDropShare) {
		Write-Host "Both Drop Apex Share AD Groups exist"

		Show-Task "Checking for Drop Apex Share '${dropShareName}'"

		$dropShare = Get-SmbShare -Name "${dropShareName}"

		If ($dropShare) {
			Write-Host "Share ${dropShareName} exists, no action to be taken"
		}
	 Else {
			Write-Host "Share ${dropShareName} DOES NOT exists"

			Show-Task "Creating Share '${dropShareName}' on directory '${dropSharePath}'"

			try {
				$Parameters = @{
					Name         = "${dropShareName}"
					Path         = "${dropSharePath}"
					ReadAccess   = "${dropShareReadOnlyName}"
					ChangeAccess = "${dropShareChangeName}"
					Description  = "${dropShareDesc}"
				}
				$apexShare = New-SmbShare @Parameters -ErrorAction Stop

				Write-Host "Share Details: ${dropShare}"
			}
			Catch {
				Invoke-AbortScriptWithMessage "Unable to create Share '${dropShareName}'"
			}

			Show-Task "Setting Share '${dropShareName}' permissions"

			try {
				Invoke-AddDirectoryACLPermission "${dropSharePath}" "${dropShareReadOnlyName}" "Read"
				Invoke-AddDirectoryACLPermission "${dropSharePath}" "${dropShareChangeName}" "Modify"
			}
			Catch {
				Invoke-AbortScriptWithMessage "Unable to set permissions on directory '${dropSharePath}'"
			}
		}
	}
	Else {
		Write-Host "One or more AD Groups do not exist, so cannot create '${dropShareName} share"
	}

}
Else{
	Write-Host "Skipping StepB7 - Create Drop Shares and permissions"
}
# End Script (with Transcript)
Invoke-EndScript
