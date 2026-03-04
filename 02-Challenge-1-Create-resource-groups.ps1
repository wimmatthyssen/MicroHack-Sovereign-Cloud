<#
.SYNOPSIS

A script used to create all necessary resource groups for your demo.

.DESCRIPTION

A script used to create all necessary resource groups for your demo. 
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Store the specified set of tags in a hash table.
Create resource group management, if it not already exists. Add specified tags add specified tags and lock with a CanNotDelete lock.

.NOTES

Filename:       02-Create-resource-groups.ps1
Created:        04/03/2026
Last modified:  04/03/2026
Author:         Wim Matthyssen
Version:        3.0
PowerShell:     Azure PowerShell and Azure Cloud Shell
Requires:       PowerShell Az (v14.6.0)
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

.\02-Create-resource-groups.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# LabUser-03 - change the with the inventory numbering for your lab user
$inventoryNumbering = 3

$labUser = "LabUser"
$region = "northeurope"
$environment = "test"

$rgLabUser03Name = $labUser + "-" + $inventoryNumbering.ToString("D2")

$tagEnvironmentName = "Env"
$tagEnvironmentValue = (Get-Culture).TextInfo.ToTitleCase($environment.ToLower())
$tagCostCenterName  = "CostCenter"
$tagCostCenterValue = "1"
$tagCriticalityName  = "Criticality"
$tagCriticalityValue = "Low"
$tagPurposeName  = "Purpose"

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

## Store the specified set of tags in a hash table

$tags = @{$tagEnvironmentName=$tagEnvironmentValue;$tagCostCenterName=$tagCostCenterValue;$tagCriticalityName=$tagCriticalityValue}

Write-Host ($writeEmptyLine + "# Specified set of tags available to add" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create resource group Lab User, if it not already exists. Add specified tags add specified tags and lock with a CanNotDelete lock

try {
    Get-AzResourceGroup -Name $rgLabUser03Name -ErrorAction Stop | Out-Null 
} catch {
    New-AzResourceGroup -Name $rgLabUser03Name -Location $region -Force | Out-Null
}

# Set tags resource group Lab User
Set-AzResourceGroup -Name $rgLabUser03Name -Tag $tags | Out-Null

# Add purpose tag resource group Lab User
$storeTags = (Get-AzResourceGroup -Name $rgLabUser03Name).Tags
$storeTags += @{$tagPurposeName ="Lab User"}
Set-AzResourceGroup -Name $rgLabUser03Name -Tag $storeTags | Out-Null

# Lock resource group Lab User with a CanNotDelete lock
$lock = Get-AzResourceLock -ResourceGroupName $rgLabUser03Name

if ($null -eq $lock){
    New-AzResourceLock -LockName DoNotDeleteLock -LockLevel CanNotDelete -ResourceGroupName $rgLabUser03Name -LockNotes "Prevent $rgLabUser03Name from deletion" -Force | Out-Null
    }

Write-Host ($writeEmptyLine + "# Resource group $rgLabUser03Name available with tags and CanNotDelete lock" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
