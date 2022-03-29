targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The name of the resource group to deploy')
param storageAccountName string = 'validation-sa'

@description('Optional. The name of the resource group to deploy')
param keyVaultName string = 'validation-kv'

@description('Optional. The location to deploy into')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy')
param secrets object = {}

@description('Optional. Predefined role assignment')
param roleAssignments array = []


// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.11' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
  }
}

// Key vault
module kv 'br/modules:microsoft.keyvault.vaults:0.4.38' = {
  scope: resourceGroup(rg.name)
  name: keyVaultName
  params: {
    name: keyVaultName
    location: location
    roleAssignments: roleAssignments
    secrets: secrets
  }
} 

// Storage Account
module sa 'br/modules:microsoft.storage.storageaccounts:0.4.39' = {
  scope: resourceGroup(rg.name)
  name: storageAccountName
  params: {
    name: storageAccountName
    location: location
  }
}
