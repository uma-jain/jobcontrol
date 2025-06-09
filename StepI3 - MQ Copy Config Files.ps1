# --------------------------------------------------------------------------------
#                             Automated Installation Script
# --------------------------------------------------------------------------------
# v001 - 04 Apr 2023 - MF - Initial
# --------------------------------------------------------------------------------
# Copy the MQ config files from template "Active MQ" directory and perform substitutions.
# --------------------------------------------------------------------------------

# Import Common Library
$scriptLibrary = (Split-Path -Path $MyInvocation.MyCommand.Definition) + "\Common Functions.psm1"
Write-Host "Importing Common Functions:" $scriptLibrary
Import-Module $scriptLibrary -Force

# Start Script (with Transcript)
Invoke-StartScript
Invoke-LoadEnvironmentConfig


$mqRootPath = "$rootPath\Apex_${environmentName}\Active MQ"
$mqTemplatePath = "${masterPath}\Active MQ Template"


Show-Task "Copy Active MQ configs"

Invoke-CopyFiles "${mqTemplatePath}\activemq.xml" "$mqRootPath\conf"
Invoke-CopyFiles "${mqTemplatePath}\credentials.properties" "$mqRootPath\conf"
Invoke-CopyFiles "${mqTemplatePath}\credentials-enc.properties" "$mqRootPath\conf"
Invoke-CopyFiles "${mqTemplatePath}\jetty-realm.properties" "$mqRootPath\conf"
Invoke-CopyFiles "${mqTemplatePath}\jetty.xml" "$mqRootPath\conf"

Invoke-CopyFiles "${mqTemplatePath}\wrapper.conf" "$mqRootPath\bin\win64"

# This is a fix to enable encrypted passwords in Jetty
Invoke-CopyFiles "${mqTemplatePath}\webconsole-embedded.xml" "$mqRootPath\webapps\admin\WEB-INF"

# This is a fix to disable the Web Rest API for Jetty as we dont need it
Invoke-CopyFiles "${mqTemplatePath}\web.xml" "$mqRootPath\webapps\api\WEB-INF"


Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\conf\activemq.xml"
Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\conf\credentials.properties"
Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\conf\credentials-enc.properties"
Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\conf\jetty-realm.properties"
Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\conf\jetty.xml"

Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\bin\win64\wrapper.conf"

Invoke-AllSubstitutionStringsInMultipleFiles "$mqRootPath\webapps\admin\WEB-INF\webconsole-embedded.xml"


# End Script (with Transcript)
Invoke-EndScript
