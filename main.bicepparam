using 'main.bicep'

param storageAccountPrefix = 'svm'
param vnetName = 'vnet-svm-prod-bicep'
param vnetAddressSpace = '10.0.0.0/16'
param appSubnetName = 'snet-app-svm-prod'
param appSubnetPrefix = '10.0.1.0/24'
param dbSubnetName = 'snet-db-svm-prod'
param dbSubnetPrefix = '10.0.2.0/24'
param nsgAppName = 'nsg-app-svm-prod'
param nsgDbName = 'nsg-db-svm-prod'
param tags =  {
  environment: 'prod'
  owner: 'sandamith.wanigasuriya@svm.com'
  project: 'svm-saas'
  costCenter: 'C101'
  compliance: 'GDPR'
  bicep: 'true'
}
