<#
.SYNOPSIS

A script used to assign the Built-in Deny Public IP Address Creation policy to your resource group.

.DESCRIPTION

A script used to assign the Built-in Deny Public IP Address Creation policy to your resource group. 
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Build the policy parameters (equivalent to --params JSON).
Assign the policy to the resource group.

.NOTES

Filename:       06-Challenge-1-Assign-Builtin-in-Policy-Deny-Public-IP-Address-Creation.ps1
Created:        04/03/2026
Last modified:  04/03/2026
Author:         Wim Matthyssen
Version:        3.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v14.6.0)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

.\06-Challenge-1-Assign-Builtin-in-Policy-Deny-Public-IP-Address-Creation.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# LabUser-03 - change the with the inventory numbering for your lab user
$inventoryNumbering = 3

$labUser = "LabUser"
$rgLabUser03Name = $labUser + "-" + $inventoryNumbering.ToString("D2")

$policyName = $inventoryNumbering.ToString("D2") + "-" + "block-public-ip-addresses"
$policyDisplayName = $rgLabUser03Name + "-" + "Block Public IP Addresses"
$policyDefinitionId = "6c112d4e-5bc7-47ae-a041-ea2d9dccd749"

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

## Build policy parameters (equivalent to --params JSON)

$PolicyParams = @{
    listOfResourceTypesNotAllowed = @("Microsoft.Network/publicIPAddresses")
}

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Assign the policy to the resource group

$policyDefinition = Get-AzPolicyDefinition -Id "/providers/Microsoft.Authorization/policyDefinitions/$policyDefinitionId"

New-AzPolicyAssignment `
    -Name $policyName `
    -DisplayName $policyDisplayName `
    -Scope "/subscriptions/$($subPlatformName.SubscriptionId)/resourceGroups/$rgLabUser03Name" `
    -PolicyDefinition $policyDefinition `
    -PolicyParameterObject $PolicyParams

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

