# --------------------------------------------------------------------------------
#                                  Installation Script
# --------------------------------------------------------------------------------
# v001 - 24 Feb 2023 - MF - Initial
# v002 - 03 Mar 2023 - MF - Updates
# v003 - 13 Apr 2023 - MF - Updates for MQ automation
# --------------------------------------------------------------------------------
# PowerShell Common Functions
# --------------------------------------------------------------------------------

Write-Host "Importing Common Functions"

$global:logPath = "C:\Apex Install Logs"

# --------------------------------------------------------------------------------

# Set key global variables
$invocation = (Get-Variable MyInvocation).Value
$masterPath = Split-Path $invocation.MyCommand.Path
$global:masterPath = Join-Path -Path "$masterPath" -ChildPath ".."
$global:masterDrive = (Get-Location).Drive.Name

$global:workingPath = "${masterDrive}:\INITIAL SETUP"
$global:databaseWorkingPath = "${workingPath}\Database Scripts"

$global:envConfig = "${workingPath}\env.config"

# --------------------------------------------------------------------------------

function Show-Line {
    param()

    Write-Host "-----------------------------------------"
}

Export-ModuleMember -Function Show-Line

# --------------------------------------------------------------------------------

function Show-DoubleLine {
    param()

    Write-Host "=========================================================="
}

Export-ModuleMember -Function Show-DoubleLine

# --------------------------------------------------------------------------------

function Show-Task {
    param(
        [string] $message
    )

    Write-Host "> $message" -ForegroundColor Green
}

Export-ModuleMember -Function Show-Task

# --------------------------------------------------------------------------------

function Show-Error {
    param(
        [string] $message
    )

    Write-Host "> $message" -ForegroundColor Red
}

Export-ModuleMember -Function Show-Error

# --------------------------------------------------------------------------------

function Show-LineYellow{
    param(
        [string] $message
    )

    Write-Host "> $message" -ForegroundColor Yellow
}

Export-ModuleMember -Function Show-LineYellow



# --------------------------------------------------------------------------------

function Invoke-StartScript {
    param()

    [int]$scriptStartMs = (Get-Date).Millisecond

    # Get calling filename to use on log flename
    $scriptPath = Get-ChildItem -Path $MyInvocation.PSCommandPath
    $scriptFilename = $($scriptPath.Basename)

    # Determine log filename and start Transcript
    $timestamp = Get-Date -Format yyyyMMdd-HHmmss
    $global:logFile = "${logPath}\" + $timestamp + " " + $scriptFilename + ".log"
    Start-Transcript -Path $global:logFile

    Show-Line
    Show-Task "Starting Script"
    Write-Host "Log File: ${logFile}"
    Write-Host
}

Export-ModuleMember -Function Invoke-StartScript

# --------------------------------------------------------------------------------

function Invoke-EndScript {
    param(
    )

    [int]$scriptEndMs = (Get-Date).Millisecond

    Show-Line
    Show-Task "Completed Script in $($scriptEndMs - $scriptStartMs)ms"
    Show-Line

    Stop-Transcript

    Exit 0
}

Export-ModuleMember -Function Invoke-EndScript

# --------------------------------------------------------------------------------

function Invoke-AbortScriptWithMessage {
    param(
        [String] $message
    )

    Show-DoubleLine
    Write-Warning "*** ABORTING SCRIPT ***"

    Show-Error "Error Message: $message" 

    Write-Host "> Stack Trace"
    Write-Output $_.ScriptStackTrace

    Write-Host "> Exception"
    Write-Output $_.Exception

    Show-DoubleLine

    Write-Warning "*** TERMINATING SCRIPT ***"

    Stop-Transcript

    Exit 1
}

Export-ModuleMember -Function Invoke-AbortScriptWithMessage

# --------------------------------------------------------------------------------

function Invoke-ValidateConfigValueNotBlank {
    param(
        [String] $checkValue,
        [String] $checkName
    )

    If (!$checkValue) {
        Invoke-AbortScriptWithMessage "Mandatory Value '$checkName' is missing or blank"
    }
}

