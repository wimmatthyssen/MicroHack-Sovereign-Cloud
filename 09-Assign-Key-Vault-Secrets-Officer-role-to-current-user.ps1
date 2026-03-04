<#
.SYNOPSIS

A script used to assign Key Vault Secrets Officer role to current user.

.DESCRIPTION

A script used to assign Key Vault Secrets Officer role to the current user in Azure Key Vault.
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Get the current user object ID.
Get the Key Vault resource ID.
Assign the Key Vault Secrets Officer role to the current user.

.NOTES

Filename:       09-Assign-Key-Vault-Secrets-Officer-role-to-current-user.ps1
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
.\09-Assign-Key-Vault-Secrets-Officer-role-to-current-user.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# LabUser-03 - change the with the inventory numbering for your lab user
$inventoryNumbering = 3

# Key vault name - change to the name of your key vault
$keyVaultName = "kv-c2-5ee85fa5"

$labUser = "LabUser"
$rgLabUser03Name = $labUser + "-" + $inventoryNumbering.ToString("D2")

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

## Change the current context to use the Microsoft Sovereingty Microhack Sub subscription

$subMicrohackName = Get-AzSubscription | Where-Object {$_.Name -like "*Microhack*"}

Set-AzContext -SubscriptionId $subMicrohackName.SubscriptionId | Out-Null 

Write-Host ($writeEmptyLine + "# Microhack subscription in current tenant selected" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Get the Current signed-in user object ID

$currentUserUpn = (Get-AzContext).Account.Id
$currentUserId  = (Get-AzADUser -UserPrincipalName $currentUserUpn).Id

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Get the Key Vault resource ID

$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgLabUser03Name
$scope    = $keyVault.ResourceId
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Assign role to current user

New-AzRoleAssignment `
  -RoleDefinitionName "Key Vault Crypto Officer" `
  -ObjectId $currentUserId `
  -Scope $scope


Write-Host ($writeEmptyLine + "# Key Vault Crypto Officer role assigned to current user" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
