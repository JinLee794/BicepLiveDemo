targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy')
param secrets object 


// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.11' = {
  name: 'bicepLiveDemo-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

// Key vault
module kv 'br/modules:microsoft.keyvault.vaults:0.4.38' = {
  scope: resourceGroup('bicepLiveDemo-rg')
  name: 'bicepLiveDemo-kv'
  params: {
    name: 'bicepLiveDemo-kv'
    location: location
    
  }
  dependsOn: [
    rg
  ]
} 

// Storage Account
module sa 'br/modules:microsoft.storage.storageaccounts:0.4.39' = {
  scope: resourceGroup('bicepLiveDemo-rg')
  name: 'bicelivedemouatjleesa'
  params: {
    location: location
  }
  dependsOn: [
    rg
  ]
}
