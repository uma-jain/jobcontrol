# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Create Job Control Directory structure and copy over base set of files.
# A structure already exists, then it will be overritten as this script is only
# designed for the initial setup, not patching or upgrades.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$newEnvConfig = "$jcRootPath\config\apex_${environmentName}.config"

# Create Job Control directory structure and copy over files (in bulk)
Show-Task "Creating Job Control directory structure"

Invoke-CreateDirectory "$jcRootPath"
Invoke-CreateDirectory "$jcRootPath\bin"
Invoke-CreateDirectory "$jcRootPath\config"
Invoke-CreateDirectory "$jcRootPath\log"
Invoke-CreateDirectory "$jcRootPath\stats"
Invoke-CreateDirectory "$jcRootPath\Wheel"
Invoke-CreateDirectory "$jcRootPath\database"
Invoke-CreateDirectory "$jcRootPath\scripts"

Show-Task "Copying Job Control directory files"

Invoke-CopyFiles "${masterPath}\..\Jobs\bin\*" "$jcRootPath\bin" -Recurse
Invoke-CopyFiles "${masterPath}\..\Jobs\config\*" "$jcRootPath\config" -Recurse
Invoke-CopyFiles "${masterPath}\..\Jobs\Wheel\*" "$jcRootPath\Wheel" -Recurse
Invoke-CopyFiles "${masterPath}\..\Jobs\database\*" "$jcRootPath\database" -Recurse
Invoke-CopyFiles "${masterPath}\..\Jobs\scripts\*" "$jcRootPath\scripts" -Recurse

# Rename the "apex_TEMPLATE.config" for this environment
Show-Task "Rename the apex_TEMPLATE.config for this environment"

If (Test-Path $newEnvConfig) {
	Remove-Item $newEnvConfig -Verbose
}

Rename-Item -Path "$jcRootPath\config\apex_TEMPLATE.config" -NewName "$newEnvConfig" -Verbose

# End Script (with Transcript)
Invoke-EndScript
