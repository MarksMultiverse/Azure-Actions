param location string
param tags object
@allowed([
  'Personal'
  'Pooled'
])
param hostPoolType string
param hostPoolName string
@allowed([
  'Automatic'
  'Direct'
])
param personalDesktopAssignmentType string
param maxSessionLimit int
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string
param hostPoolFriendlyName string
param workspaceName string
param workspaceFriendlyName string
param appGroupFriendlyName string
param galleryName string
param baseTime string = utcNow('u')

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
    registrationInfo: {
      expirationTime: dateTimeAdd(baseTime, 'P1D')
      registrationTokenOperation: 'Update'
    }
  }
}

// output hostpoolToken string = reference(hostPool.id, '2021-01-14-preview').registratioInfo.token

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
