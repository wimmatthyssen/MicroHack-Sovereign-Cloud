<#
.SYNOPSIS

A script used to assign the Built-in Allowed location for policy to your resource group.

.DESCRIPTION

A script used to assign the Built-in Allowed location for policy to your resource group. 
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Build the policy parameters (equivalent to --params JSON).
Assign the policy to the resource group.

.NOTES

Filename:       04-Challenge-1-Assign-Builtin-in-Policy-Allowed-locations-for-resouce-groups.ps1
Created:        04/03/2026
Last modified:  04/03/2026
Author:         Wim Matthyssen
Version:        3.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v14.6.0)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

.\04-Challenge-1-Assign-Builtin-in-Policy-Allowed-locations-for-resouce-groups.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# LabUser-03 - change the with the inventory numbering for your lab user
$inventoryNumbering = 3

$labUser = "LabUser"
$rgLabUser03Name = $labUser + "-" + $inventoryNumbering.ToString("D2")

$policyName = $inventoryNumbering.ToString("D2") + "-" + "restrict-rg-to-sovereign-regions"
$policyDisplayName = $rgLabUser03Name + "-" + "Restrict Resource Groups to Sovereign Regions"
$policyDefinitionId = "e765b5de-1225-4ba3-bd56-1ac6695af988"

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
    listOfAllowedLocations = @("norwayeast", "germanynorth", "northeurope")
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

