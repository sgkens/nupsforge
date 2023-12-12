# <img width="25" src="https://raw.githubusercontent.com/sgkens/resources/main/modules/nupsforge/dist/v1/nupsforge-logo-x128.png"/>  **NuPSForge**
### *PowerShell Module*

<!--license-->
<a href="https://github.com/sgkens/nupsforge/">
  <img src="https://img.shields.io/badge/MIT-License-blue?style=&logo=unlicense&color=%23004481"></a>
<!--Code Factor-->
<a href="https://www.codefactor.io/repository/github/sgkens/nupsforge/">
  <img src="https://www.codefactor.io/repository/github/sgkens/nupsforge/badge"></a>
<!--Choco-->
<a href="https://community.chocolatey.org/packages/davilion.nupsforge">
  <img src="https://img.shields.io/chocolatey/dt/davilion.nupsforge?label=Choco"></a>
<!--[psgallary]-->
<a href="https://www.powershellgallery.com/packages/nupsforge">
  <img src="https://img.shields.io/powershellgallery/dt/nupsforge?label=psgallary"></a>

NuPSForge help with the creation of `.nupkg` for powershell modules and scripts, for deployment to a nuget repositories, such as the **Powershell Gallary**,**Chocolatey**, **proget**, and **Gitlab|Github** Packages Repositories.


## 🟪 Cmdlets

#### 🔹**New-ChocoNuspecFile**

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-ChocoNuspecFile` outputs `$modulename.companyname.nuspec`

> NOTE!
> Extra properties are added to the `.nuspec` file, such as `projectSourceUrl`, `docsUrl`, `bugTrackerUrl`, `LicenseUrl`, `IconUrl`, `mailingListUrl`, `bugTrackerUrl`, `licenseUrl`, `projectSourceUrl`, `projectUrl`, `iconUrl`, `
> In the .psd1 manifest file there are added to $`ModuleManifest.PrivateData.PSData`

```powershell
$NuSpecParamsChoco = @{
  path             = .\dist\$ModuleName
  ModuleName       = $ModuleName
  ModuleVersion    = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author           = $ModuleManifest.Author
  Description      = $ModuleManifest.Description
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

# or ----------------------

New-ChocoNuspecFile -Path .\dist\$ModuleName `
                    -ModuleName $ModuleName `
                    -ModuleVersion $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.
                    -Author $ModuleManifest.Author `
                    -Description $ModuleManifest.Description `
                    -ProjectUrl $ModuleManifest.PrivateData.PSData.ProjectUri `
                    -IconUrl $ModuleManifest.PrivateData.PSData.IconUri `
                    -docsUrl $ModuleManifest.PrivateData.PSData.docsUri `
                    -projectSourceUrl $ModuleManifest.PrivateData.PSData.projectSourceUri `
                    -MailingListUrl $ModuleManifest.PrivateData.PSData.MailingListUri `
                    -bugTrackerUrl $ModuleManifest.PrivateData.PSData.BugTrackerUri `
                    -LicenseUrl $ModuleManifest.PrivateData.PSData.LicenseUri `
                    -ReleaseNotes $ModuleManifest.PrivateData.PSData.ReleaseNotes `
                    -License "MIT" `
                    -company $ModuleManifest.CompanyName `
                    -Tags $ModuleManifest.Tags `
                    -dependencies $ModuleManifest.ExternalModuleDependencies `
                    -LicenseAcceptance $false

```

#### 🔹New-NuspecPackageFile

Generating a **.nuspec** from a *ModuleManifest* file `Test-ModuleManifest -Path "Path"`, `New-NuspecPackageFile` outputs `$modulename.companyname.nuspec`

🧪 **Example**:

```powershell
$ModuleManifest = Test-ModuleManifest -Path "Path"
$NuSpecParams = @{
  path             = .\dist\ModuleName
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

New-NuspecPackageFile -Path "path/to/folder"

# or ----------------------

New-NuspecPackageFile -Path "Path" ` # [string]
                      -ModuleName "ModuleName" ` # [string]
                      -ModuleVersion "ModuleVersion" ` # [string]
                      -Author "Author" ` # [string]
                      -Description "Description" ` # [string]
                      -ProjectUrl "ProjectUrl" ` # [string]
                      -License "License" ` # [string]
                      -Company "company" ` # [string]
                      -Tags "Tags" ` # [string[]]
                      -Dependencies "dependencies" ` # [string[]]
                      -LicenseAcceptance $false

```

#### 🔹New-ChocoPackage

Create a **Chocolatey** nuget package from `.nuspec` file `New-ChocoPackage` looks for `rootfoldername.nuspec` file in your root directory.

> NOTE!
> nuget is not used for choco packages as choco extends the xml 2016 ***nuspec schema specifications*** running `nuget -build -pack .` will return and error as extra `nuspec.package.*` contains extra unsupported fields
> xmlns: <http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd>
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

## 🟪 Installation Methods

### 💾 Source

1. Clone the repository from GitHub `git clone https://github.com/sgkens/nupsforge.git` \
2. Open a *PowerShell* session and navigate to the cloned repository directory. \
3. **Run** the *Module Import* via the command below:

    ```powershell
    # Import the module
    git clone https://github.com/sgkens/nupsforge.git
    cd nupsforge
    Import-Module -Name nupsforge
    Get-Module -Name nupsforge

    # Check imported module functions
    Get-Module -Name nupsforge | Select-Object -expand ExportedFunctions
    Get-Module -Name nupsforge | select-object version
    ```

### 💼 Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/nupsforge/releases) page.

### 📦 Packages

[<img src="https://img.shields.io/powershellgallery/v/csverify?include_prereleases&style=for-the-badge&logo=powershell"/>](https://www.powershellgallery.com/packages/nupsforge) <img src="https://img.shields.io/powershellgallery/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install the module from the psgal
Install-Module -Name davilion.nupsforge -force

# Import module into you powershell session
Import-Module -Name davilion.nupsforge
```

> *Note!*  
> You may need to `Set-ExecutionPolicy` to `RemoteSigned` or `Unrestricted` to install from the PSGallary.

[<img src="https://img.shields.io/chocolatey/v/csverify?style=for-the-badge&logo=chocolatey"/>](https://Chocolatory.org/sgkens/commitfusion) <img src="https://img.shields.io/chocolatey/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install the module from the psgal
choco install davilion.nupsforge

# Import Module into you powershell session
Import-Module -Name nupsforge
```

> *How-to!* \
> Installing *Chocolatey* Package Repository
[**How to Install**](https)  [🧷https://chocolatey.org/install](https://chocolatey.org/install)

## 🟧 Requirements
🔹TadPal \
🔹LogTastic
