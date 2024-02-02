param location string
param galleryName string
param utc string
param imageDefinitionName string
param imageOffer string
param imagePublisher string
param imageSKU string
param imageOSstate string
param imageOStype string

var versionName = utc

resource acg 'Microsoft.Compute/galleries@2022-08-03' existing = {
  name: galleryName
}

resource galleryDefinition 'Microsoft.Compute/galleries/images@2022-08-03' = {
  name: imageDefinitionName
  parent: acg
  location: location
  properties: {
    identifier: {
      offer: imageOffer
      publisher: imagePublisher
      sku: imageSKU
    }
    osState: imageOSstate
    osType: imageOStype
  }
}

resource imageVersion 'Microsoft.Compute/galleries/images/versions@2022-08-03' = {
  name:  '${galleryName}/${imageDefinitionName}/${versionName}'
  location: location
}
