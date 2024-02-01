param location string = resourceGroup().location
param galleryName string = 'testGallery'


param imageDefinitionName string = 'testimagedef'

resource acg 'Microsoft.Compute/galleries@2022-08-03' existing = {
  name: galleryName
}

resource galleryDefinition 'Microsoft.Compute/galleries/images@2022-08-03' = {
  name: imageDefinitionName
  parent: acg
  location: location
  properties: {
    identifier: {
      offer: 
      publisher: 
      sku: 
    }
    osState: 
    osType: 
  }
}
