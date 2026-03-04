<#
.SYNOPSIS

A script used to generate an RSA key in Azure Key Vault.

.DESCRIPTION

A script used to generate an RSA key in Azure Key Vault.
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Create an RSA key in the Key Vault.

.NOTES

Filename:       10-Challenge-2-Generate-RSA-key-in-Key-Vault.ps1
Created:        04/03/2026
Last modified:  04/03/2026
Author:         Wim Matthyssen
Version:        2.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v14.6.0)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

Connect-AzAccount
.\10-Challenge-2-Generate-RSA-key-in-Key-Vault.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# Key vault name - change to the name of your key vault
$keyVaultName = "kv-c2-5ee85fa5"

Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"} | Out-Null 
$foregroundColor1 = "Green"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Remove the breaking change warning messages

Set-Item -Path Env:\SuppressAzurePowerShellBreakingChangeWarnings -Value $true | Out-Null
Update-AzConfig -DisplayBreakingChangeWarning $false | Out-Null
$warningPreference = "SilentlyContinue"

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script started

Write-Host ($writeEmptyLine + "# Script started. Without errors, it can take up to 2 minutes to complete" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Change the current context to use the platform subscription

$subPlatformName = Get-AzSubscription | Where-Object {$_.Name -like "*platform*"}

Set-AzContext -SubscriptionId $subPlatformName.SubscriptionId | Out-Null 

Write-Host ($writeEmptyLine + "# Platform subscription in current tenant selected" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create an RSA key in the Key Vault

Add-AzKeyVaultKey `
  -VaultName $keyVaultName `
  -Name "cmk-storage-rsa-4096" `
  -Destination Software `
  -KeyType RSA `
  -Size 4096

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
