using module ..\..\quicklog\quicklog.psm1
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
        
        if(!([xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec")){
            throw [System.Exception]::new("Failed to read nuspec file $rootpath\*.nuspec","nuget.ex not function PATH System variable"); 

            break;
        }
        Write-QLMessage -Message "[{ct:magenta:nuget}]|-@{pt:{run=pack}} @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" -Name "pmm" -Type "action"
        Write-QLMessage -Message "Creating {ct:magenta:nupkg} package from {ct:magenta:nuspec} file" -Name "pmm" -Type "action" -Submessage      
        write-QlMessage -Message "Checking {ct:yellow:nuget} Package Manager" -Name "pmm" -Type "info" -Submessage


        $nuget = Get-Command -Name nuget -ErrorAction SilentlyContinue
        if ($nuget.source.length -eq 0) { 
            throw [System.Exception]::new("Nuget package manager not found @{pt:{DownloadFrom=https://www.nuget.org/downloads}}","nuget.ex not function PATH System variable"); 
        }
        Write-QLMessage -Message "Done" -Name "pmm" -Type "complete" -Submessage
    }
    catch [System.Exception]{
        write-QlMessage -Message "$($_.Exception.Message)" -Name "pmm" -Type "Error" -submessage
    }
    Write-QLMessage -Message "[{ct:green:PackPackage}]" -Name "pmm" -Type "action" -submessage
    [string]$rso = " "
    [string]$rse = " "
    $nuget_process = Start-Process  -FilePath $nuget.source `
                                    -ArgumentList "pack -build $rootpath -OutputDirectory $exportPath" `
                                    -Wait `
                                    -NoNewWindow `
                                    -PassThru `
                                    -RedirectStandardOutput $rso `
                                    -RedirectStandardError $rse
    #$nuget_process
    # $response
    #$response | FL *
    # - TotalProcessorTime : 00:00:00.6250000
    # - id : 26036
    Write-QLMessage -Message "response -OutputDirectory $exportPath" -Name "pmm" -Type "Success" -Submessage
    Write-QLMessage -Message "Nupkg Package created" -Name "pmm" -Type "Success"
    Write-QLMessage -Message "@{pt:{package=$exportPath`\$($nuspecfile.package.metadata.id)`.nupkg}}" -Name "pmm" -Type "Complete" -Submessage
    Write-QLMessage -Message "Complete" -Name "pmm" -Type "Complete"
}