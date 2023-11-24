if (Get-Module -ListAvailable -name psmpacker | Where-Object { $_.version -eq "0.1.5.0" }){
    install-module -name psmpacker -repository powershell -MinimumVersion 0.1.5
}
import-module -name psmpacker -MinimumVersion 0.1.5

$AutoVersion = (Get-GitAutoVersion).Version
$modulename = "nupsforge"

# Remove-Item -Path .\dist\nupsforge -Recurse -Force -ErrorAction SilentlyContinue

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name $modulename `
             -IncrementVersion None `
             -FilesToCopy "nupsforge.psm1","nupsforge.psd1","LICENSE","icon.png" `
             -ExcludedFiles "Issue#1.txt" `
             -FoldersToCopy "libs" `
             -Manifest `
             -Version $AutoVersion