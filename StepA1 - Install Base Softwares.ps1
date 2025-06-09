# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 14 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Installing Base Softwares
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript

$softwarePath = "D:\Software"
Write-Host "Software path is ${softwarePath}"
Write-Host "> Checking and Installing Base Softwares" -ForegroundColor Green

$currentPwd = $pwd

$software = "7-Zip*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64) ) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "7Zip" } |Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing 7Zip from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"		
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
		
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "PowerShell*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Powershell*" } |Sort-Object LastWriteTime | select -last 1| Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Powershell from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "Notepad++*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Notepad++*" } |Sort-Object LastWriteTime | select -last 1| Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Notepad++ from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "Python*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Python*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Python from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "KDiff*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "KDiff*" } |Sort-Object LastWriteTime | select -last 1| Select-Object -expandproperty fullname
		Write-Host "Installing KDiff from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}


$software = "Eclipse Temurin JRE*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Java JRE*" } |Sort-Object LastWriteTime | select -last 1| Select-Object -expandproperty fullname
				if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Java from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: " $_
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "Microsoft ODBC Driver*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "SQL Server ODBC and CMD*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "RSAT-AD-Tools";
$installed = Get-WindowsFeature -Name $software | Where-Object Installed

If (-Not $installed) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Feature - AD *" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Feature -AD Group from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}
$software = "GPMC";
$installed = Get-WindowsFeature -Name $software | Where-Object Installed

If (-Not $installed) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Feature - Group Policy*" } |Sort-Object LastWriteTime | select -last 1| Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Feature - Group Policy from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "Adobe Acrobat Reader*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Adobe*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "OpenOffice*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Apache Open Office*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing Apache Open Office from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "SQL Server Management Studio*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "SQL Server Management*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "FileZilla*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "FileZilla*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}


$software = "SetACL Studio*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "SetACL*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

$software = "Microsoft Edge*";
$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
If (-Not ($installed32 -or $installed64)) {
	Write-Host "'$software' is NOT installed.";
	try {
		$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Microsoft Edge*" }|Sort-Object LastWriteTime | select -last 1 | Select-Object -expandproperty fullname
		if ($folderPath -eq $null){
			throw "Cannot find the $software installer in $softwarePath"
		}
		else {
		Write-Host "Installing $software from $folderPath"
		Set-Location -Path $folderPath
		& "$folderPath\install_local"
		}
		
	}
	catch {
		Show-Error "`nError Message: $_"
		# Set the path back to the original dir
		Set-Location -Path $currentPwd
		# End Script (with Transcript)
		Invoke-EndScript
		Exit 1
	}
}
else {
	Write-Host "'$software' is installed."
}

# Set the path back to the original dir
Set-Location -Path $currentPwd

# End Script (with Transcript)
Invoke-EndScript
