# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 14 Mar 2023 - ST - Initial
# --------------------------------------------------------------------------------
# Performs all the A scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript

Show-Task "Running 'A' scripts"

Invoke-RunScriptBlock -ScriptBlock { & .\"StepA1 - Install Base Softwares.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepA2 - Create Working Folder.ps1" } -CheckForError -ErrorAction Stop

# End Script (with Transcript)
Invoke-EndScript
