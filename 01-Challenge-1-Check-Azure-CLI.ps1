<#
.SYNOPSIS

A script used to check if Azure CLI is installed and provide installation instructions if it is not.

.DESCRIPTION

A script used to check if Azure CLI is installed and provide installation instructions if it is not.
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Store the specified set of tags in a hash table.
Create resource group management, if it not already exists. Add specified tags add specified tags and lock with a CanNotDelete lock.

.NOTES

Filename:       01-Challenge-1-Check-Azure-CLI.ps1
Created:        04/03/2026
Last modified:  04/03/2026
Author:         Wim Matthyssen
Version:        3.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v14.6.0)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

.\01-Challenge-1-Check-Azure-CLI.ps1

.LINK

#>
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"} | Out-Null 
$foregroundColor1 = "Green"
$foregroundColor2 = "Yellow"
$foregroundColor3 = "Red"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script started

Write-Host ($writeEmptyLine + "# Script started. Without errors, it can take up to 2 minutes to complete" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Check if Azure CLI is installed

$azCliPath = Get-Command az -ErrorAction SilentlyContinue

if ($azCliPath) {
    Write-Host ($writeEmptyLine + "# Azure CLI is installed at: $($azCliPath.Source)" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
} else {
    Write-Host ($writeEmptyLine + "# Azure CLI is not installed. Please download and install it from the following link: " + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor3 $writeEmptyLine
    Write-Host ($writeEmptyLine + "# https://azcliprod.blob.core.windows.net/msi/azure-cli-<version>.msi (32-bit) or https://azcliprod.blob.core.windows.net/msi/azure-cli-<version>-x64.msi (64-bit)." + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor3 $writeEmptyLine
}

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