Export-ModuleMember -Function Invoke-ValidateConfigValueNotBlank

# --------------------------------------------------------------------------------

function Test-IfAdministrator {
    param()

    Write-Host "Checking permissions for user" $env:UserName

    # Check for Administrator role
    # If NOT, then create a new process
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Show-DoubleLine
        Show-LineYellow "To bun this build script, you need be an Administrator"
        Show-DoubleLine

        Invoke-AbortScriptWithMessage "User is NOT an Administrator"
    }
    Else {
        Write-Host "User is as Administrator"
    }
}

Export-ModuleMember -Function Test-IfAdministrator

# --------------------------------------------------------------------------------

function Invoke-CreateDirectory {
    param(
        [String] $directoryName)

    Show-Task "Creating directory '$directoryName'"

    Try {
        If (!(Test-Path ${directoryName})) {
            New-Item -Path "${directoryName}" -ItemType Directory -ErrorAction Stop | Out-Null
            Write-Host "Successfully created directory"
        }
        Else {
            Write-Host "Directory already exists"
        }
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to create directory"
    }
}

Export-ModuleMember -Function Invoke-CreateDirectory

# --------------------------------------------------------------------------------

function Invoke-CopyFiles {
    param(
        [String] $fromPath,
        [String] $toPath,
        [switch] $recurse
    )

    If ($recurse) {
        Show-Task 'Copying files (Recursive)'
    }
    Else {
        Show-Task 'Copying files'
    }

    Write-Host "From Path: ${fromPath}"
    Write-Host "To Path: ${toPath}"

    Try {
        Copy-Item -Path "$fromPath" -Destination "$toPath" -Recurse:$recurse –PassThru -ErrorAction Stop | ForEach-Object { Write-Host $_.FullName }
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to copy files"
    }
}

Export-ModuleMember -Function Invoke-CopyFiles

# --------------------------------------------------------------------------------

function Invoke-LoadEnvironmentConfig {
    param()

    Show-Task 'Loading env.config'

    # Get variables from config file
    Try {
        $configText = Get-Content "${envConfig}" -ErrorAction Stop | Out-String
        $configText = $configText -replace '\\', '\\'
        $global:configValues = $configText | ConvertFrom-StringData
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to load ${envConfig}"
    }

    $global:clientName = [String]$configValues.clientName
    $global:environmentName = [String]$configValues.environmentName
    $global:rootPath = [String]$configValues.rootPath

    Show-Line
    Write-Host "Current User   - $env:UserName"
    Write-Host "Current Server - $env:ComputerName"
    Write-Host "Client         - ${clientName}"
    Write-Host "Environment    - ${environmentName}"
    Write-Host "SFTC Root      - ${rootPath}"
    Show-Line

    # Validate mandatory values
    Show-Task 'Validating env.config'

    Invoke-ValidateConfigValueNotBlank $clientName "clientName"
    Invoke-ValidateConfigValueNotBlank $environmentName "environmentName"
    Invoke-ValidateConfigValueNotBlank $rootPath "rootPath"

    Invoke-ValidateConfigValueNotBlank [String]$configValues.localeCountry "localeCountry"
    Invoke-ValidateConfigValueNotBlank [String]$configValues.localeLanguage "localeLanguage"

    Invoke-ValidateConfigValueNotBlank [String]$configValues.databaseServer "databaseServer"
    Invoke-ValidateConfigValueNotBlank [String]$configValues.applicationServer "applicationServer"
}

Export-ModuleMember -Function Invoke-LoadEnvironmentConfig

# --------------------------------------------------------------------------------

function Invoke-CreateDatabaseScriptWorkingArea {
    param()

    Show-Task "Creating Database Scripts Directory - ${databaseWorkingPath}"

    Try {
        If (!(Test-Path ${databaseWorkingPath})) {
            New-Item -Path ${databaseWorkingPath} -ItemType Directory -ErrorAction Stop | Out-Null
            Write-Host "Successfully Created '${databaseWorkingPath}'"
        }
        Else {
            Write-Host "'${databaseWorkingPath}' directory already exists"
        }
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to create Working Directory '${databaseWorkingPath}'"
    }
}

