import-module -name .\

# ? Powershell Gallery Description Does not support markdown indenting
# ? But Nuget and Choco Does
$Additional_descriptions = @"

NuPSForge is a powershell module to help with the creation of .nupkg for powershell modules and scripts, for deployment to a nuget repositories, such as nuget,psgalleryand chocolatory

### Features
 - Generate .nuspec file from a list of parameters
 - Create a .nupkg file from .nuspec

### Example 1

### Example 2

"@

# --Config--
$ModuleName = "nupsforge"
$ModuleManifest = Test-ModuleManifest -path .\dist\nupsforge\nupsforge.psd1
# --Config--
if (!(Test-Path -path .\dist\nuget)) { mkdir .\dist\nuget }
if (!(Test-Path -path .\dist\choco)) { mkdir .\dist\choco }
if (!(Test-Path -path .\dist\psgal)) { mkdir .\dist\psgal}
$NuSpecParams = @{
  path             = ".\dist\$ModuleName"
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = "$($ModuleManifest.Description)`n`n$Additional_descriptions"
  ProjectUrl       = $ModuleManifest.PrivateData.PSData.ProjectUri
  License          = "MIT"
  company          = $ModuleManifest.CompanyName
  Tags             = $ModuleManifest.Tags
  dependencies     = $ModuleManifest.ExternalModuleDependencies
  LicenseAcceptance = $false
}
# NuGet- Proget/GitlabSE
New-NuspecPackageFile @NuSpecParams
Start-sleep -Seconds 1 # Wait for file to be created
New-NupkgPackage -path .\dist\$ModuleName  -outpath .\dist\nuget

$NuSpecParamsChoco = @{
  path             = ".\dist\$ModuleName"
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = "$($ModuleManifest.Description)"
  ProjectUrl       = $ModuleManifest.PrivateData.PSData.ProjectUri
  IconUrl          = "https://cdn.rawgit.com/nupsgal/nupsforge/master/images/nupsforge.png"
  docsUrl          = $ModuleManifest.PrivateData.PSData.docsUri
  projectSourceUrl = $ModuleManifest.PrivateData.PSData.projectSourceUri 
  MailingListUrl   = $ModuleManifest.PrivateData.PSData.MailingListUri
  bugTrackerUrl    = $ModuleManifest.PrivateData.PSData.BugTrackerUri
  LicenseUrl       = $ModuleManifest.PrivateData.PSData.LicenseUri
  ReleaseNotes     = $ModuleManifest.PrivateData.PSData.ReleaseNotes
  License          = "MIT"
  company          = $ModuleManifest.CompanyName
  Tags             = $ModuleManifest.Tags
  dependencies     = $ModuleManifest.ExternalModuleDependencies
  LicenseAcceptance = $false
}

# Chocolatey Supports markdown in the description field so create a new nuspec file with additional descriptions in markdown
New-ChocoNuspecFile @NuSpecParamsChoco
Start-sleep -Seconds 1 # Wait for file to be created
New-ChocoPackage -path .\dist\$ModuleName  -outpath .\dist\choco


# Create Zip With .nuspec file for PSGallery
write-host -foregroundColor Yellow "Creating Zip File for PSGallery"
$zipFileName = "$($NuSpecParams.ModuleName).zip"
compress-archive -path .\dist\$ModuleName\* -destinationpath .\dist\psgal\$zipFileName -compressionlevel optimal -update