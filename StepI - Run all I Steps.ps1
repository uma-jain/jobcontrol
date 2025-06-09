# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 13 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Performs all the I scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Running 'I' scripts"

Invoke-RunScriptBlock -ScriptBlock { & .\"StepI1 - MQ Install MQ Software.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI2 - MQ Generate Passwords.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI3 - MQ Copy Config Files.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI4 - MQ Create Keys.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI5 - MQ Create NT Service.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI6 - MQ Encrypt Passwords.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI7 - MQ Start NT Service.ps1" } -CheckForError -ErrorAction Stop
Invoke-RunScriptBlock -ScriptBlock { & .\"StepI8 - MQ Validate.ps1" } -CheckForError -ErrorAction Stop

# End Script (with Transcript)
Invoke-EndScript
