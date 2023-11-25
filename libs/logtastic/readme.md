

<div align="center" >
    <img width="250" src="https://gitlab.snowlab.tk/sgkens/resources/-/raw/4a6f5e8e8d9b2b7a240fe7c87c35776957a737f2/modules/logtastic/logtastic-logo-v2-title-inline-512x97.png"/>
</div>
<div align="center">
  <!--Name+Version-->
  <a href="https://github.com/sgkens">
    <img src="https://img.shields.io/badge//-sgkens-orange?&stype=flat&logo=Personio&logoColor=blue">
  </a>
  <!--License-->
  <a href="https://github.com/sgkens/logtastic/">
    <img src="https://img.shields.io/badge/MIT-License-blue?style=&logo=unlicense&color=%23004481">
  </a>
  <!--Code Coverage-->
  <a href="https://gitlab.snowlab.tk/powershell/ccommits/-/commits/main">
    <img src="https://gitlab.snowlab.tk/powershell/ccommits/badgesmain/coverage.svg">
  </a>
  <!--Release-->
  <a href="https://gitlab.snowlab.tk/powershell/logtastic/-/releases">
    <img src="https://gitlab.snowlab.tk/powershell/logtastic/-/badges/release.svg">
  </a>
</div>

<div style="font-weight:bold;" align="center" >
  <img width="14" src="https://gitlab.snowlab.tk/sgkens/resources/-/raw/main/modules/logtastic/dist/Generic-powershell-24x23.png">
   MODULE <br>
  <!--Pipline-->
  <a href="https://gitlab.snowlab.tk/powershell/logtastic">
    <img src="https://img.shields.io/gitlab/pipeline-status/powershell%2Flogtastic?gitlab_url=https%3A%2F%2Fgitlab.snowlab.tk&branch=main&logo=gitlab&label=build
">
  </a>
</div>

<!--Separator-->
<div align="center" >
    <img src="https://gitlab.snowlab.tk/sgkens/resources/-/raw/2d832bc7381b144e97555ba96dbb8aad8e6ccb62/modules/llline_v2-800x53.svg">
</div>

LogTastic is a PowerShell Module that outputs styled log messages to the console. It is designed to be used in conjunction with other PowerShell modules and scripts to provide a consistent look and feel to the console output.

# 🧩 Module Features
 🪶 *Enable*/*Disable* log name in log message template, Distinguish between running scripts \
 🪶  *Enable*/*Disable* time/date in log message `[🐽-ltm⌚01:43:34]...` \
 🪶  *Enable*/*Disable* custom utf-8 Unicode Icon Log name `[🐽-ltm]...` \
 🪶  *Inject* utf-8 Unicode Emojis into log messages with `#` > `{ge:#unicode}` \
 🪶  *Inject* colored text [***powershell color palet***] into log message with `{ct:colorName:texts}`  \
 🪶  *Inject* Property Names And Value into log message via `@{pt:{Name=Value}}`  \
 🪶  *Switch* outputs between `Parent` and `SubMessages` types \
 🪶  *Ouput* Basic Progress Bars `[########>------------------>(25mb/sec | 6.88% Complete)]` \
 🪶  *Ouput* Custom Progress Bars  with [`Tadpol`]() \
 🪶  *Output* Colors Loaders with [`Tradel`]()

# Install Module
### 💼 Clone source

🔹 Clone the repository from GitHub \
🔹 Open a PowerShell(pwsh) session and navigate to the cloned repository directory. \
🔹 Run the installation via the command below: 
### 💼 Release

```powershell
# Import the module
git clone https://gitlab.snowlab.tk/shelltastic/LogTastic.git
cd LogTastic
Import-Module -Name logtastic
```
### Package Repository
<img src="https://img.shields.io/badge/PSGallary-v0.1.0-yellow?style=for-the-badge&logo=Powershell&labelColor=blue&color=gray"/>

📦[psgallary.com/sgkens/shelltastic.LogTastic]()


```Powershell
# Install The Module from the PsGal
Install-Module -Name logtastic -MinimumVersion 0.1.0

# Import Module into you powershell session
Import-Module -Name logtastic

# Note! You May Need to change your `ExecutionPolicy`
# Set-ExecutionPolicy
```
<img src="https://img.shields.io/badge/Choco-v0.1.0-yellow?style=for-the-badge&logo=Chocolatey&labelColor=darkmagenta&color=gray"/>

📦[Chocolatory.org/sgkens/shelltastic.LogTastic]()
```Powershell
# Install The Module from the PsGal
choco install logtastic --version 0.1.0

# Import Module into you powershell session
Import-Module -Name logtastic
```

> Installing Chocolate Package Repositoy
[How to Install Choloc](https) `choco.com/packages`

# 🔧 Using the Module
> NOTE! - Colors are not shown correctly or will vary depending on your shell color pallet, ad. gif maker doesnt know powershell syntax
<div align="center">
  <img src="https://gitlab.snowlab.tk/sgkens/resources/-/raw/main/modules/logtastic/terminal-gifs/shelltastic-terminal-gif.gif">
</div>

### Examplea - Minimum Parameters
```Powershell
# Import Module
Import-Module -Name LogTastic

# Minimal Params
Write-LTMessage -Name 'LT' -Message "My Message String" -Type info -Unicode "#jahfu"

# All Params
Write-LTMessage -Message "LTM Message with a type:Action" -Name "ltm" -Type Action
# Ouput
PS > '[🐽-ltm⏰01:43:34]🌟❱ LTM Message with a type:Action  a-ex: 0m 0s 71Ms'

# SubMessage
Write-LTMessage -Name 'LT' -Message "My Message String" -Type info -Unicode "#jahfu"
```

### Parameter List `Write-LTMessage`
```powershell
Write-LTMessage
  [[alias -n]-Name [String]] # Optional
  [[alias -m]-Message [String]] # Manditory
  [[alias -t]-Type [String][Action|Info|Success|Complete|Error]] # Optional Default info
  [[alias -uc]-UniCode [String]"#code"] # Optional Default 'ltm' eg. [🐽-ltm⏰00:00:00]🌟❱
  [[alias -sm ]-SubMessage [Switch]]# Default $false adds indentation and removes execution time
  [[alias -ndt]-NoDatTime [Switch]] # Default $false eg. [🐽-ltm]🌟❱
  [[alias -nli]-NoLogIcon [Switch]] # Default $false eg. [ltm]🌟❱
```

## Short hand via alias 
> If you prefer 

```Powershell
# Write-LTMessage info short hand - Custom name and emoji
ltm -m "My Message String" -n ltm -t info -uc "#jahfu" 
# Write-LTMessage info short hand - no log date and no emoji icon
ltm -m "My Message String" -n ltm -t info -uc "#jahfu" -dtd -d
# Write-LTMessage - Minium params
ltm "My Message String" # 
```


# 📑 License
 **LogTastic** is released under the **MIT License**. See [LICENSE]() for more details.

👤 Authored and maintained by *G K. Snow* @sgkens ShellTestic. 


# 📌 Changelog

## feat: add updated to loda
aftesttsa;lkfasf


## feat: add updated to loda
