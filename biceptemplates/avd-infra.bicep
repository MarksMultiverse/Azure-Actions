param location string
param tags object
param hostPoolType string
param hostPoolName string
param personalDesktopAssignmentType string
param maxSessionLimit int
param loadBalancerType string
param hostPoolFriendlyName string
param workspaceName string
param workspaceFriendlyName string
param appGroupFriendlyName string
param galleryName string

var appGroupName = '${hostPoolName}-DAG'

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2023-11-01-preview' = {
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

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-11-01-preview' = {
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

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2023-11-01-preview' = {
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

resource acg 'Microsoft.Compute/galleries@2022-08-03' = {
  name: galleryName
  location: location
}
