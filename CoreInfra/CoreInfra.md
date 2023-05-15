# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
environment    | Yes      | Required. The environment to deploy into (dev, test, prod, etc.)
costCenter     | Yes      | Required. The cost center to deploy into (e.g. 1234)
owner          | Yes      | Required. The owner of the deployment (e.g. John Doe)
name           | Yes      | Required. The name of the application/deployment
location       | No       | Optional. The location to deploy into. Defaults to eastus
secrets        | No       | Optional. The name of the resource group to deploy
roleAssignments | No       | Optional. Predefined role assignment
devopsResourceGroupName | Yes      |
devopsKeyVaultName | Yes      |

### environment

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The environment to deploy into (dev, test, prod, etc.)

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

### secrets

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The name of the resource group to deploy

### roleAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Predefined role assignment

### devopsResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### devopsKeyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



## Outputs

Name | Type | Description
---- | ---- | -----------
storageAccountName | string |
resourceGroupName | string |
keyVaultName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "CoreInfra/main.json"
    },
    "parameters": {
        "environment": {
            "value": ""
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
        "secrets": {
            "value": {}
        },
        "roleAssignments": {
            "value": []
        },
        "devopsResourceGroupName": {
            "value": ""
        },
        "devopsKeyVaultName": {
            "value": ""
        }
    }
}
```
