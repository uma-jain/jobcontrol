# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 04 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Install "Active MQ" software to apex directory.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$apexRootPath = "$rootPath\Apex_${environmentName}"
$mqExtractPath = "$rootPath\Apex_${environmentName}\Active MQ"

Show-Task "Install Active MQ software"

# If directory exists, then do not create
If (!(Test-Path "${mqExtractPath}"))
{
	$softwarePath = "D:\Software"
	Write-Host "Software path is ${softwarePath}"

	try
	{
		$folderPath = Get-ChildItem "$softwarePath" -ErrorAction Stop `
		| Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "Apache Active MQ*" } `
		| Sort-Object -Descending -Property LastWriteTime -Top 1 `
		| Select-Object -expandproperty fullname
		
		if ($null -eq $folderPath)
  {
			throw "Cannot find the Apache Active MQ directory in $softwarePath"
		}
		else
		{
			Write-Host "Installing Apache Active MQ from $folderPath"

			$sourceDir = Get-ChildItem "$folderPath\Images" -ErrorAction Stop `
			| Where-Object { $_.Name -like "apache-activemq*" } `
			| Select-Object -expandproperty fullname

			Write-Host "Apache Source Dir: $sourceDir"

			$destinationDir = $apexRootPath
			# Exclude some directories
			$additionalArgs = "-xr!examples -xr!webapps-demo -xr!docs -xr!win32"
			Invoke-UnzipProcess $sourceDir $destinationDir $additionalArgs

			# Wait to allow all locks to be released (bit9/Beyond Trust)
			Start-Sleep -Milliseconds 10000

			Write-Host "Rename Apache Active MQ"

			$mqFolderPath = Get-ChildItem $apexRootPath -ErrorAction Stop `
			| Where-Object { $_.PSIsContainer -eq $True -and $_.Name -like "apache-activemq*" } `
			| Select-Object -expandproperty fullname

			if ($null -eq $mqFolderPath)
			{
				Invoke-AbortScriptWithMessage "Unable to install Apache Active MQ, could not find installation patch"
			}
			else
			{
				Rename-Item $mqFolderPath $mqExtractPath -ErrorAction Stop
			}
		}
	}
	Catch
	{
		Invoke-AbortScriptWithMessage "Unable to install Apache Active MQ"
	}
}
Else
{
	Write-Host "Active MQ directory already exists, skipping installation"
}

# End Script (with Transcript)
Invoke-EndScript
