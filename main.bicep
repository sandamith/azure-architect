@description('Resource group location')
param location string = resourceGroup().location

@description('Storage account name')
param storageAccountPrefix string 

@description('Virtual network name')
param vnetName string 

@description('Address space for the virtual network')
param vnetAddressSpace string 

@description('App Subnet name')
param appSubnetName string 

@description('App subnet CIDR')
param appSubnetPrefix string 

@description('DB Subnet name')
param dbSubnetName string 

@description('DB subnet CIDR')
param dbSubnetPrefix string 

@description('App NSG name')
param nsgAppName string 

@description('DB NSG name')
param nsgDbName string 

@description('Tags to apply for resources')
param tags object 


var storageAccountName = '${storageAccountPrefix}${uniqueString(resourceGroup().id)}'

module storageAccount 'storageAccount.bicep' = {
  name: 'deployStorageAccount'
  params: {
    storageAccountName: storageAccountName
    location: location
    tags: tags
  }
}

module network 'network.bicep' = {
  name: 'deployNetwork'
  params: {
    vnetName: vnetName
    location: location  
    vnetAddressSpace: vnetAddressSpace
    appSubnetName: appSubnetName
    appSubnetPrefix: appSubnetPrefix
    dbSubnetName: dbSubnetName
    dbSubnetPrefix: dbSubnetPrefix
    nsgAppName: nsgAppName
    nsgDbName: nsgDbName
    tags: tags
  }
}

