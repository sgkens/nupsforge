using module .\New-NuspecPacakgeFile.psm1
using module .\New-NupkgPacakge.psm1

# New-NuspecPacakgeFile   -ModuleName "NupkgPacakge" `
#                         -ModuleVersion "0.0.1" `
#                         -Author "Snoonx" `
#                         -path .\testpackage `
#                         -Description "Powershell Module use to build NupkgPacakges" `
#                         -ProjectUrl "https://github.com/snoonx/projects/NupkgPacakge" `
#                         -License "MIT" `
#                         -company "SimpleScripts" `
#                         -Tags "PowerShell, Module, automation, nupkg, build" `
#                         -dependencies @{id="bitstransfer";version="1.2.3"},@{id="quicklog";version="1.2.3"}`

New-NupkgPacakge -path .\  -outpath .\dist