Export-ModuleMember -Function Invoke-CreateDatabaseScriptWorkingArea

# --------------------------------------------------------------------------------

function Invoke-AllSubstitutionStringsInString {
    param(
        [String] $textString)

    Show-Task "Replacing environment substitution in string"

    # Loop though all config variables performing a replace on substitutions "[[ ]]"
    Foreach ($hash in $configValues.GetEnumerator()) {

        $itemName = $($hash.Name)
        $itemValue = $($hash.Value)

        # Handle case conversion first
        $textString = $textString.Replace("[[${itemName}-ToLowerCase]]", ${itemValue}.ToLower(), 'OrdinalIgnoreCase')
        $textString = $textString.Replace("[[${itemName}-ToUpperCase]]", ${itemValue}.ToUpper(), 'OrdinalIgnoreCase')
        $textString = $textString.Replace("[[${itemName}]]", ${itemValue}, 'OrdinalIgnoreCase')
    }

    # Return updated value
    return $textString
}

Export-ModuleMember -Function Invoke-AllSubstitutionStringsInString

# --------------------------------------------------------------------------------

function Invoke-AllSubstitutionStringsInFile {
    param(
        [string] $FullPathToFile)

    Show-Task "Performing substitutions in file '$FullPathToFile'"

    # Read file
    $content = [System.IO.File]::ReadAllText("$FullPathToFile")

    # Loop though all config variables performing a replace on substitutions "[[ ]]"
    Foreach ($hash in $configValues.GetEnumerator()) {

        $itemName = $($hash.Name)
        $itemValue = $($hash.Value)

        # Handle case conversion first
        $content = $content.Replace("[[${itemName}-ToLowerCase]]", ${itemValue}.ToLower(), 'OrdinalIgnoreCase')
        $content = $content.Replace("[[${itemName}-ToUpperCase]]", ${itemValue}.ToUpper(), 'OrdinalIgnoreCase')
        $content = $content.Replace("[[${itemName}]]", ${itemValue}, 'OrdinalIgnoreCase')
    }

    # Write updated content back to same file
    [System.IO.File]::WriteAllText("$FullPathToFile", $content)
}

Export-ModuleMember -Function Invoke-AllSubstitutionStringsInFile

# --------------------------------------------------------------------------------

function Invoke-AllSubstitutionStringsInMultipleFiles {
    param(
        [string] $FullPathToFiles,
        [switch] $recurse
    )

    Show-Task "Performing substitutions in directory '$FullPathToFiles'"

    # Only get files (-File)
    $fileList = Get-ChildItem -Path "${FullPathToFiles}" -File -Recurse:$recurse

    foreach ($thisFile in $fileList) {
        Invoke-AllSubstitutionStringsInFile "$thisFile"
    }
}

Export-ModuleMember -Function Invoke-AllSubstitutionStringsInMultipleFiles

# --------------------------------------------------------------------------------

function Invoke-ReplacePropertyValueInConfig {
    param(
        [String] $property,
        [String] $newValue,
        [String] $filename = $envConfig
    )

    Show-Task "Replacing property '$property' in '$filename' with new value"

    # New content to be generated line by line
    $newContent = ""

    # Read file and process line by line
    ForEach ($line in [System.IO.File]::ReadLines($filename)) {
        $newLine = $line
        If ($line) {
            If ( ($line.Length -gt 1) -And ($line.IndexOf('=') -gt 0) ) {
                $propCheck = $line.SubString(0, $line.IndexOf('=')).Trim()

                If ( $propCheck -ieq $property ) {
                    # Replace line with new value
                    Write-Host "Updating '$propCheck'"
                    $newLine = "$property = $newValue"
                }
            }
        }

        $newContent = $newContent + $newLine + "`n"
    }

    # Write updated content back to same file
    [System.IO.File]::WriteAllText($filename, $newContent)
}

Export-ModuleMember -Function Invoke-ReplacePropertyValueInConfig

# --------------------------------------------------------------------------------

