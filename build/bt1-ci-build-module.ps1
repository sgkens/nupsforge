Find-Module -Repository powershell -Name 'nupsforge' -MinimumVersion 0.2.1 | Install-module | Import-Module

$AutoVersion = (Get-GitAutoVersion).Version
$modulename = "nupsforge"

# Remove-Item -Path .\dist\nupsforge -Recurse -Force -ErrorAction SilentlyContinue

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name $modulename `
             -IncrementVersion None `
             -FilesToCopy "nupsforge.psm1","nupsforge.psd1","LICENSE","icon.png", 'readme.md' `
             -ExcludedFiles "Issue#1.txt" `
             -FoldersToCopy "libs" `
             -Manifest `
             -Version $AutoVersion