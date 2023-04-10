targetScope = 'subscription'

// With Bicep, you do not need to use json ARM parameter files
// You can define your parameters directly in the Bicep file and call the module
//
// This structure also allows you to do data queries to retrieve sensitive
// information from other resources in the subscription or resource group


// Tagging & Naming Parameters
@description('Required. The environment to deploy into (dev, test, prod, etc.)')
param environment string = 'dev'

@description('Required. The cost center to deploy into (e.g. 1234)')
param costCenter string = 'clopsCC'

@description('Required. The owner of the deployment (e.g. John Doe)')
param owner string = 'cloudops@contoso.com'

@minLength(3)
@maxLength(22)
@description('Required. The name of the application/deployment')
param name string = 'clopsCC'

@allowed([
  'eastus'
  'eastus2'
  'westus'
  'westus2'
  'centralus'
  'northcentralus'
])
@description('Optional. The location to deploy into. Defaults to eastus')
param location string = 'eastus2'

// @description('Optional. The name of the resource group to deploy')
// @secure()
// param secrets object = {}

@description('Optional. Predefined role assignment')
param roleAssignments array = [
  {
    roleDefinitionIdOrName: 'Contributor'
    description: 'Contributor access to resource group'
    principalIds: [
      '92c232f7-62e4-4b17-a155-24cf4d8392db'
    ]
  }
  {
    roleDefinitionIdOrName: 'Reader'
    description: 'Reader access to resource group'
    principalIds: [
      '92c232f7-62e4-4b17-a155-24cf4d8392db'
    ]
  }
]

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

// Core Infra Deployment
@description('Core Infra Deployment')
module coreInfraDeploy '../coreInfra.bicep' = {
  name: name
  params: {
    environment: environment
    costCenter: costCenter
    owner: owner
    name: name
    location: location
    roleAssignments: roleAssignments
  }
}
