# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Copy the MASTER Directory to Production APP Server (Remotely)
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

# Run a ScriptBlock on a remote server
$prodAppServer = [String]$configValues.prodAppServer

# Copy the newly install Client to Citrix server (Watch out for D:\\ as it needs to be D:\)
$fromPath = "${rootPath}\MASTER\*"
$remotePath = "${rootPath}\MASTER\"

Invoke-CopyFilesToRemoteComputer $prodAppServer $fromPath $remotePath -Recurse

# Copy the newly install Client to Citrix server (Watch out for D:\\ as it needs to be D:\)
$fromPath = "${rootPath}\Software\*"
$remotePath = "${rootPath}\Software\"

Invoke-CopyFilesToRemoteComputer $prodAppServer $fromPath $remotePath -Recurse

# End Script (with Transcript)
Invoke-EndScript
