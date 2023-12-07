# <img width="25" src="https://raw.githubusercontent.com/sgkens/resources/main/modules/nupsforge/dist/v1/nupsforge-icon-x128.png"/>  **NuPSForge** *PowerShell Module*

[TOC]

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
<a href="https://www.powershellgallery.com/packages/csverify">
  <img src="https://img.shields.io/powershellgallery/dt/nupsforge?label=psgallary"></a>

NuPSForge is a powershell module to help with the creation of .nupkg for powershell modules and scripts, for deployment to a nuget repositories, such as the **Powershell Gallary**,**Chocolatey**, **proget**, and **Gitlab|Github** Packages Repositories.


```powershell
#Default output .\tools\VERIFICATION.txt
cd /path/to/folder
New-VerificationFile 
```

## Installation Methods

### 💾 Source

1. Clone the repository from GitHub `git clone https://github.com/sgkens/nupsforge.git` \
2. Open a *PowerShell* session and navigate to the cloned repository directory. \
3. **Run** the *Module Import* via the command below:

```powershell
# Import the module
git clone https://github.com/sgkens/nupsforge.git
cd csverify
Import-Module -Name nupsforge
Get-Module -Name nupsforge

# Check imported Module Functions
Get-Module -Name nupsforge | Select-Object -expand ExportedFunctions
Get-Module -Name nupsforge | select-object version
```

### 💼 Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/nupsforge/releases) page.

### 📦 Packages

[<img src="https://img.shields.io/powershellgallery/v/csverify?include_prereleases&style=for-the-badge&logo=powershell"/>](https://www.powershellgallery.com/packages/nupsforge) <img src="https://img.shields.io/powershellgallery/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install The Module from the PsGal
Install-Module -Name csverify -force

# Import Module into you powershell session
Import-Module -Name csverify
```

> *Note!*  
> You may need to `Set-ExecutionPolicy` to `RemoteSigned` or `Unrestricted` to install from the PSGallary.

[<img src="https://img.shields.io/chocolatey/v/csverify?style=for-the-badge&logo=chocolatey"/>](https://Chocolatory.org/sgkens/commitfusion) <img src="https://img.shields.io/chocolatey/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install The Module from the PsGal
choco install davilion.csverify

# Import Module into you powershell session
Import-Module -Name csverify
```

> *How-to!* \
> Installing *Chocolatey* Package Repository
[**How to Install**](https)  [🧷https://chocolatey.org/install](https://chocolatey.org/install)

## Documentaiton

### CMDLETS

#### New-CheckSum

#### Read-CheckSum

#### New-VerificationFile

#### Test-Verification
