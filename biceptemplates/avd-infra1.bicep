param location string = resourceGroup().location

param tags object = {

  Environment: 'Prod'
  Department: 'IT'
  Supportedby: 'Mark'
  Project: 'Automate-AVD-Github-Actions'
  Responsible: 'mark.tilleman@cegeka.com'
}

// param workspaceLocation string

@description('If true Host Pool, App Group and Workspace will be created. Default is to join Session Hosts to existing AVD environment')
param newBuild bool = false

@description('Expiration time for the HostPool registration token. This must be up to 30 days from todays date.')
// param tokenExpirationTime string

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

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2023-11-01-preview' = if (newBuild) {
  name: hostPoolName
  location: location
  tags: tags
  properties: {
    friendlyName: hostPoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: 'Desktop'
    personalDesktopAssignmentType: personalDesktopAssignmentType
    maxSessionLimit: maxSessionLimit
    validationEnvironment: false
    registrationInfo: {
      // expirationTime: tokenExpirationTime
      token: null
      registrationTokenOperation: 'Update'
    }
  }
}
