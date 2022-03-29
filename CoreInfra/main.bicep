targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

// NSG parameters
@description('Optional. The name of the vnet to deploy')
param networkSecurityGroupName string = 'BicepRegistryDemoNsg'

// VNET parameters
@description('Optional. The name of the vnet to deploy')
param vnetName string = 'BicepRegistryDemoVnet'

@description('Optional. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]


@description('Optional. An Array of subnets to deploy to the Virual Network.')
param subnets array = [
  {
    name: 'PrimarySubnet'
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
  {
    name: 'SecondarySubnet'
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
]

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.11' = {
  name: 'registry-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

// // Network Security Group
// module nsg 'br/modules:microsoft.network.networksecuritygroups:0.4.735' = {
//   name: 'registry-nsg'
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     name: networkSecurityGroupName
//   }
//   dependsOn: [
//     rg
//   ]
// }

// // Virtual Network
// module vnet 'br/modules:microsoft.network.virtualnetworks:0.4.735' = {
//   name: 'registry-vnet'
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     name: vnetName
//     addressPrefixes: vNetAddressPrefixes
//     subnets: subnets
//   }
//   dependsOn: [
//     nsg
//     rg
//   ]
// }
