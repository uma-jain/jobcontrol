# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Create Apex Directory Structure
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Use Force which will allow this to be reran
Try {	
	
	Copy-Item -Recurse -Verbose "${masterPath}\New Install Template\*" -Destination "$rootPath\Apex_${environmentName}\" -ErrorAction Stop -Force
	
	# Rename D:\Apex_POC1\Apex\server\core\lib_local\mssql-jdbc-9.4.1.jre16.jar.txt to mssql-jdbc-9.4.1.jre16.jar
	$oldName = Get-ChildItem "$rootPath\Apex_${environmentName}\Apex\server\core\lib_local\" -ErrorAction Stop -Recurse | Where-Object { $_.Name -like "mssql-jdbc*" } | Select-Object Name
	$oldName = $oldName.Name
	$newName = $oldName.Replace('.txt','')
	Show-Task "Renaming $oldName to $newName" 
	Rename-Item -Path "$rootPath\Apex_${environmentName}\Apex\server\core\lib_local\$oldName" -NewName $newName
		
	}
Catch {
	Write-Host "`nError Message: $_.Exception.Message"
}



# End Script (with Transcript)
Invoke-EndScript
