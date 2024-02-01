param location string = resourceGroup().location

param tags object = {
  Project: 'Automate-AVD-Github-Actions'
  Responsible: 'mark.tilleman@cegeka.com'
}

// param workspaceLocation string

@description('If true Host Pool, App Group and Workspace will be created. Default is to join Session Hosts to existing AVD environment')
param newBuild bool = true

// hostPool parameters
@allowed([
  'Personal'
  'Pooled'
])
param hostPoolType string = 'Pooled'
param hostPoolName string = 'testHP'

@allowed([
  'Automatic'
  'Direct'
])
param personalDesktopAssignmentType string = 'Direct'
param maxSessionLimit int = 12

@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string = 'BreadthFirst'

@description('Friendly Name of the Host Pool, this is visible via the AVD client')
param hostPoolFriendlyName string = 'testHP'

// workspace parameters
@description('Name of the AVD Workspace to used for this deployment')
param workspaceName string = 'ABRI-AVD-PROD'
param workspaceFriendlyName string = 'testWorkspace'

// applicationGroup parameters
param appGroupFriendlyName string = 'testAP'
var appGroupName = '${hostPoolName}-DAG'

// vnet parameters
param AVDnetworkname string = 'AVDnetwork'
param AVDvnetAddressPrefix string ='10.0.0.0/24'
param AVDsubnet1name string = 'AVDsunbet1'
param AVDsubnetAddressPrefix string = '10.0.0.0/24'
param AVDnsgName string = 'AVDnsg'

// gallary and image parameters
param galleryName string = 'testGallery'


resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2023-11-01-preview' = if (newBuild) {
  name: hostPoolName
  location: location
  tags: tags
  properties: {
    friendlyName: hostPoolFriendlyName
    hostPoolType: hostPoolType
    managementType: 'Standard'
    loadBalancerType: loadBalancerType
    preferredAppGroupType: 'Desktop'
    personalDesktopAssignmentType: personalDesktopAssignmentType
    maxSessionLimit: maxSessionLimit
  }
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-11-01-preview' = if (newBuild) {
  name: appGroupName
  location: location
  tags: tags
  properties: {
    friendlyName: appGroupFriendlyName
    applicationGroupType: 'Desktop'
    hostPoolArmPath: hostPool.id
    description: 'Deskop Application Group created through GitHub Actions.'
  }
}

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2023-11-01-preview' = if (newBuild) {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    friendlyName: workspaceFriendlyName
    applicationGroupReferences: [
      applicationGroup.id
    ]
  }
}

resource AVDnetwork 'Microsoft.Network/virtualNetworks@2023-06-01' = if (newBuild) {
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

resource AVDnsg 'Microsoft.Network/networkSecurityGroups@2023-06-01' = if (newBuild) {
  name: AVDnsgName
  location: location
  tags: tags
}

resource acg 'Microsoft.Compute/galleries@2022-08-03' = {
  name: galleryName
  location: location
}
