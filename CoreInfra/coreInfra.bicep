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
@maxLength(4)
@description('Required. The environment to deploy into (dev, test, prod, etc.)')
param environment string = 'dev'

@description('Required. The cost center to deploy into (e.g. 1234)')
param costCenter string

@description('Required. The owner of the deployment (e.g. John Doe)')
param owner string

@minLength(3)
@maxLength(18)
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

@description('Optional. Predefined role assignment')
param roleAssignments array = []

@description('Optional. Subnets to create in the VNET')
param subnets array = []

@description('Optional. Subnet Resource ID to assign to the CICD VM')
param cicdSubnetId string = ''

@description('Optional. Address prefix to create the VNet with')
param addressPrefix string = ''

var tags = {
  deploymentTemplate: 'BicepLiveDemo/coreInfra'
  environment: environment
  costCenter: costCenter
  owner: owner
}

@description('Optional. The admin username for the VM')
@secure()
param adminUsername string = ''

@description('Optional. The admin password for the VM')
@secure()
param adminPassword string = newGuid()

var locationCodes = {
  eastus: 'eus'
  eastus2: 'eus2'
  westus: 'wus'
  westus2: 'wus2'
  centralus: 'cus'
  northcentralus: 'ncus'
}
var locationCode = locationCodes[location]
var resourceGroupName = '${name}-${locationCode}-${environment}-rg'
var keyVaultName = toLower('kv${name}${locationCode}${environment}')
var storageAccountName = toLower('sa${name}${locationCode}${environment}')
var vnetName = '${name}-${locationCode}-${environment}-vnet'

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
      moduleSource: 'microsoft.resources.resourcegroups'
      moduleVersion: '0.5'
    })
  }
}

@description ('Core Infra VNET')
module coreVNet 'br/modules:microsoft.network.virtualnetworks:0.4' = if(addressPrefix != '') {
  scope: az.resourceGroup(coreRG.name)
  name: vnetName
  params: {
    name: vnetName
    location: location
    roleAssignments: roleAssignments
    addressPrefixes: [
      '10.10.0.0/16'
    ]

    subnets: subnets

    tags: union(tags, {
      moduleSource: 'microsoft.network.virtualnetworks'
      moduleVersion: '0.4'
    })
  }
}

// Storage Account
@description('Core Infra Storage Account')
module coreSA 'br/modules:microsoft.storage.storageaccounts:0.5' = {
  scope: az.resourceGroup(coreRG.name)
  name: storageAccountName
  params: {
    name: storageAccountName
    location: location
    roleAssignments: roleAssignments
    tags: union(tags, {
      moduleSource: 'microsoft.storage.storageaccounts'
      moduleVersion: '0.5'
    })
  }
}

// Key vault
@description('Core Infra Key Vault')
module coreKV 'br/modules:microsoft.keyvault.vaults:0.5' = {
  scope: az.resourceGroup(coreRG.name)
  name: '${environment}${keyVaultName}'
  params: {
    name: keyVaultName
    location: location
    roleAssignments: roleAssignments
    diagnosticStorageAccountId: coreSA.outputs.resourceId
    diagnosticLogCategoriesToEnable: ['allLogs']
    diagnosticMetricsToEnable: ['AllMetrics']
    diagnosticLogsRetentionInDays: 30

    secrets: {
      secureList: [
        {
          name: '${cicdVM.name}-adminPassword'
          value: adminPassword
        }
      ]
    }
    tags: union(tags, {
      moduleSource: 'modules:microsoft.keyvault.vaults'
      moduleVersion: '0.5'
    })
  }
}

// Virtual Machine
@description('SelfHosted Agent VM for CICD')
module cicdVM 'br/modules:microsoft.compute.virtualmachines:0.6' = if (!empty(subnets) || !empty(cicdSubnetId)) {
  scope: az.resourceGroup(coreRG.name)
  name: 'cicdVM'
  params: {
    name: 'cicdVM'
    location: location
    roleAssignments: roleAssignments
    adminUsername: adminUsername
    adminPassword: adminPassword
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-jammy'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
            subnetResourceId: (!empty(cicdSubnetId) ? cicdSubnetId : coreVNet.outputs.subnetResourceIds[0])
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'

    diagnosticStorageAccountId: coreSA.outputs.resourceId
    diagnosticLogsRetentionInDays: 30
    tags: union(tags, {
      moduleSource: 'microsoft.compute.virtualmachines'
      moduleVersion: '0.5'
    })
  }
}



output storageAccountName string = coreSA.name
output resourceGroupName string = coreRG.name
output keyVaultName string = coreKV.name
output cicdVMName string = cicdVM.name
// output storageAccount object = coreSA
// output resourceGroup object = coreRG
// output keyVault object = coreKV
