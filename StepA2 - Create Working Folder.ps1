# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 27 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Create the "INITIAL SETUP" directory and copy over env.config.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript

# Create working directory
Show-Task "Creating Working Directory - ${workingPath}"

If (!(test-path ${workingPath})) {
	New-Item -Path ${workingPath} -ItemType Directory -ErrorAction Stop | Out-Null
	Write-Host "Successfully Created '${workingPath}'" 	
}
Else {
	Write-Host "'${workingPath}' directory already exists"
}

Show-Task "Copying env_template to Working Directory"

$envPathSource = "${masterPath}\env_template.config"
$envPathDestination= "${workingPath}\env.config"

If (!(test-path ${envPathDestination})) {
	Copy-Item $envPathSource  $envPathDestination -Verbose
	Write-Host "Successfully Copied '${envPathDestination}'" 	
}
Else {
	Write-Host "'${envPathDestination}'  already exists"
}


# End Script (with Transcript)
Invoke-EndScript