function Invoke-ReplaceWholeLineInConfig {
    param(
        [String] $checkValue,
        [String] $newValue,
        [String] $filename = $envConfig
    )

    Show-Task "Replacing line containing '$checkValue' in '$filename' with whole new line"

    # New content to be generated line by line
    $newContent = ""

    # Read file and process line by line
    ForEach ($line in [System.IO.File]::ReadLines($filename)) {
        $newLine = $line
        If ($line) {
            If ( ($line.Length -gt 1) ) {
                If ( $line.Contains($checkValue) ) {
                    # Replace line with new value
                    Write-Host "Updating line"
                    $newLine = "$newValue"
                }
            }
        }

        $newContent = $newContent + $newLine + "`n"
    }

    # Write updated content back to same file
    [System.IO.File]::WriteAllText($filename, $newContent)
}

Export-ModuleMember -Function Invoke-ReplaceWholeLineInConfig

# --------------------------------------------------------------------------------

function Invoke-GenerateRandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length
    )

    Show-Task 'Generating Random Password'

    $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~+=@:()_!#'.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)

    $rng.GetBytes($bytes)

    $result = New-Object char[]($length)

    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
    }

    return (-join $result)
}

Export-ModuleMember -Function Invoke-GenerateRandomPassword

# --------------------------------------------------------------------------------

function Invoke-RunSQLServerScriptFromQuery {
    param(
        [String] $dbServer,
        [String] $dbPort,
        [String] $dbName,
        [String] $dbUser,
        [String] $dbPassword,
        [String] $sqlQuery
    )

    Show-Task 'Running SQL Query on Database'
    Write-Host "Database Server: $dbServer"
    Write-Host "Database Port: ${dbPort}"
    Write-Host "Database Name: ${dbName}"

    If ($dbUser) {
        Write-Host "Database User: ${dbUser}"
    }
    Else {
        Write-Host "Database User: $env:UserName (User running script)"
    }

    # -b - Allows reporting of error to DOS ERRORLEVEL
    # -U <user> - The user (if omitted defaults to current user)	# -P <password> - The users password
    # -S <server name> - Identifies the instance of Microsoft SQL Server to which sqlcmd connects
    # 	e.g -S \\emeaoxfsv23\apex710
    # -h-1 - Removed the header rows from SELECT statements
    # -W - Removed trailing spaces from columns
    # -Q - Runs a local query and exists
    # -i - Runs SQL from a file

    # If dbUser is supplied, then use this, otherwise use user running the script
    If ($dbUser) {
        $stdout = Invoke-Command -ScriptBlock {
            sqlcmd -S "$dbServer\$dbName,$dbPort" -U $dbUser -P $dbPassword -b -Q "$sqlQuery"
        } -ArgumentList "$dbServer", "$dbName", "$dbPort", "$dbUser", "$dbPassword", "$sqlQuery"
    }
    Else {
        $stdout = Invoke-Command -ScriptBlock {
            sqlcmd -S "$dbServer\$dbName,$dbPort" -b -Q "$sqlQuery"
        } -ArgumentList "$dbServer", "$dbName", "$dbPort", "$sqlQuery"
    }

    Write-Host "Exit Code: ${LASTEXITCODE}"

    # Output stdout
    Write-Host "Output:"
    $stdout

    If ( $LASTEXITCODE -ne 0 ) {
        Invoke-AbortScriptWithMessage "Unable to run SQL Server Script from Query"
    }
}

Export-ModuleMember -Function Invoke-RunSQLServerScriptFromQuery

# --------------------------------------------------------------------------------

