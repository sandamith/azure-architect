@description('Name of the virtual network')
param vnetName string

@description('Location for the VNet')
param location string

@description('Address space for the VNet')
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

@description('Tags to apply to the network resources')
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetPrefix
          networkSecurityGroup: {
            id: nsgApp.id
          }
        }
      }
      {
        name: dbSubnetName
        properties: {
          addressPrefix: dbSubnetPrefix
          networkSecurityGroup: {
            id: nsgDb.id
          }
        }
      }  
    ]
  }
}

resource nsgApp 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgAppName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPFromLB'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nsgDb 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgDbName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSQLFromAppSubnet'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
