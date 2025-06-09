# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 14 Mar 2023 - UJ - Initial
# Adobe Reader
# Open Office
# KDiff
# Java JRE latest compatible with Apex Collateral
# Powershell
# 7Zip
# Notepad++
# Microsoft Edge
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$softwarePath = [String]$configValues.softwarePath
$citrixServer = [String]$configValues.citrixServer

$arguments = @( $softwarePath )

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {
	$softwarePath = $($args[0])
	$currentPwd = $pwd

	Write-Host "Software path is ${softwarePath}"
	Write-Host "Checking and Installing Base Softwares"

	$software = "7-Zip*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64) )
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "7Zip" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
				
		}
		catch
		{		
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "PowerShell*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Powershell*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "Notepad++*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Notepad++*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "KDiff*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "KDiff*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "Eclipse Temurin JRE*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'Java' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Java JRE*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the Java installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing Java from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "Adobe Acrobat Reader*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Adobe*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "OpenOffice*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Apache Open Office*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}

	$software = "Microsoft Edge*"
	$installed32 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	$installed64 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like $software }) -ne $null
	If (-Not ($installed32 -or $installed64))
	{
		Write-Host "'$software' is NOT installed."
		try
		{
			$folderPath = Get-ChildItem $softwarePath -ErrorAction Stop -Recurse | Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Microsoft Edge*" } | Select-Object -ExpandProperty fullname
			
			if ($folderPath -eq $null)
   {
				throw "Cannot find the $software installer in $softwarePath"
			}
			else
			{
				Write-Host "Installing $software from $folderPath"
				Set-Location -Path $folderPath
				& "$folderPath\install_local"
			}
		}
		catch
		{
			Write-Host "`nError Message: $_"
			# Set the path back to the original dir
			Set-Location -Path $currentPwd		
			Exit 1
		}
	}
	else
	{
		Write-Host "'$software' is installed."
	}
	# Set the path back to the original dir
	Set-Location -Path $currentPwd

}

Invoke-RunScriptBlockOnRemoteComputerWithArgumentList $citrixServer $scriptBlock $arguments

# End Script (with Transcript)
Invoke-EndScript
