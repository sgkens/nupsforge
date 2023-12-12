using module ..\shelldock\New-ShellDock.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: New-NuspecPackageFile Function
##   AUTHER------: snoonx | psshellstack
#?   DESCRIPTION-: Creates a new nuspec manifest file for powershell module/nuspec package.      
*?   DEPENDANCIES: quicklog
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT 
** ******************************************************************************************************#>
function New-NuspecPackageFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$ModuleVersion,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$path,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Author,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [string]$ProjectUrl,
        [Parameter(Mandatory = $false)]
        [string]$License,
        [Parameter(Mandatory = $false)]
        [string]$Tags,
        [Parameter(Mandatory = $false)]
        [string]$company,
        [Parameter(Mandatory = $false)]
        [array]$dependencies,
        [Parameter(Mandatory = $false)]
        [switch]$LicenseAcceptance,
        [Parameter(Mandatory = $false)]
        [string]$releasenotes
    )

    Write-LogTastic -Message "Generating @{pt:{module=$ModuleName}} @{pt:{package=$company`.$ModuleName`.$ModuleVersion.nupkg}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
    try {
        if($LicenseAcceptance){ $Acceptance = "true" } else { $Acceptance = "false" }
        # XML Here-String .nuspec file template for powershell modules 
        # for a nuget package.
        [xml]$nuspec = @"
<?xml version="1.0"?>
<package>
  <metadata>
    <!-- Identifier that must be unique within the hosting gallery -->
    <id>$company`.$ModuleName</id>
    <!-- Package version number that is used when resolving dependencies -->
    <version>$ModuleVersion</version>
    <!-- Authors contain text that appears directly on the gallery -->
    <authors>$Author</authors>
    <!-- Owners are typically nuget.org identities that allow gallery users to easily find other packages by the same owners.  a-->
    <owners>$Author</owners>
    <!-- The description can be used in package manager UI. Note that thenuget.org gallery uses information you add in the portal. -->
    <description>$Description.</description>
    <!-- Project URL provides a link for the gallery -->
    <projectUrl>$ProjectUrl</projectUrl>
    <!-- License information is displayed on the gallery -->
    <license type="expression">$License</license>
    <!-- Tags appear in the gallery and can be used for tag searches -->
    <tags>$Tags</tags>
    <!-- Icon is used in Visual Studio's package manager UI -->
    <icon>icon.png</icon>
    <!-- If true, this value prompts the user to accept the license wheninstalling the package. -->   
    <requireLicenseAcceptance>$Acceptance</requireLicenseAcceptance>
    <!-- Any details about this particular release -->
    <releaseNotes>$releasenotes</releaseNotes>
    <!-- Copyright information -->
    <copyright>Copyright ©$((get-date | select-object year).year) $company / $Author</copyright>
    <!-- Dependencies are automatically installed when the package is installed -->
    <dependencies>
    </dependencies>
  </metadata>
  <!-- Files included in the manifiest and relative path -->
  <files>
  </files>
</package>
"@
        Write-LogTastic -Message "Done" -Name $global:LOGTASTIC_MOD_NAME -Type "success" -submessage
    }
    catch [System.Exception] {
        Write-LogTastic -Message "[NuspecPackageFile] Template Create Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
    }
    Write-LogTastic -Message "File Manifest" -Name $global:LOGTASTIC_MOD_NAME -Type "Info"
    Write-LogTastic -Message "Adding files @{pt:{xmlNodePath=nuspec.package.files.file}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage
    #! check for readme.txt and icon.png 
    # Update and add all files to the manifest
    try {
        Write-LogTastic -Message "Getting file properties" -Name $global:LOGTASTIC_MOD_NAME -Type "Info" -Submessage
        $DirectoryProperty = Get-itemProperty -Path $path
    }
    catch [System.Exception] {
        Write-LogTastic -Message "Get-ItemProperty Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
        return
    }

    Get-Childitem -path $DirectoryProperty.FullName -Recurse | foreach-object {
        if ($_.PSIsContainer -eq $false) {
            
            # https://learn.microsoft.com/en-us/nuget/reference/errors-and-warnings/nu5019
            $RelativePath = $_.fullname.Replace($DirectoryProperty.FullName, "").TrimStart("\")
            try {
                # replace souce path with empty string to get relative path 
                if ($_.name -match "(i|I)(con).png") {
                    Write-LogTastic -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                }
                elseif ($_.name -match "(r|R)(eadme|EADNE).md") {
                    Write-LogTastic -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)                  
                }
                else {
                    Write-LogTastic -Message "@{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # Add files to the manifest in root path
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                }
                # Append the new <file> element to the <files> node
                $nuspec.SelectSingleNode("//files").AppendChild($fileElement) | Out-Null
            }
            catch [System.Exception] {
                Write-LogTastic -Message "Get-ItemProperty Failed Error: $($_.Exception.Message) " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
                #break;
            }
        }
    }
    Write-LogTastic -Message "Finished." -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
    
    # Add dependancies to the manifest
    # xmlnode nuspec.package.metadata.dependencies.dependency
    if ($dependencies.Count -ne 0) {
        try {
            Write-LogTastic -Message "Adding dependancies to manifest @{pt:{xmlNodePath=nuspec.package.metadata.dependencies.dependency}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
            foreach ($dependency in $dependencies) {
                Write-LogTastic -Message "Dependency > @{pt:{Name=$($dependency.id)}} @{pt:{Version=$($dependency.version)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Action" -Submessage
                $dependencyElement = $nuspec.CreateElement("dependency")
                $dependencyElement.SetAttribute("id", $dependency.id)
                $dependencyElement.SetAttribute("version", $dependency.version)
                $nuspec.SelectSingleNode("//dependencies").AppendChild($dependencyElement) | Out-Null
            }
            Write-LogTastic -Message "Done." -Name $global:LOGTASTIC_MOD_NAME -Type "success" -Submessage
        }
        catch [system.exception] {
            Write-LogTastic -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -Submessage
        }
    }

    # Add Xmlns schema to the root element
    # http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd
    # http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd
    $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/06/nuspec.xsd")
    # If true, this value prompts the user to accept the license when installing the package. 
    #nuspec.package.metadata.requireLicenseAcceptance = $requireLicenseAcceptance
 
    # output the nuspec file
    try {
        Write-LogTastic -Message "Exporting .nuspec @{pt:{File=$outpath\$company`.$modulename`.nuspec}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
        $nuspec.Save("$path\$ModuleName`.nuspec")
        Write-LogTastic -Message "Exported" -Name $global:LOGTASTIC_MOD_NAME -Type "Complete"
        Write-LogTastic -Message "@{pt:{Path=$PWD`\$company`.$modulename`.nuspec}}" -Name $global:LOGTASTIC_MOD_NAME -Type "info" -Submessage
    }
    catch [system.exception] {
        Write-LogTastic -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name $global:LOGTASTIC_MOD_NAME -Type "Error" -Submessage
    }
    
}
Export-modulemember -function New-NuspecPackageFile