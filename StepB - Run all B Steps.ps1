# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 03 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Performs all the B scripts in order, stopping on first failure.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

Show-Task "Running 'B' scripts"

Try {
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB1 - Process Environment Config.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB2 - Generate Passwords.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB3 - Validate Configuration.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB4 - Create Base Directories.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB5 - Create Apex Directory Structure.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB6 - Set Directory Permissions.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB7 - Create Drop Shares and Permissions.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB8 - Perform Substitution on Config Files.ps1" } -CheckForError -ErrorAction Stop
	Invoke-RunScriptBlock -ScriptBlock { & .\"StepB9 - Set OS Time zone and Language.ps1" } -CheckForError -ErrorAction Stop
}
Catch {
	Invoke-AbortScriptWithMessage "Aborting B Scripts"
}

# End Script (with Transcript)
Invoke-EndScript