function Invoke-RunSQLServerScriptFromFile {
    param(
        [String] $dbServer,
        [String] $dbPort,
        [String] $dbName,
        [String] $dbUser,
        [String] $dbPassword,
        [String] $sqlFile
    )

    Show-Task 'Running SQL File on Database'
    Write-Host "Database Server: $dbServer"
    Write-Host "Database Port: ${dbPort}"
    Write-Host "Database Name: ${dbName}"

    If ($dbUser) {
        Write-Host "Database User: ${dbUser}"
    }
    Else {
        Write-Host "Database User: $env:UserName (User running script)"
    }

    Write-Host "SQL File: ${sqlFile}"

    # -b - Allows reporting of error to DOS ERRORLEVEL
    # -U <user> - The user (if omitted defaults to current user)
    # -P <password> - The users password
    # -S <server name> - Identifies the instance of Microsoft SQL Server to which sqlcmd connects
    # 	e.g -S \\emeaoxfsv23\apex710
    # -h-1 - Removed the header rows from SELECT statements
    # -W - Removed trailing spaces from columns
    # -Q - Runs a local query and exists
    # -i - Runs SQL from a file

    # If dbUser is supplied, then use this, otherwise use user running the script
    If ($dbUser) {
        $stdout = Invoke-Command -ScriptBlock {
            sqlcmd -S "$dbServer\$dbName,$dbPort" -U $dbUser -P $dbPassword -b -i "$sqlFile"
        } -ArgumentList "$dbServer", "$dbName", "$dbPort", "$dbUser", "$dbPassword", "$sqlFile"
    }
    Else {
        $stdout = Invoke-Command -ScriptBlock {
            sqlcmd -S "$dbServer\$dbName,$dbPort" -b -i "$sqlFile"
        } -ArgumentList "$dbServer", "$dbName", "$dbPort", "$sqlFile"
    }

    Write-Host "Exit Code: ${LASTEXITCODE}"

    # Output stdout
    Write-Host "Output:"
    $stdout

    If ( $LASTEXITCODE -ne 0 ) {
        Invoke-AbortScriptWithMessage "Unable to run SQL Server Script from File"
    }
}

Export-ModuleMember -Function Invoke-RunSQLServerScriptFromFile

# --------------------------------------------------------------------------------

function Invoke-RunScriptBlock {
    param(
        [ScriptBlock] $scriptBlock,
        [String] $workingDirectory,
        [Switch] $checkForError
    )

    Show-Task 'Running ScriptBlock'

    Try {
        # Temporarily change to the correct folder
        Push-Location $workingDirectory

        Write-Host "Working Directory: ${workingDirectory}"

        $stdout = Invoke-Command -ScriptBlock $scriptBlock -ErrorAction Stop

        Write-Host "Exit Code: ${LASTEXITCODE}"

        # Pop back to previous directory
        Pop-Location

        # Output stdout
        Write-Host "Output:"
        $stdout

        If ($checkForError) {
            If ( $LASTEXITCODE -ne 0 ) {
                Invoke-AbortScriptWithMessage "Error reporting while running ScriptBlock"
            }
        }
    }
    Catch {
        # Pop back to previous directory
        Pop-Location

        Invoke-AbortScriptWithMessage "Unable to run ScriptBlock"
    }
}

Export-ModuleMember -Function Invoke-RunScriptBlock


# --------------------------------------------------------------------------------

function Invoke-RunScriptBlockOnRemoteComputer {
    param(
        [String] $serverName,
        [ScriptBlock] $scriptBlock
    )

    Show-Task 'Running ScriptBlock on remote server'
    Write-Host "Remote Computer: ${serverName}"

    Try {
        $Job = Invoke-Command -ComputerName $serverName -ScriptBlock $scriptBlock -ErrorAction Stop -AsJob

        # Wait for job to complete
        Wait-Job -Job $Job

        # Get array of job for each line in the Script Block
        $jobResult = Receive-Job -Job $Job -ErrorAction Stop

        Write-Host "Output (for each command):"
        $jobResult | Format-List -Property *
		Exit-PSSession
		
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to run ScriptBlock"
		Exit-PSSession
    }
}

Export-ModuleMember -Function Invoke-RunScriptBlockOnRemoteComputer

# --------------------------------------------------------------------------------

