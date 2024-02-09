param location string
param galleryName string
param utc string

param azureImageBuilderName string = 'testimage'
param galleryImageName string = 'testGalleryImage'
param runOutputName string = 'Win11test'
param RGnameAIB string
param tags object


resource acg 'Microsoft.Compute/galleries@2022-08-03' existing = {
  name: galleryName
}

resource ign 'Microsoft.Compute/galleries/images@2022-08-03' = {
  name: galleryImageName
  location: location
  parent: acg
}

resource azureImageBuilder 'Microsoft.VirtualMachineImages/imageTemplates@2023-07-01' = {
  name: azureImageBuilderName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '<imgBuilderId>': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 30
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: ign.id
        runOutputName: runOutputName
      }
    ]
    source: {
      type: 'PlatformImage'
      publisher: 'microsoftwindowsdesktop'
      offer:'windows-11'
      sku: 'win11-23h2-avd'
      version:'latest'
    }
    stagingResourceGroup: RGnameAIB
    vmProfile: {
      vmSize: 'Standard_D2s_v3'
      osDiskSizeGB: 127
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'GetAZCopy'
        inline: [
          'New-Item -Type Directory -Path c:\\ -Name temp'
          'invoke-webrequest -uri https://aka.ms/downloadazcopy-v10-windows -OutFile c:\\temp\\azcopy.zip'
          'Expand-Archive c:\\temp\\azcopy.zip c:\\temp'
          'copy-item C:\\temp\\azcopy_windows_amd64_*\\azcopy.exe\\ -Destination c:\\temp'
        ]
      }
    ]
  }
}
