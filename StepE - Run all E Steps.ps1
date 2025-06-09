# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Performs all the E scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Running 'C' scripts"

Invoke-RunScriptBlock -ScriptBlock { & .\"StepE1 - Copy Auto Install Config.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE2 - Auto Install Apex.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE3 - Update Apex Database.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE4 - Copy PS customisations.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE5 - Create Apex NT Services.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE6 - Start Apex NT Services.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepE7 - Copy Environment Config and Remove Passwords.ps1" } -CheckForError -ErrorAction Stop

# End Script (with Transcript)
Invoke-EndScript
