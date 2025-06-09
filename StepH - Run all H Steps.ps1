# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Performs all the C scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Running 'C' scripts"

Invoke-RunScriptBlock -ScriptBlock { & .\"StepH1 - DB Set OS Time Zone.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepH2 - Create Backup directory.ps1" } -CheckForError -ErrorAction Stop

# End Script (with Transcript)
Invoke-EndScript
