param location string
param subnetId string
param vmName string
param lawId string
param tags object

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [{ name: 'ipconfig1', properties: { subnet: { id: subnetId } } }]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  tags: tags
  identity: { type: 'SystemAssigned' }
  properties: {
    hardwareProfile: { vmSize: 'Standard_B1s' }
    storageProfile: {
      imageReference: { publisher: 'Canonical', offer: '0001-com-ubuntu-server-focal', sku: '20_04-lts-gen2', version: 'latest' }
      osDisk: { createOption: 'FromImage', managedDisk: { storageAccountType: 'Standard_LRS' } }
    }
    networkProfile: { networkInterfaces: [{ id: nic.id }] }
  }
}

// Immutable Resource Lock
resource lock 'Microsoft.Authorization/locks@2017-04-01' = {
  name: 'CanNotDeleteVM'
  scope: vm
  properties: { level: 'CanNotDelete', notes: 'Critical Workload' }
}

// Diagnostic Settings (The Pipe)
resource diag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'vm-to-law'
  scope: vm
  properties: {
    workspaceId: lawId
    metrics: [{ category: 'AllMetrics', enabled: true }]
  }
}
