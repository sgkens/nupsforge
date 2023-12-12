import-module -name .\

# ? Powershell Gallery Description Does not support markdown indenting
# ? But Nuget and Choco Does
$Additional_descriptions = @'
## 🟪 Cmdlets

#### 🔹**New-ChocoNuspecFile**

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-ChocoNuspecFile` outputs `$modulename.companyname.nuspec`

> NOTE!
> Extra properties are added to the `.nuspec` file, such as `projectSourceUrl`, `docsUrl`, `bugTrackerUrl`, `LicenseUrl`, `IconUrl`, `mailingListUrl`, `bugTrackerUrl`, `licenseUrl`, `projectSourceUrl`, `projectUrl`, `iconUrl`
> In the .psd1 manifest file there are added to $`ModuleManifest.PrivateData.PSData`

🧪 **Example**:

```powershell
New-ChocoNuspecFile -Path .\dist\$ModuleName
                    -ModuleName $ModuleName
                    -ModuleVersion $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.
                    -Author $ModuleManifest.Author
                    -Description $ModuleManifest.Description
                    -ProjectUrl $ModuleManifest.PrivateData.PSData.ProjectUri
                    -IconUrl $ModuleManifest.PrivateData.PSData.IconUri
                    -docsUrl $ModuleManifest.PrivateData.PSData.docsUri
                    -projectSourceUrl $ModuleManifest.PrivateData.PSData.projectSourceUri
                    -MailingListUrl $ModuleManifest.PrivateData.PSData.MailingListUri
                    -bugTrackerUrl $ModuleManifest.PrivateData.PSData.BugTrackerUri
                    -LicenseUrl $ModuleManifest.PrivateData.PSData.LicenseUri
                    -ReleaseNotes $ModuleManifest.PrivateData.PSData.ReleaseNotes
                    -License "MIT"
                    -company $ModuleManifest.CompanyName
                    -Tags $ModuleManifest.Tags
                    -dependencies $ModuleManifest.ExternalModuleDependencies
                    -LicenseAcceptance $false

```

#### 🔹New-NuspecPackageFile

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-NuspecPackageFile` outputs `$modulename.companyname.nuspec`

🧪 **Example**:

```powershell
New-NuspecPackageFile -Path "Path" 
                      -ModuleName "ModuleName"
                      -ModuleVersion "ModuleVersion"
                      -Author "Author"
                      -Description "Description"
                      -ProjectUrl "ProjectUrl"
                      -License "License"
                      -Company "company"
                      -Tags "Tags1","tags2
                      -Dependencies "dependency1","dependency2
                      -LicenseAcceptance $false

```

#### 🔹New-ChocoPackage

Create a **Chocolatey** nuget package from `.nuspec` file `New-ChocoPackage` looks for `rootfoldername.nuspec` file in your root directory.

> NOTE!
> nuget is not used for choco packages as choco extends the xml 2016 ***nuspec schema specifications*** running `nuget -build -pack .` will return and error as extra `nuspec.package.*` contains extra unsupported fields
> xmlns schema: http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd
> `Compress-Archive` is used to output .nupkg

🧪 **Example**:

```powershell
New-ChocoPackage -path .\dist\ModuleName  -outpath .\dist\choco
```

#### 🔹New-NupkgPackage
Create an nuget package from `.nuspec` file `New-NupkgPackage` looks for `rootfoldername.nuspec` file in your root directory.

> NOTE!
> `New-NupkgPackage` using nuget.exe to create the package, nuget.exe is required to be installed on your system.
> `runs nuget -build -pack .`

```powershell
New-NupkgPackage -path .\dist\ModuleName  -outpath .\dist\nuget
```
TODO:
- [ ] Add support for `New-NupkgPackage` to use `Compress-Archive` instead of `nuget.exe`
'@

# --Config--
$ModuleName = "nupsforge"
$ModuleManifest = Test-ModuleManifest -path .\dist\nupsforge\nupsforge.psd1
# --Config--

if (!(Test-Path -path .\dist\nuget)) { mkdir .\dist\nuget }
if (!(Test-Path -path .\dist\choco)) { mkdir .\dist\choco }
if (!(Test-Path -path .\dist\psgal)) { mkdir .\dist\psgal }

$NuSpecParams = @{
  path             = ".\dist\$ModuleName"
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = $Additional_descriptions -replace '```','```' -replace '\`','``'
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

# Chocolatey Supports markdown in the description field so create a new nuspec file with additional descriptions in markdown
$NuSpecParamsChoco = @{
  path             = ".\dist\$ModuleName"
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = $Additional_descriptions -replace '```','```' -replace '\`','``'
  ProjectUrl       = $ModuleManifest.PrivateData.PSData.ProjectUri
  IconUrl          = $ModuleManifest.PrivateData.PSData.IconUri
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
New-ChocoNuspecFile @NuSpecParamsChoco
Start-sleep -Seconds 1 # Wait for file to be created
New-ChocoPackage -path .\dist\$ModuleName  -outpath .\dist\choco


# Create Zip With .nuspec file for PSGallery
[console]::write( "Creating Zip File for PSGallery `n" )
[console]::write( "Source: .\dist\$ModuleName\* `n" )
[console]::write( "output: .\dist\psgal\$zipFileName `n" )
$zipFileName = "$($NuSpecParams.ModuleName).zip"
compress-archive -path .\dist\$ModuleName\* -destinationpath .\dist\psgal\$zipFileName -compressionlevel optimal -update