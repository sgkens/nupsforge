# --[ CONFIG ] 

$ModuleName           = "nupsforge"
$ProGet_chocInstance  = "https://proget.lab.davilion.online/nuget/Choco"
$ProGet_nugetInstace  = "https://proget.lab.davilion.online/nuget/nuget"
$ProGet_PSGalInstance = 'powershell'

# Output FileNames
$ModuleManifest       = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
$SemVerVersion        = $ModuleManifest.Version -replace "\.\d+$",""
$nupkgFileName        = "$($ModuleManifest.CompanyName).$ModuleName.$SemVerVersion.nupkg"
$zipFileName          = "$($ModuleName).zip"


# Force Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if($ModuleManifest){

  # Push to ProGet Chocolatey
  if(Get-command choco){
    [console]::write("Checking if Chocolatey is installed, skipping install`n")
    [console]::write("Pushing to chocolatey: .\dist\choco\$nupkgFileName`n")
    choco push ".\dist\choco\$nupkgFileName" --source $ProGet_chocInstance --apikey $ENV:PROGET_API_KEY
    [console]::write("Pushed to chocolatey $nupkgFileName - Complete`n")
  }
  else{
    [console]::write("Chocolatey is not installed, installing Chocolatey`n")
    break;
  }

  # Push to ProGet Nuget
  if(Get-command nuget.exe){
    [console]::write("Checking if Nuget is installed, skipping install`n")
    [console]::write("Pushing to Nuget: .\dist\nuget\$nupkgFileName `n")
    nuget push ".\dist\nuget\$nupkgFileName" -source $ProGet_nugetInstace -apikey $ENV:PROGET_API_KEY
    [console]::write("Pushed to Nuget $nupkgFileName - Complete")
  }
  else{
          [console]::write("Nuget is not installed, installing Nuget`n")
    break;
  }
  # # Push to ProGet PSGallery
  [console]::write("Pushing to Powershell-Nuget-Proget: .\dist\psgal\$zipFileName`n")

  # puish to proget pscore repo 'powershell gallery'
  # Publish-Module -Path ".\dist\$zipFileName" -Repository pscore -NuGetApiKey $apikey
  # Example of trusting the certificate (not recommended for production)
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
  # Register-PSRepository -name 'pscore_Local_instance' `
  #                       -SourceLocation "https://proget.lab.davilion.online/nuget/pscore/" `
  #                       -PublishLocation (New-Object -TypeName Uri -ArgumentList "https://proget.lab.davilion.online/nuget/pscore/", 'package/').AbsoluteUri `
  #                       -InstallationPolicy "Trusted"
  
  publish-Module `
    -path ".\dist\$ModuleName" `
    -Repository $ProGet_PSGalInstance `
    -NuGetApiKey $ENV:PROGET_API_KEY `
    -projecturi $ModuleManifest.PrivateData.PSData.ProjectUrl `
    -licenseuri $ModuleManifest.PrivateData.PSData.LicenseUrL `
    -IconUri 'https://raw.githubusercontent.com/sgkens/resources/main/modules/nupsforge/dist/v1/nupsforge-logo-x128.png' `
    -ReleaseNotes $ModuleManifest.ReleaseNotes `
    -Tags $ModuleManifest.Tags `
    -Verbose
    # Unregister-PSRepository -Name 'pscore_Local_instance'
}



