# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 07 Mar 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control and Python is installed and working.
# Calls job 991 to encrypt all passwords in the apex_xxx.config
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$jcBinPath = "$jcRootPath\bin"

Show-Task "Encrypt passwords in apex_${environmentName}.config"

$scriptBlock = {
	python .\main.py ..\config\maintenance\991_encrypt_all_passwords.config
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $jcBinPath -CheckForError

#Restart job control service
$jcServiceName = "ApexJobControlService${environmentName}"
Show-Task "Restart job control service - $jcServiceName "
Get-Service -Name $jcServiceName  | Restart-Service

# End Script (with Transcript)
Invoke-EndScript
