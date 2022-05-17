targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

param environment string = 'dev'

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The name of the resource group to deploy')
param storageAccountName string = 'validation-sa'

@description('Optional. The name of the resource group to deploy')
param keyVaultName string = 'validation-kv'

@description('Optional. The location to deploy into')
param location string = 'eastus'

@description('Optional. The name of the resource group to deploy')
param secrets object = {}

@description('Optional. Predefined role assignment')
param roleAssignments array = []


// =========== //
// Deployments //
// =========== //

// Resource Group
// module rg 'br/modules:microsoft.resources.resourcegroups:0.4.11' = {
module rg '../BicepModulesDemo/arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${resourceGroupName}-${environment}'
  params: {
    name: '${resourceGroupName}-${environment}'
    location: location
  }
}

// Key vault
// module kv 'br/modules:microsoft.keyvault.vaults:0.4.38' = {
module kv '../BicepModulesDemo/arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup(rg.name)
  name: '${keyVaultName}${environment}'
  params: {
    location: location
    roleAssignments: roleAssignments
    secrets: secrets
  }
} 

// Storage Account
// module sa 'br/modules:microsoft.storage.storageaccounts:0.4.39' = {
module sa '../BicepModulesDemo/arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: resourceGroup(rg.name)
  name: '${storageAccountName}${environment}'
  params: {
    location: location
  }
}

output storageAccountName string = sa.name
output resourceGroupName string = rg.name
output keyVaultName string = kv.name
