<#
.SYNOPSIS

A script used to create an Azure Key vault (Standard SKU) with soft-delete and purge protection enabled.

.DESCRIPTION

A script used to create an Azure Key vault (Standard SKU) with soft-delete and purge protection enabled.
The script will do all of the following:

Remove the breaking change warning messages.
Change the current context to use the demo subscription.
Create a globally unique name for the Key vault.
Create a resource group for the Key vault if it does not already exists.
Create the Key vault if it does not exist.

.NOTES

Filename:       08-Create-Azure-Key-Vault-standard-with-soft-delete-and-purge-protection.ps1
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
.\08-Create-Azure-Key-Vault-standard-with-soft-delete-and-purge-protection.ps1

.LINK

#>

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

# LabUser-03 - change the with the inventory numbering for your lab user
$inventoryNumbering = 3

$labUser = "LabUser"
$region = "northeurope"

$rgLabUser03Name = $labUser + "-" + $inventoryNumbering.ToString("D2")

$keyVaultSku = "Standard"
$keyVaultSoftDeleteRetentionInDays = "7"

$requiredTagName = "DataClassification"
$requiredTagValue = "Sovereign"
$requiredTags = @{ $requiredTagName = $requiredTagValue }

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

## Create global unique key vault name

$hashSuffix = (
    [System.BitConverter]::ToString(
        [System.Security.Cryptography.MD5]::Create().ComputeHash(
            [System.Text.Encoding]::UTF8.GetBytes("$rgLabUser03Name-$(Get-Random)-$(Get-Random)")
        )
    ).Replace('-', '').ToLower()
).Substring(0, 8)

$keyVaultName = "kv-c2-${hashSuffix}"

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create a key vault resource group for the Key Vault resources if it not already exists. 

try {
    Get-AzResourceGroup -Name $rgLabUser03Name -ErrorAction Stop | Out-Null 
} catch {
    New-AzResourceGroup -Name $rgLabUser03Name -Location $region -Force | Out-Null
}

Write-Host ($writeEmptyLine + "# Resource group $rgLabUser03Name available" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create the Key vault if it does not exist

# -EnabledForDeployment: Enables the Microsoft.Compute resource provider to retrieve secrets from this key vault when this key vault is referenced in resource creation 
# -EnabledForDiskEncryption: Enables the Azure disk encryption service to get secrets and unwrap keys from this key vault
# -EnabledForTemplateDeployment: Enables Azure Resource Manager to get secrets from this key vault when this key vault is referenced in a template deployment
# -EnablePurgeProtection: If specified, protection against immediate deletion is enabled for this vault; requires soft delete to be enabled as well

# Get the Key Vault and store in a variable for later use
$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgLabUser03Name -ErrorAction SilentlyContinue

if($null -eq $keyVault){
    $keyVault = Get-AzKeyVault -VaultName $keyVaultName -Location $region -InRemovedState -ErrorAction SilentlyContinue
    if ($null -eq $KeyVault) {
        New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgLabUser03Name -Location $region -Sku $keyVaultSku -EnabledForDeployment -EnabledForDiskEncryption `
        -EnabledForTemplateDeployment -SoftDeleteRetentionInDays $keyVaultSoftDeleteRetentionInDays -EnablePurgeProtection -Tag $requiredTags | Out-Null 

        Write-Host ($writeEmptyLine + "# Key Vault $keyVaultName created" + $writeSeperatorSpaces + $currentTime)`
        -foregroundcolor $foregroundColor2 $writeEmptyLine
    } else {
        Write-Host ($writeEmptyLine + "# Key Vault $keyVaultName exists but is in soft-deleted state" + $writeSeperatorSpaces + $currentTime)`
        -foregroundcolor $foregroundColor2 $writeEmptyLine
    }
}
else{
    Write-Host ($writeEmptyLine + "# Key vault $keyVaultName already exists" + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor2 $writeEmptyLine
}

# Key vaults that are soft-delete enabled must be deleted and then purged

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