function Invoke-RunScriptBlockOnRemoteComputerWithArgumentList {
    param(
        [String] $serverName,
        [ScriptBlock] $scriptBlock,
        [string[]] $arguments
    )

    Show-Task 'Running ScriptBlock on remote server'
    Write-Host "Remote Computer: ${serverName}"

    Try {
        $Job = Invoke-Command -ComputerName $serverName -ScriptBlock $scriptBlock -ArgumentList $arguments -ErrorAction Stop -AsJob

        # Wait for job to complete
        Wait-Job -Job $Job

        # Get array of job for each line in the Script Block
        $jobResult = Receive-Job -Job $Job -ErrorAction Stop

        Write-Host "Output (for each command):"
        $jobResult | Format-List -Property *
		
		Exit-PSSession
        

    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to run ScriptBlock with Argument List"
		Exit-PSSession
    }
}

Export-ModuleMember -Function Invoke-RunScriptBlockOnRemoteComputerWithArgumentList

# --------------------------------------------------------------------------------

function Invoke-RunScriptBlockOnRemoteComputerWithArgumentListAndFunction {
    param(
        [String] $serverName,
        [ScriptBlock] $scriptBlock,
        [string[]] $arguments,
        $FunctionToCall
    )

    Show-Task 'Running ScriptBlock on remote server'
    Write-Host "Remote Computer: ${serverName}"

    Try {
        $Job = Invoke-Command -ComputerName $serverName -ScriptBlock $scriptBlock -ArgumentList $arguments ${function:$FunctionToCall} -ErrorAction Stop -AsJob

        # Wait for job to complete
        Wait-Job -Job $Job

        # Get array of job for each line in the Script Block
        $jobResult = Receive-Job -Job $Job -ErrorAction Stop

        Write-Host "Output (for each command):"
        $jobResult | Format-List -Property *
		Exit-PSSession
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to run ScriptBlock"
		Exit-PSSession
    }
}

Export-ModuleMember -Function Invoke-RunScriptBlockOnRemoteComputerWithArgumentListAndFunction

# --------------------------------------------------------------------------------


function Invoke-CopyFilesToRemoteComputer {
    param(
        [String] $serverName,
        [String] $fromPath,
        [String] $remotePath,
        [switch] $recurse
    )

    Show-Task 'Copying file to remote server (with -force)'
    Write-Host "Remote Computer: ${serverName}"
    Write-Host "From Path: ${fromPath}"
    Write-Host "Remote Path: ${remotePath}"

    Try {
        	$session = New-PSSession -ComputerName $serverName

			Copy-Item -ToSession $session -Path $fromPath -Destination $remotePath -Verbose -Recurse:$recurse  | ForEach-Object { Write-Host $_.FullName }		
			Exit-PSSession
	}
    Catch {
        Invoke-AbortScriptWithMessage "Unable to copy file to remote computer"
		 Exit-PSSession
    }
}

Export-ModuleMember -Function Invoke-CopyFilesToRemoteComputer

# --------------------------------------------------------------------------------

function Invoke-GetNTServicePermissions {
    param(
        [String] $serviceName
    )

    $softwarePath = [String]$configValues.softwarePath
    $aclPath = "${softwarePath}\SetACL\64 bit"

    $scriptBlock = {
        .\SetACL.exe -on $serviceName -ot srv -actn list
    }

    Show-Task "Getting permissions on service $serviceName"

    Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $aclPath -CheckForError
}

Export-ModuleMember -Function Invoke-GetNTServicePermissions

# --------------------------------------------------------------------------------

function Invoke-SetNTServicePermissions {
    param(
        [String] $serviceName,
        [String] $groupName,
        [String] $permissionsLevel
    )

    $softwarePath = [String]$configValues.softwarePath
    $aclPath = "${softwarePath}\SetACL\64 bit"

    $scriptBlock = {
        .\SetACL.exe -on $serviceName -ot srv -actn ace -ace "n:${groupName};p:${permissionsLevel}"
    }

    Show-Task "Setting permissions on service $serviceName"
    Write-Host "AD Group: ${groupName}"
    Write-Host "Level: ${permissionsLevel}"

    Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $aclPath -CheckForError
}

Export-ModuleMember -Function Invoke-SetNTServicePermissions

# --------------------------------------------------------------------------------

