targetScope = 'subscription'

// =========== //
// This Deployment sets up 'Core Resources' to showcase the use of modules
// - Resource Group
// - Key Vault
// - Storage Account
// - Virtual Network
// - DevOps Win/Linux VM
// - Role Assignments
// - Appropriate Tags
//   - CostCenter
//   - Environment
//   - Owner
// =========== //

// ================ //
// Input Parameters //
// ================ //

// Tagging & Naming Parameters
@description('Required. The environment to deploy into (dev, test, prod, etc.)')
param environment string = 'dev'

@description('Required. The cost center to deploy into (e.g. 1234)')
param costCenter string

@description('Required. The owner of the deployment (e.g. John Doe)')
param owner string

@minLength(3)
@maxLength(22)
@description('Required. The name of the application/deployment')
param name string

@allowed([
  'eastus'
  'eastus2'
  'westus'
  'westus2'
  'centralus'
  'northcentralus'
])
@description('Optional. The location to deploy into. Defaults to eastus')
param location string = 'eastus'

@description('Optional. The name of the resource group to deploy')
@secure()
param secrets object = {}

@description('Optional. Predefined role assignment')
param roleAssignments array = []

// param devopsResourceGroupName string
// param devopsKeyVaultName string

var tags = {
  deploymentTemplate: 'BicepLiveDemo/coreInfra'
  environment: environment
  costCenter: costCenter
  owner: owner
}

var resourceGroupName = '${name}-${location}-rg'
var keyVaultName = toLower('kv${name}')
var storageAccountName = toLower('sa${name}')

// =========== //
// Data Lookup //
// =========== //
// resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
//   name: devopsKeyVaultName
//   scope: resourceGroup(devopsResourceGroupName)
// }

// =========== //
// Deployments //
// =========== //
// Note: This is where you can further standardize your deployments by using modules
//       as well as controlling required parameters to properly provision resources
//       per your organization's naming/tagging standards, etc.
// =========== //

// Resource Group
@description('Core Infra Resource Group')
module coreRG 'br/modules:microsoft.resources.resourcegroups:0.5' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
    roleAssignments: roleAssignments

    tags: union(tags, {
      moduleSource: 'br/modules:microsoft.resources.resourcegroups'
      moduleVersion: '0.5'
    })
  }
}

@description ('Core Infra VNET')
module coreVNet 'br/modules:microsoft.network.virtualnetworks:0.4' = {
  scope: resourceGroup(coreRG.name)
  name: 'vnet'
  params: {
    name: 'vnet'
    location: location
    roleAssignments: roleAssignments
    addressPrefixes: [
      '10.10.0.0/16'
    ]
    tags: union(tags, {
      moduleSource: 'br/modules:microsoft.network.virtualnetworks'
      moduleVersion: '0.4'
    })
  }
}

// Storage Account
@description('Core Infra Storage Account')
module coreSA 'br/modules:microsoft.storage.storageaccounts:0.5' = {
  scope: resourceGroup(coreRG.name)
  name: storageAccountName
  params: {
    name: storageAccountName
    location: location
    roleAssignments: roleAssignments
    tags: union(tags, {
      moduleSource: 'br/modules:microsoft.storage.storageaccounts'
      moduleVersion: '0.5'
    })
  }
}

// Key vault
@description('Core Infra Key Vault')
module coreKV 'br/modules:microsoft.keyvault.vaults:0.5' = {
  scope: resourceGroup(coreRG.name)
  name: '${environment}${keyVaultName}'
  params: {
    name: keyVaultName
    location: location
    roleAssignments: roleAssignments
    diagnosticStorageAccountId: coreSA.outputs.resourceId
    diagnosticLogCategoriesToEnable: ['allLogs']
    diagnosticMetricsToEnable: ['AllMetrics']
    diagnosticLogsRetentionInDays: 30
    tags: union(tags, {
      moduleSource: 'br/modules:microsoft.keyvault.vaults'
      moduleVersion: '0.5'
    })
  }
}

output storageAccountName string = coreSA.name
output resourceGroupName string = coreRG.name
output keyVaultName string = coreKV.name
