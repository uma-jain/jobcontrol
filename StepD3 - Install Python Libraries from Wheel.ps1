# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 28 Feb 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Assumes Job Control directory structure exists.
# Performs installation of Python libraries from Wheel files.
# Will remove any existing libraries first to ensure a clean install.
# Copies the pywintypes*.dll to System32 directory to allow NT services to start.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig

$jcRootPath = "$rootPath\Apex_${environmentName}\Jobs"
$wheelPath = "$jcRootPath\Wheel"

# Uninstall Python libraires
Show-Task "Uninstall Python libraires"

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {
	pip freeze > to_uninstall.txt

	$fileSize = (Get-Item to_uninstall.txt).Length

	If ( $fileSize -gt 0 ) {
		pip uninstall -r to_uninstall.txt -y
	}
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $wheelPath -CheckForError


# Install Python libraires
Show-Task "Install Python libraires"

# Define ScriptBlock as a set of PowerShell commands
$scriptBlock = {
	pip install --no-index --find-links . -r requirements.txt
}

Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $wheelPath -CheckForError

Show-Task "Copying pywintypes*.dll to System32"

$pyPath = "C:\Program Files\Python39\Lib\site-packages\pywin32_system32"
$win32Path = "C:\Windows\System32"

Copy-Item -Path "${pyPath}\pywintypes*.dll" -Destination "$win32Path" -Verbose

# End Script (with Transcript)
Invoke-EndScript
