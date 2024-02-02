param location string = resourceGroup().location

param newBuild bool = true

// storage account parameter
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

// Creating storage account for FSLogix
resource saavd 'Microsoft.Storage/storageAccounts@2021-09-01' =  if (newBuild) {
  name: saavdname
  location: location
  sku: {
    name: saavdskuname
  }
  kind: saavdkind
}
