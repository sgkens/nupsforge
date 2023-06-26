using module sm\quicklog\quicklog.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: New-NuspecPacakgeFile Function
##   AUTHER------: snoonx | nytscripts
#?   DESCRIPTION-: Creates a new nuspec file for powershell modules.      
*?   DEPENDANCIES: quicklog 
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
** ******************************************************************************************************#>
function New-NuspecPacakgeFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$ModuleVersion,
        [Parameter(Mandatory = $true)],
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$Author,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [string]$ProjectUrl,
        [Parameter(Mandatory = $true)]
        [string]$License,
        [Parameter(Mandatory = $true)]
        [string]$Tags,
        [Parameter(Mandatory = $true)]
        [string]$company,
        [Parameter(Mandatory = $false)]
        [array]$dependencies,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [bool]$requireLicenseAcceptance = $false,
        [Parameter(Mandatory = $false)]
        [string]$releasenotes
    )

    
    Write-QLMessage -Message "Generating [NuspecPackageFile] @{pt:{module=$ModuleName}} @{pt:{package=$company`.$ModuleName}}" -Name "bv" -Type "action"
    try{
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
    <!-- 
        Owners are typically nuget.org identities that allow gallery
        users to easily find other packages by the same owners.  
    -->
    <owners>$Author</owners>
    <!-- 
        The description can be used in package manager UI. Note that the
        nuget.org gallery uses information you add in the portal. 
    -->
    <description>$Description.</description>
    <!-- Project URL provides a link for the gallery -->
    <projectUrl>$ProjectUrl</projectUrl>
    <!-- License information is displayed on the gallery -->
    <license type="expression">$License</license>
    <!-- Tags appear in the gallery and can be used for tag searches -->
    <tags>$Tags</tags>
    <!-- Icon is used in Visual Studio's package manager UI -->
    <icon>icon.png</icon>
    <!-- 
        If true, this value prompts the user to accept the license when
        installing the package. 
    -->   
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <!-- Any details about this particular release -->
    <releaseNotes>$releasenotes</releaseNotes>
    <!-- Copyright information -->
    <copyright>Copyright ©$((get-date | select-object year).year) $company</copyright>
    <!-- Dependencies are automatically installed when the package is installed -->
    <dependencies>
    </dependencies>
  </metadata>
  <!-- Files included in the manifiest and relative path -->
  <files>
  </files>
</package>
"@
    Write-QLMessage -Message "Done" -Name "bv" -Type "Info"
}
catch [System.Exception] {
    Write-QLMessage -Message "[NuspecPackageFile] Template Create Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name "bv" -Type "error"
}
    Write-QLMessage -Message "File Manifest" -Name "bv" -Type "Info"
    Write-QLMessage -Message "Adding files to manifest from @{pt:{xmlNodePath=nuspec.package.files.file}}" -Name "bv" -Type "action" -Submessage
    #! check for readme.txt and icon.png 
    # Update and add all files to the manifest

    get-childitem -path . -Recurse | foreach-object {
        if ($_.PSIsContainer -eq $false) {
            try{
                #? https://learn.microsoft.com/en-us/nuget/reference/errors-and-warnings/nu5019
                # replace souce path with empty string to get relative path
                $RelativePath = $_.DirectoryName.Replace($pwd.path, "").TrimStart("\") | Where-Object { $_ -ne "" }
                Write-QLMessage -Message "- File @{pt:{♦=$($RelativePath)\$($_.name)}}" -Name "bv" -Type "Info" -Submessage
                if($_.name -like "readme.txt" -or $_.name -like "icon.png") {
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $_.Name)
                    $fileElement.SetAttribute("src", $_.Name)
                    
                }elseif($RelativePath){
                    # Create new <file> element
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $_.Name)
                    $fileElement.SetAttribute("src", "$RelativePath\$($_.Name)")
                    
                }
                else{
                    # Create new <file> element
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $_.Name)
                    $fileElement.SetAttribute("src", $_.Name)
                }
                # Append the new <file> element to the <files> node
                $nuspec.SelectSingleNode("//files").AppendChild($fileElement) | Out-Null
            }
            catch{
                Write-QLMessage -Message "File > @{pt:{-=$($_.Exception.message)}}" -Name "bv" -Type "Error" -Submessage
            }
        }
    }
    Write-QLMessage -Message "Done." -Name "bv" -Type "success" -Submessage
    
    # Add dependancies to the manifest
    # xmlnode nuspec.package.metadata.dependencies.dependency
    if($dependencies.Count -ne 0){
        try{
            Write-QLMessage -Message "Adding dependancies to manifest node @{pt:{xmlNodePath=nuspec.package.metadata.dependencies.dependency}}" -Name "bv" -Type "action"
            foreach($dependency in $dependencies){
                Write-QLMessage -Message "Dependency > @{pt:{Name=$($dependency.id)}} @{pt:{Version=$($dependency.verion)}}" -Name "bv" -Type "Action" -Submessage
                $dependencyElement = $nuspec.CreateElement("dependency")
                $dependencyElement.SetAttribute("id", $dependency.id)
                $dependencyElement.SetAttribute("version", $dependency.version)
                $nuspec.SelectSingleNode("//dependencies").AppendChild($dependencyElement) | Out-Null
            }
            Write-QLMessage -Message "Done." -Name "bv" -Type "success" -Submessage
        }
        catch [system.exception] {
            Write-QLMessage -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name "bv" -Type "Error" -Submessage
        }
    }

    # Add Xmlns schema to the root element
    $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd")
    # If true, this value prompts the user to accept the license when installing the package. 
    #nuspec.package.metadata.requireLicenseAcceptance = $requireLicenseAcceptance

    # output the nuspec file
    try{
        Write-QLMessage -Message "Exporting .nuspec @{pt:{File=$company`.$modulename`.nuspec}}" -Name "bv" -Type "action"
        $nuspec.Save("$ModuleName`.nuspec")
        Write-QLMessage -Message "Exported" -Name "bv" -Type "Complete"
        Write-QLMessage -Message "@{pt:{Path=$PWD`\$company`.$modulename`.nuspec}}" -Name "bv" -Type "info" -Submessage
    }
    catch [system.exception] {
        Write-QLMessage -Message "Error: @{pt:{Error=$($_.Exception.Message)}}" -Name "bv" -Type "Error" -Submessage
    }
    
}
