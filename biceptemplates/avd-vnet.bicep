param location string
param tags object
param AVDnetworkname string
param AVDvnetAddressPrefix string
param AVDsubnet1name string
param AVDsubnetAddressPrefix string
param AVDnsgName string

resource AVDnetwork 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: AVDnetworkname
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        AVDvnetAddressPrefix
      ]
      
    }
    subnets: [
      {
        name: AVDsubnet1name
        properties: {
          addressPrefix: AVDsubnetAddressPrefix
          networkSecurityGroup: {
            id: AVDnsg.id
          }
        }
      }
    ]
  }
}
output subnetId string = AVDnetwork.properties.subnets[0].id

resource AVDnsg 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: AVDnsgName
  location: location
  tags: tags
}
