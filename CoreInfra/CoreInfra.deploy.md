# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
environment    | No       | Required. The environment to deploy into (dev, test, prod, etc.)
costCenter     | Yes      | Required. The cost center to deploy into (e.g. 1234)
owner          | Yes      | Required. The owner of the deployment (e.g. John Doe)
name           | Yes      | Required. The name of the application/deployment
location       | No       | Optional. The location to deploy into. Defaults to eastus
roleAssignments | No       | Optional. Predefined role assignment
subnets        | No       | Optional. Subnets to create in the VNET
cicdSubnetId   | No       | Optional. Subnet Resource ID to assign to the CICD VM
addressPrefix  | No       | Optional. Address prefix to create the VNet with
adminUsername  | No       | Optional. The admin username for the VM
adminPassword  | No       | Optional. The admin password for the VM

### environment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. The environment to deploy into (dev, test, prod, etc.)

- Default value: `dev`

### costCenter

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The cost center to deploy into (e.g. 1234)

### owner

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The owner of the deployment (e.g. John Doe)

### name

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the application/deployment

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The location to deploy into. Defaults to eastus

- Default value: `eastus`

- Allowed values: `eastus`, `eastus2`, `westus`, `westus2`, `centralus`, `northcentralus`

### roleAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Predefined role assignment

### subnets

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Subnets to create in the VNET

### cicdSubnetId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Subnet Resource ID to assign to the CICD VM

### addressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Address prefix to create the VNet with

### adminUsername

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The admin username for the VM

### adminPassword

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The admin password for the VM

- Default value: `[newGuid()]`

## Outputs

Name | Type | Description
---- | ---- | -----------
storageAccountName | string |
resourceGroupName | string |
keyVaultName | string |
cicdVMName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "CoreInfra/coreInfra.bicep.json"
    },
    "parameters": {
        "environment": {
            "value": "dev"
        },
        "costCenter": {
            "value": ""
        },
        "owner": {
            "value": ""
        },
        "name": {
            "value": ""
        },
        "location": {
            "value": "eastus"
        },
        "roleAssignments": {
            "value": []
        },
        "subnets": {
            "value": []
        },
        "cicdSubnetId": {
            "value": ""
        },
        "addressPrefix": {
            "value": ""
        },
        "adminUsername": {
            "reference": {
                "keyVault": {
                    "id": ""
                },
                "secretName": ""
            }
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": ""
                },
                "secretName": ""
            }
        }
    }
}
```
