@description('Storage account name')
param storageAccountName string

@description('Storage account location')
param location string

@description('Tags to apply to the storage account')
param tags object

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource lifecycleMgmt 'Microsoft.Storage/storageAccounts/managementPolicies@2024-01-01' = {
  name: 'lifecycleMgmtPolicy'
  parent: storageAccount
  properties: {
    policy: {
      rules: [
        {
          name: 'ArchiveAfter30Days'
          enabled: true
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                tierToArchive: {
                  daysAfterModificationGreaterThan: 30
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
          }
        }
      ]
    }
  }
}

output storageAccountId string = storageAccount.id
