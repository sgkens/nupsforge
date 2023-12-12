using module ..\shelldock\New-ShellDock.psm1
Function New-ChocoPackage() {
    #create nupkg package from nuspec file
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$OutPath
    )
    try {
        $logo = Get-Content -Path '.\libs\icon-choco.txt' -raw
        [console]::Write("$logo`n")
        $rootpath = (Get-itemProperty -Path $Path).FullName
        $exportPath = (Get-itemProperty -Path $OutPath).FullName 
        
        # Check for nuspec file in root dir or check for more than one nuspec file in root dir
        if ((Get-ChildItem $Path -Filter "*.nuspec").count -eq 0 ) { throw [System.Exception] "No nuspec file found in $rootpath"; }
        elseif ((Get-ChildItem $Path -Filter "*.nuspec").count -gt 1 ) { throw [System.Exception] "More than one nuspec file found in $rootpath"; }
        
        if (!([xml]$nuspecfile = Get-Content -Path "$rootpath\*.nuspec")) {
            throw [System.Exception]::new("Failed to read nuspec file $rootpath\*.nuspec", "nuget.ex not function PATH System variable"); 

            break;
        }
        Write-LogTastic -Message "[{ct:magenta:nuget}]|-@{pt:{run=pack}} @{pt:{Package=$($nuspecfile.package.metadata.id)}} @{pt:{Version=$($nuspecfile.package.metadata.version)}}" `
                        -Name $global:LOGTASTIC_MOD_NAME `
                        -Type "action"
        Write-LogTastic -Message "Creating {ct:magenta:nupkg} package from {ct:magenta:nuspec} file" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage      
        Write-LogTastic -Message "Checking {ct:yellow:nuget} Package Manager" -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage
    }
    catch [System.Exception] {
        Write-LogTastic -Message "$($_.Exception.Message)" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -submessage
    }
    Write-LogTastic -Message "[{ct:green:Choco-Package-Creator}]" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -submessage
    $PackageName = "$($nuspecfile.package.metadata.id).$($nuspecfile.package.metadata.version).nupkg"
    # Compress-Archive -Path "$rootpath" `
    #                  -DestinationPath "$exportPath\$PackageName" `
    #                  -compressionlevel optimal `
    #                  -update `
    #                  -Verbose
    New-ShellDock -Ql -QLName $global:LOGTASTIC_MOD_NAME -ScriptBlock {
       return Compress-Archive -Path "$($args.rootpath)" `
                         -destinationpath "$($args.exportPath)\$($args.packagename)" `
                         -compressionlevel optimal `
                         -update `
                         -Verbose
       # return "SHELLDOCK ==> BUILD_SOURCE: $($args.rootpath) `n          ==> PACKAGE: $($args.exportPath)\dist\psgal\$($args.packagename)"
    } -Arguments (
        [PSObject]@{
            rootpath = $rootpath; 
            exportpath = $exportpath; 
            packagename = $packagename 
        }
    )

    # - TotalProcessorTime : 00:00:00.6250000
    # - id : 26036
    Write-LogTastic -Message "response -OutputDirectory $exportPath" -Name $global:LOGTASTIC_MOD_NAME -Type "Success" -Submessage
    Write-LogTastic -Message "Nupkg Package created" -Name $global:LOGTASTIC_MOD_NAME -Type "Success"
    Write-LogTastic -Message "@{pt:{package=$exportPath`\$PackageName}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete" -Submessage
    Write-LogTastic -Message "Complete" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete"

    [console]::("------------------------------------------- `n")
    [console]::("Chocolatey PackageName: $PackageName `n")
    [console]::("File Cound: $($nuspecfile.package.files.Count) `n")
    [console]::("Version: $($nuspecfile.package.version) `n")
    [console]::("-------------------------------------------")

}
Export-ModuleMember -Function New-ChocoPackage
