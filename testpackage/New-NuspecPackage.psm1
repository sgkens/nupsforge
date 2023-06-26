using module sm\quicklog\quicklog.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: New-NuspecPacakge Function
##   AUTHER------: snoonx | nytscripts
#?   DESCRIPTION-: Creates .nupkg package from .nuspec file and outputs to $outpath.  
*?   DEPENDANCIES: quicklog 
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
** ******************************************************************************************************#>
Function New-NupkgPacakge() {
    #create nupkg package from nuspec file
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootDir,
        [Parameter(Mandatory = $true)]
        [string]$Outdir
    )

    try {
        $rootpath = (Get-Item -Path $RootDir).FullName
        $OutPath = (Get-Item -Path $Outdir).FullName
        
        # Check for nuspec file in root dir or check for more than one nuspec file in root dir
        if ((Get-ChildItem $RootDir -Filter "*.nuspec").count -eq 0 ) { throw [System.Exception] "No nuspec file found in $rootpath"; }
        elseif ((Get-ChildItem $RootDir -Filter "*.nuspec").count -gt 1 ) { throw [System.Exception] "More than one nuspec file found in $rootpath"; }
        
        [xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec"
        Write-QLMessage -Message "Nupkg Packer > pack @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" -Name "bv" -Type "action"

        [xml]$nuspecfile = Get-Content -Path "$RootDir\*.nuspec"
        Write-QLMessage -Message "Creating ♦-nupkg package from ♦-nuspec file" -Name "bv" -Type "action" -Submessage      
        write-QlMessage -Message "Testing [nuget] Package Manager" -Name "bv" -Type "info" -Submessage


        $nuget = Get-Command -Name nuget -ErrorAction SilentlyContinue
        if ($nuget.source.length -eq 0) { 
            throw [System.Exception] "Nuget package manager not found @{pt:{DownloadFrom=https://www.nuget.org/downloads}}"; 
        }
        Write-QLMessage -Message "Found [nuget] @{pt:{path=$($nuget.source)}}" -Name "bv" -Type "Success" -Submessage
        
        Write-QLMessage -Message "Executing [nupkg]::pack package" -Name "bv" -Type "action"
        if (nuget pack $rootpath -OutputDirectory $OutPath) {
            Write-QLMessage -Message "nuget pack $rootpath -OutputDirectory $OutPath" -Name "bv" -Type "Success" -Submessage
        } 
        else { 
            throw [System.Exception] "Failed to create [nupkg] package"; 
        }
        Write-QLMessage -Message "Nupkg Package created" -Name "bv" -Type "Success"
        Write-QLMessage -Message "@{pt:{package=$OutPath`\$($nuspecfile.package.metadata.id)`.nupkg}}" -Name "bv" -Type "Complete" -Submessage
    }
    catch [System.Exception]{
        write-QlMessage -Message "$($_.Exception.Message)" -Name "bv" -Type "Error" -submessage
    }
}

New-NuspecPacakge -RootDir .\ -outdir .\