param location string
param baseTime string = utcNow()

var aibIDName = 'AIB ${baseTime}'
var roleDefName = 'Azure Image Builder Def ${baseTime}'

// Create a user assigned identity
resource aibId 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: aibIDName
  location: location
}

// Create a custom role
resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
  name: roleDefName
  properties: {
    roleName: 'Azure Image Builder Service Image Creation Role'
    description: 'Image Builder access to create resources for the image build'
    type: 'customRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/images/delete'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: 'AIB role assignment'
  properties: {
    principalId: aibId.id
    roleDefinitionId: roleDef.id
  }
}
