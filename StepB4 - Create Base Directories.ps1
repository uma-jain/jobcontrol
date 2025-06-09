# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - UJ - Initial
# --------------------------------------------------------------------------------
# Create Base Directory
# Creates Backups, Images, Temp, Software, Apex_XXX in rootPath
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$apexRoot = "$rootPath\Apex_$environmentName"

Show-Task "Renaming C: Drive to '${clientName} ${environmentName} APP'"

Label C: ${clientName} ${environmentName} APP

Show-Task "Renaming D: Drive to 'Data'"

Label D: Data


Invoke-CreateDirectory "$rootPath\Backups"
Invoke-CreateDirectory "$rootPath\Images"
Invoke-CreateDirectory "$rootPath\Software"
Invoke-CreateDirectory "$rootPath\Temp"

Invoke-CreateDirectory "$apexRoot\Archive"
Invoke-CreateDirectory "$apexRoot\Daily Archive"
Invoke-CreateDirectory "$apexRoot\Daily Archive\Incoming"
Invoke-CreateDirectory "$apexRoot\Daily Archive\Outgoing"
Invoke-CreateDirectory "$apexRoot\Data"
Invoke-CreateDirectory "$apexRoot\Data\ManagedDocuments"
Invoke-CreateDirectory "$apexRoot\Data\ManagedDocuments\agreements"
Invoke-CreateDirectory "$apexRoot\Data\Reports"
Invoke-CreateDirectory "$apexRoot\Drop"
Invoke-CreateDirectory "$apexRoot\Drop\Incoming"
Invoke-CreateDirectory "$apexRoot\Drop\Outgoing"
Invoke-CreateDirectory "$apexRoot\Drop\Outgoing\ToClient"

# End Script (with Transcript)
Invoke-EndScript
