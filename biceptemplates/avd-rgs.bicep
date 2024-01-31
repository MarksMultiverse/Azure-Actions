targetScope = 'subscription'

param location string = 'westeurope' 
param RGnameAVDinfra string
param RGnameAVDvms string

resource RGAVDinfra 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAVDinfra
  location: location
}

resource RGAVDvms 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: RGnameAVDvms
  location: location
}
