param location string = resourceGroup().location
param tags object = {
  Environment: 'Production'
  CostCenter: 'KPMG-KGS-Project'
  ManagedBy: 'Platform-Ops'
}

// 1. Storage Account with "Secure Transfer" Mandatory
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'stg${uniqueString(resourceGroup().id)}'
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  tags: tags
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false // Security Baseline
    minimumTlsVersion: 'TLS1_2'
  }
}

// 2. VNET with Subnet Delegation for Security
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'Enterprise-Landing-Zone-VNET'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.10.0.0/16'] }
    subnets: [
      {
        name: 'AppSubnet'
        properties: { addressPrefix: '10.10.1.0/24' }
      }
      {
        name: 'PrivateLinkSubnet'
        properties: { 
          addressPrefix: '10.10.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled' 
        }
      }
    ]
  }
}
