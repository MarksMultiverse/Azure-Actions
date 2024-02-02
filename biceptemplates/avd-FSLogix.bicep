param location string
param saavdname string
param saavdskuname string
param saavdkind string

// Creating storage account for FSLogix
resource saavd 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: saavdname
  location: location
  sku: {
    name: saavdskuname
  }
  kind: saavdkind
}
