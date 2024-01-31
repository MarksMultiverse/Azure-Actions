targetScope = 'subscription'

param location string = 'westeurope' 
param RGnameAVDinfra string = 'RG01MARK'
param RGnameAVDvms string = 'RG02MARK'
param tags object = {
  Project: 'Automate-AVD-Github-Actions'
  Responsible: 'mark.tilleman@cegeka.com'
}

resource RGAVDinfra 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAVDinfra
  location: location
  tags: tags
}

resource RGAVDvms 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAVDvms
  location: location
  tags: tags
}
