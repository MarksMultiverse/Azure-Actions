targetScope = 'subscription'
param location string = 'westeurope'
param newBuild bool = true

param tags object = {
  Project: 'Automate-AVD-Github-Actions'
  Responsible: 'mark.tilleman@cegeka.com'
}

param RGnameAVDinfra string = 'RG01MARK'
param RGnameAVDvms string = 'RG02MARK'

// vnet parameters
param AVDnetworkname string = 'AVDnetwork'
param AVDvnetAddressPrefix string ='10.0.0.0/24'
param AVDsubnet1name string = 'AVDsunbet1'
param AVDsubnetAddressPrefix string = '10.0.0.0/24'
param AVDnsgName string = 'AVDnsg'

// infra parameters
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
@description('Name of the AVD Workspace to used for this deployment')
param workspaceName string = 'ABRI-AVD-PROD'
param workspaceFriendlyName string = 'testWorkspace'
param appGroupFriendlyName string = 'testAP'
param galleryName string = 'testGallery'

// create resource groups
resource RGAVDinfra 'Microsoft.Resources/resourceGroups@2023-07-01' = if (newBuild) {
  name: RGnameAVDinfra
  location: location
  tags: tags
}

resource RGAVDvms 'Microsoft.Resources/resourceGroups@2023-07-01' = if (newBuild) {
  name: RGnameAVDvms
  location: location
  tags: tags
}

// import modules
module vnet 'avd-vnet.bicep' = if (newBuild) {
  scope: RGAVDinfra
  name: 'VNET deployment'
  params: {
    location: location
    tags: tags
    AVDnetworkname: AVDnetworkname
    AVDnsgName: AVDnsgName
    AVDsubnet1name: AVDsubnet1name
    AVDsubnetAddressPrefix: AVDsubnetAddressPrefix
    AVDvnetAddressPrefix: AVDvnetAddressPrefix
  }
}

module infra 'avd-infra.bicep' = if (newBuild) {
  scope: RGAVDinfra
  name: 'infra deployment'
  params: {
    location: location
    tags: tags
    appGroupFriendlyName: appGroupFriendlyName
    galleryName: galleryName
    hostPoolFriendlyName: hostPoolFriendlyName
    hostPoolName: hostPoolName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    maxSessionLimit: maxSessionLimit
    personalDesktopAssignmentType: personalDesktopAssignmentType
    workspaceFriendlyName: workspaceFriendlyName
    workspaceName: workspaceName
  }
}
