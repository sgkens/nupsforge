<#
* Root module for NuPSForge
#>
using module libs\cmdlets\New-NuspecPackageFile.psm1
using module libs\cmdlets\New-ChocoNuspecFile.psm1
using module libs\cmdlets\New-ChocoPackage.psm1
using module libs\cmdlets\New-NupkgPackage.psm1

$Global:LOGTASTIC_MOD_NAME = 'forge'

<#
* Exported Functions Object -> array 
#>
$ExportedFunctions = @{
    function = @(
        'New-NuspecPackageFile',
        'New-NupkgPackage',
        'New-ChocoPackage',
        'New-ChocoNuspecFile'
    )
}
<#
* Exported Functions
#>
Export-ModuleMember @ExportedFunctions