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
param newBuild bool = true

@description('Expiration time for the HostPool registration token. This must be up to 30 days from todays date.')
param tokenExpirationTime string = '2024-02-01T14:36:44.081Z'

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

// @description('Custom RDP properties to be applied to the AVD Host Pool.')
// param customRdpProperty string

@description('Friendly Name of the Host Pool, this is visible via the AVD client')
param hostPoolFriendlyName string = 'testHP'

@description('Name of the AVD Workspace to used for this deployment')
param workspaceName string = 'ABRI-AVD-PROD'
param appGroupFriendlyName string = 'testAP'

// @description('Log Analytics workspace ID to join AVD to.')
// param logworkspaceID string
// param logworkspaceSub string
// param logworkspaceResourceGroup string
// param logworkspaceName string

@description('List of application group resource IDs to be added to Workspace. MUST add existing ones!')
// param applicationGroupReferences string

var appGroupName = '${hostPoolName}-DAG'
// var appGroupResourceID = array(resourceId('Microsoft.DesktopVirtualization/applicationgroups/', appGroupName))
// var applicationGroupReferencesArr = applicationGroupReferences == '' ? appGroupResourceID : concat(split(applicationGroupReferences, ','), appGroupResourceID)

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
  }
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-11-01-preview' = if (newBuild) {
  name: appGroupName
  location: location
  tags: tags
  properties: {
    friendlyName: appGroupFriendlyName
    applicationGroupType: 'Desktop'
    hostPoolArmPath: resourceId('Microsoft.DesktopVirtualization/hostpools', hostPoolName)
    description: 'Deskop Application Group created through GitHub Actions.'
  }
  dependsOn: [
    hostPool
  ]
}

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2023-11-01-preview' = if (newBuild) {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    // applicationGroupReferences: applicationGroupReferencesArr
  }
  dependsOn: [
    applicationGroup
  ]

}
