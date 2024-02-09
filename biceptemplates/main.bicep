targetScope = 'subscription'
param location string = 'westeurope'
param newBuild bool = true

param tags object = {
  Project: 'Automate-AVD-Github-Actions'
  Responsible: 'mark.tilleman@cegeka.com'
}

param RGnameAVDinfra string = 'RG01MARK'
param RGnameAVDvms string = 'RG02MARK'
param RGnameAVDimage string = 'RG03MARK'
param RGnameAIB string = 'RG04MARK'

// vnet parameters
param AVDnetworkname string = 'AVDnetwork'
param AVDvnetAddressPrefix string ='10.0.0.0/24'
param AVDsubnet1name string = 'AVDsunbet1'
param AVDsubnetAddressPrefix string = '10.0.0.0/24'
param AVDnsgName string = 'AVDnsg'

// infra parameters
param hostPoolType string = 'Pooled'
param hostPoolName string = 'testHP'
param personalDesktopAssignmentType string = 'Direct'
param maxSessionLimit int = 12
param loadBalancerType string = 'BreadthFirst'
param hostPoolFriendlyName string = 'testHP'
param workspaceName string = 'TEST-AVD-PROD'
param workspaceFriendlyName string = 'testWorkspace'
param appGroupFriendlyName string = 'testAP'
param galleryName string = 'testGallery'

// FSlogix parameters
@minLength(3)
@maxLength(24)
param saavdname string = 'saavdfslogixtesting' // only lowercase letters
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_LRS'
  'Standard_ZRS'
])
param saavdskuname string = 'Premium_LRS'
param saavdkind string = 'FileStorage'

/*
// image parameters
param utc string = utcNow('yyyy.MM.dd')
param imageDefinitionName string = 'testimagedef'
param imageOffer string = 'office-365'
param imagePublisher string = 'microsoftwindowsdesktop'
param imageSKU string = 'win11-23h2-avd-m365'
param imageOSstate string = 'Generalized'
param imageOStype string = 'Windows'

// sessionhosts parameters
param vmPrefix string = 'testpc'
param AVDnumberOfInstances int = 3
param currentInstances int = 0
param enableAcceleratedNetworking bool = true
param vmSize string = 'Standard_D2s_v3'
param adminUsername string = 'localadmin'
param vmDiskType string = 'Premium_LRS'
@secure()
param adminPassword string = 'Halloootjes124@'
*/

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

resource RGAVDimage 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAVDimage
  location: location
}

resource RGAVDimagebuild 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAIB
  location: location
  tags: tags
}

// import modules
module vnet 'avd-vnet.bicep' = if (newBuild) {
  scope: RGAVDinfra
  name: 'VNET-deployment'
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
  name: 'infra-deployment'
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

module role 'avd-aibrole.bicep' = {
  scope: RGAVDimage
  name: 'ID-and-role-deployment'
  params: {
    location: location
  }
}

/*
module fslogix 'avd-FSLogix.bicep' = if (newBuild) {
  scope:RGAVDinfra 
  name: 'FSlogix-deployment'
  params: {
    location: location
    saavdkind: saavdkind
    saavdname: saavdname
    saavdskuname: saavdskuname
  }
}

module image 'avd-image.bicep' = {
  scope: RGAVDinfra
  name: 'image-deployment'
  params: {
    location: location
    RGnameAIB: RGnameAIB
    galleryName: galleryName
    imageDefinitionName: imageDefinitionName
    imageOffer: imageOffer
    imageOSstate: imageOSstate
    imageOStype: imageOStype
    imagePublisher: imagePublisher
    imageSKU: imageSKU
    utc: utc
  }
}

module sessionhosts 'avd-sessionhosts.bicep' = {
  scope: RGAVDvms
  name: 'session-hosts-deployment'
  params: {
    AVDnumberOfInstances: AVDnumberOfInstances
    currentInstances: currentInstances
    adminPassword: adminPassword
    adminUsername: adminUsername
    enableAcceleratedNetworking: enableAcceleratedNetworking
    location: location
    tags: tags
    vmDiskType: vmDiskType
    vmPrefix: vmPrefix
    vmSize: vmSize
    subnetID: vnet.outputs.subnetId
  }
}
*/