function Invoke-StartNTService {
    param(
        [String] $serviceName
    )

    Show-Task "Setting NT Service '$serviceName' to Automatic"

    Try {
        Set-Service -Name $serviceName -StartupType Automatic -ErrorAction Stop -Verbose
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to set NT Service '$serviceName' to automatic"
    }

    Show-Task "Starting NT Service '$serviceName'"

    Try {
        Start-Service -Name $serviceName -Verbose -ErrorAction Stop
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to start NT Service '$serviceName'"
    }

    Show-Task "Sleep 3 seconds to allow service to start"

    Start-Sleep -Seconds 3

    Show-Task "Checking if NT Service '$serviceName' is running"

    # Check to see if running
    $service = Get-Service $serviceName

    If ($service.Status -eq 'Running') {
        Write-Host "'$serviceName' Service is Running"
    }
    Else {
        Invoke-AbortScriptWithMessage "'$serviceName' Service NOT is Running, check logs"
    }
}

Export-ModuleMember -Function Invoke-StartNTService

# --------------------------------------------------------------------------------

function Invoke-AddDirectoryACLPermission {
    param(
        [String] $aclPath,
        [String] $aclGroupName,
        [String] $aclLevel
    )

    Try {
        Show-Task "Add '$aclLevel' '$aclGroupName' ACL permissions to '$aclPath'"

        # Create new ACL rule
        $rule = [System.Security.AccessControl.FileSystemAccessRule]::new("${aclGroupName}", "${aclLevel}", "ContainerInherit,ObjectInherit", "None", "Allow")

        # Get ACL object for the path
        $acl = Get-Acl -Path $aclPath

        # Add new ACL rule and apply back to path
        $acl.AddAccessRule($rule)
        $acl | Set-Acl $aclPath

        # Get ACL object for the path again and write to console
        $acl = Get-Acl -Path $aclPath
        $acl_post = $acl | Format-List | Out-String

        Write-Host "Permissions post AccessRule addition: $acl_post"
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to create ACL Rule on '$aclPath'"
    }
}

Export-ModuleMember -Function Invoke-AddDirectoryACLPermission

# --------------------------------------------------------------------------------

function Invoke-EnableDirectoryACLInheritance {
    param(
        [String] $aclPath
    )

    Try {
        Show-Task "Enable ACL Inheritance on '$aclPath'"

        # Get ACL object for the path
        $acl = Get-Acl -Path $aclPath

        # Enable Inheritance
        # Parameters
        # isProtected - False to allow inheritance
        # preserveInheritance - ignored when isProtected is False
        $acl.SetAccessRuleProtection($False, $False)
        $acl | Set-Acl $aclPath

        # Get ACL object for the path again and write to console
        $acl = Get-Acl -Path $aclPath
        $acl_post = $acl | Format-List | Out-String

        Write-Host "Permissions post enabling of Inheritance: $acl_post"
    }
    Catch {
        Invoke-AbortScriptWithMessage "Unable to enable Inheritance on '$aclPath'"
    }
}

Export-ModuleMember -Function Invoke-EnableDirectoryACLInheritance

# --------------------------------------------------------------------------------

function Invoke-ValidateServerWithPing {
    param(
        [String] $type,
        [String] $computerName
    )

    Try {
        Show-Task "Testing if '$type' server exists with ping - Server = $computerName"
        Test-Connection -ComputerName $computerName -Count 1 -ErrorAction Stop | Out-Null
        Write-Host "Ping passed"
    }
    Catch {
        Invoke-AbortScriptWithMessage "The server $(($computerName).ToUpper()) had a connection issue with ping"
    }
}

Export-ModuleMember -Function Invoke-ValidateServerWithPing

# --------------------------------------------------------------------------------


function Invoke-ValidateServerWithRemoteConnection {
    param(
        [String] $type,
        [String] $computerName
    )

    Try {
        Show-Task "Testing if '$type' server exists by running remote execution - Server = $computerName"
        Invoke-Command -ComputerName $computerName -ScriptBlock { Get-Date } -ErrorAction Stop
        Write-Host "remote execution passed"
    }
    Catch {
        Invoke-AbortScriptWithMessage "The server $(($computerName).ToUpper()) had a connection issue with remote connection"
    }
}

