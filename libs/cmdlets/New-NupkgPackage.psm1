using module ..\shelldock\New-ShellDock.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: New-NupkgPackage Function
##   AUTHER------: snoonx | nytscripts
#?   DESCRIPTION-: Creates .nupkg package from .nuspec file and outputs to $outpath.  
*?   DEPENDANCIES: quicklog 
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
** ******************************************************************************************************#>
Function New-NupkgPackage() {
    #create nupkg package from nuspec file
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$OutPath
    )

    try {
        $rootpath = (Get-itemProperty -Path $Path).FullName
        $exportPath = (Get-itemProperty -Path $OutPath).FullName 
        
        # Check for nuspec file in root dir or check for more than one nuspec file in root dir
        if ((Get-ChildItem $Path -Filter "*.nuspec").count -eq 0 ) { throw [System.Exception] "No nuspec file found in $rootpath"; }
        elseif ((Get-ChildItem $Path -Filter "*.nuspec").count -gt 1 ) { throw [System.Exception] "More than one nuspec file found in $rootpath"; }
        
        if (!([xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec")) {
            throw [System.Exception]::new("Failed to read nuspec file $rootpath\*.nuspec", "nuget.ex not function PATH System variable"); 

            break;
        }
        Write-LogTastic -Message "[{ct:magenta:nuget}]|-@{pt:{run=pack}} @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" -Name "pmm" -Type "action"
        Write-LogTastic -Message "Creating {ct:magenta:nupkg} package from {ct:magenta:nuspec} file" -Name "pmm" -Type "action" -Submessage      
        Write-LogTastic -Message "Checking {ct:yellow:nuget} Package Manager" -Name "pmm" -Type "info" -Submessage


        $nuget = Get-Command -Name nuget -ErrorAction SilentlyContinue
        if ($nuget.source.length -eq 0) { 
            throw [System.Exception]::new("Nuget package manager not found @{pt:{DownloadFrom=https://www.nuget.org/downloads}}", "nuget.ex not function PATH System variable"); 
        }
        Write-LogTastic -Message "Done" -Name "pmm" -Type "complete" -Submessage
    }
    catch [System.Exception] {
        Write-LogTastic -Message "$($_.Exception.Message)" -Name "pmm" -Type "Error" -submessage
    }
    Write-LogTastic -Message "[{ct:green:PackPackage}]" -Name "pmm" -Type "action" -submessage

    New-ShellDock -Ql -ScriptBlock {
        nuget pack -build $args.rootpath -OutputDirectory $args.exportPath
    } -Arguments ([PSObject]@{rootpath = $rootpath; exportPath = $exportPath })

    # - TotalProcessorTime : 00:00:00.6250000
    # - id : 26036
    Write-LogTastic -Message "response -OutputDirectory $exportPath" -Name "pmm" -Type "Success" -Submessage
    Write-LogTastic -Message "Nupkg Package created" -Name "pmm" -Type "Success"
    Write-LogTastic -Message "@{pt:{package=$exportPath`\$($nuspecfile.package.metadata.id)`.nupkg}}" -Name "pmm" -Type "Complete" -Submessage
    Write-LogTastic -Message "Complete" -Name "pmm" -Type "Complete"
}
Export-ModuleMember -Function New-NupkgPackage
