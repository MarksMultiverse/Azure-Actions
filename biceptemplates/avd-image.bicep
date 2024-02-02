param location string = resourceGroup().location
param galleryName string = 'testGallery'
param utc string = utcNow('yyyy.MM.dd')


param imageDefinitionName string = 'testimagedef'
param imageOffer string = 'office-365'
param imagePublisher string = 'microsoftwindowsdesktop'
param imageSKU string = 'win11-23h2-avd-m365'
param imageOSstate string = 'Generalized'
param imageOStype string = 'Windows'

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
