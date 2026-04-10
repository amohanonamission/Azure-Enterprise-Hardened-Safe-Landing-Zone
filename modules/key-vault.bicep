param location string
param prefix string
param vnetId string
param subnetId string
param tags object 

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: take('kv-${prefix}-${uniqueString(resourceGroup().id)}', 24)
  location: location
  tags: tags 
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true // Modern Best Practice
    networkAcls: { defaultAction: 'Deny', bypass: 'AzureServices' }
  }
}

// Private Endpoint for Key Vault
resource kvPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: 'pe-${kv.name}'
  location: location
  tags: tags
  properties: {
    subnet: { id: subnetId }
    privateLinkServiceConnections: [
      {
        name: 'kvConnection'
        properties: { privateLinkServiceId: kv.id, groupIds: ['vault'] }
      }
    ]
  }
}
