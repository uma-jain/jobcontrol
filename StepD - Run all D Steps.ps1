# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Performs all the D scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Running 'C' scripts"

#StepD1 ErrorAction stop not required
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD1 - Copy Job Control Files.ps1" }
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD2 - Substitute Job Control Config.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD3 - Install Python Libraries from Wheel.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD4 - Perform Job Control Tests.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD5 - Create Job Control NT Services.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD6 - Start Job Control NT Services.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepD7 - Encrypt Passwords.ps1" } -CheckForError -ErrorAction Stop

# End Script (with Transcript)
Invoke-EndScript