Export-ModuleMember -Function Invoke-ValidateServerWithRemoteConnection

# --------------------------------------------------------------------------------
function Invoke-ValidateEnvParameter {
    param(
        [String] $parameter,
        [String] $parameterValue
    )
    #Declare all the accepted Values
    $timeZoneList = Get-TimeZone -ListAvailable | Select-Object StandardName
    $localeList = [system.globalization.cultureinfo]::GetCultures("AllCultures") | Select-Object Name

    $allowedValuesInEnvConfig = @{
        'environmentType'      = @('Prod', 'NonProd')
        'standardLocal'        = $localeList.Name
        'timezoneStandardName' = $timeZonelist.StandardName
    }
    Try {
        $acceptedValues = $allowedValuesInEnvConfig[$parameter]
        if ($parameterValue -in $acceptedValues)
        { Write-Host "$parameter : $parameterValue is accepted" }
        else {
            Write-Host "$parameter : $parameterValue is not accepted"
            throw
        }
    }
    Catch {
        Invoke-AbortScriptWithMessage "environment.config settings are incorrect"
    }
}

Export-ModuleMember -Function Invoke-ValidateEnvParameter

# --------------------------------------------------------------------------------

function Invoke-UnzipProcess {
    param(
        [string] $ZipImage,
        [string] $destinationDir,
        [string] $additionalArgs
    )

    Write-Host "Unzipping directory..."

    $sourceZipImage = Resolve-Path $ZipImage
    $zipDir = "$env:programfiles\7-Zip\7z.exe"

    Write-Host "Zip Directory:" $zipDir
    Write-Host "Zip Source:" $sourceZipImage
    Write-Host "Destination Directory:" $destinationDir

    $process = Start-Process -FilePath ${zipDir} -ArgumentList "x `"$sourceZipImage`"", "-o`"${destinationDir}`"", "-y", $additionalArgs -NoNewWindow -PassThru -Wait

    Write-Host "Exit Code: " $process.ExitCode

    Write-Host "Unzip Complete"
}

Export-ModuleMember -Function Invoke-UnzipProcess


# --------------------------------------------------------------------------------

function Invoke-ActiveMQEncyptPassword {
    param(
        [string] $apexEncryptionPassword,
        [string] $passwordToEncrypt
    )

    Show-Task "Encrypting MQ password"

    $mqRootPath = "$rootPath\Apex_${environmentName}\Active MQ"
    $mqBinPath = "$mqRootPath\bin"

    $scriptBlock = {
        .\activemq encrypt --password $apexEncryptionPassword --input $passwordToEncrypt
    }

    $stdout = Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqBinPath -CheckForError

    $pwdFromText = $stdout | Select-String -Pattern 'Encrypted text:' -CaseSensitive -SimpleMatch
    $pwdFromText = $pwdFromText -replace ('Encrypted text: ', '')
    $pwdFromText = "ENC(" + $pwdFromText + ")"

    Write-Host "Password Encrypted"

    return $pwdFromText
}

Export-ModuleMember -Function Invoke-ActiveMQEncyptPassword

# --------------------------------------------------------------------------------

function Invoke-JettyEncyptPassword {
    param(
        [string] $userName,
        [string] $passwordToEncrypt
    )

    Show-Task "Encrypting Jetty password"

    $mqRootPath = "$rootPath\Apex_${environmentName}\Active MQ"

    $scriptBlock = {
        java -cp lib/web/* org.eclipse.jetty.util.security.Password $userName $passwordToEncrypt 2>&1
    }

    $stdout = Invoke-RunScriptBlock -ScriptBlock $scriptBlock -WorkingDirectory $mqRootPath -CheckForError

    $pwdFromText = $stdout | Select-String -Pattern 'MD5:' -CaseSensitive -SimpleMatch

    Write-Host "Password Encrypted"

    return $pwdFromText
}

Export-ModuleMember -Function Invoke-JettyEncyptPassword

# --------------------------------------------------------------------------------
