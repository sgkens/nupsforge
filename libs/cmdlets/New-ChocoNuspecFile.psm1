using module ..\shelldock\New-ShellDock.psm1

<#
.SYNOPSIS
    A function that creates a new .nuspec manifest file for a Chocolatey package.

.DESCRIPTION
    The New-ChocoNuspecFile function generates a .nuspec manifest file for a Chocolatey package. 
    It takes in parameters such as the module name, version, path, author, description, project URL, license, tags, company, 
    dependencies, license acceptance, and release notes. It then generates a .nuspec file with these details, 
    including the files and dependencies of the package. 

.PARAMETER ModuleName
    The name of the Chocolatey package.

.PARAMETER ModuleVersion
    The version of the Chocolatey package.

.PARAMETER path
    The path where the .nuspec file will be created.

.PARAMETER Author
    The author of the Chocolatey package.

.PARAMETER Description
    A description of the Chocolatey package.

.PARAMETER ProjectUrl
    The URL of the project associated with the Chocolatey package.

.PARAMETER License
    The license under which the Chocolatey package is released.

.PARAMETER Tags
    Tags associated with the Chocolatey package.

.PARAMETER company
    The company that owns the Chocolatey package.

.PARAMETER dependencies
    Any dependencies that the Chocolatey package has.

.PARAMETER LicenseAcceptance
    A switch that indicates whether license acceptance is required.

.PARAMETER releasenotes
    Any release notes associated with the Chocolatey package.

.EXAMPLE
    New-ChocoNuspecFile -ModuleName "MyPackage" -ModuleVersion "1.0.0" -path "C:\MyPackage" -Author "John Doe" -Description "This is my package" -ProjectUrl "http://example.com" -License "MIT" -Tags "Choco,Package" -company "MyCompany" -dependencies @("Dep1", "Dep2") -LicenseAcceptance -releasenotes "First release"

    This will create a .nuspec file for the package "MyPackage" version "1.0.0" in the directory "C:\MyPackage". The author is "John Doe", the description is "This is my package", the project URL is "http://example.com", the license is "MIT", the tags are "Choco" and "Package", the company is "MyCompany", the dependencies are "Dep1" and "Dep2", license acceptance is required, and the release notes are "First release".
#>

function New-ChocoNuspecFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$ModuleVersion,
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$Author,
        [parameter(Mandatory = $false)]
        [string[]]$Owners,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [string]$Projecturl,
        [Parameter(Mandatory = $false)]
        [string]$projectSourceurl,
        [Parameter(Mandatory = $false)]
        [string]$MailingListurl,
        [Parameter(Mandatory = $false)]
        [string]$bugTrackerurl,
        [Parameter(Mandatory = $false)]
        [string]$docsurl,
        [Parameter(Mandatory = $false)]
        [string]$Iconurl,
        [Parameter(Mandatory = $false)]
        [string]$Licenseurl,
        [Parameter(Mandatory = $false)]
        [string]$Tags,
        [Parameter(Mandatory = $false)]
        [string]$company,
        [Parameter(Mandatory = $false)]
        [array]$dependencies,
        [Parameter(Mandatory = $false)]
        [string]$releasenotes,
        [Parameter(Mandatory = $false)]
        [switch]$LicenseAcceptance,
        [Parameter(Mandatory = $false)]
        [string]$Summary
    )
    $logo = Get-Content -Path '.\libs\icon-choco.txt' -raw
    $logo
    Write-LogTastic -Message "Generating @{pt:{module=$ModuleName}} @{pt:{package=$company`.$ModuleName.$ModuleVersion.nupkg}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action"
    try {
        if($licenseAcceptance){$Acceptance='true'}else{$Acceptance='false'}
        if(!$owners){$Owners=$author}
        # XML Here-String .nuspec file template for powershell modules 
        # for a nuget package.
        [xml]$nuspec = @"
<?xml version="1.0"?>
<package>
  <metadata>
    <title>$ModuleName</title>
    <!-- Identifier that must be unique within the Chocolatey hosting gallery -->
    <id>$company`.$ModuleName</id>
    <!-- Package version number that is used when resolving dependencies -->
    <version>$ModuleVersion</version>
    <!-- Authors contain text that appears directly on the Chocolatey package page-->
    <authors>$Author</authors>
    <!-- Owners contain text that appears directly on the Chocolatey package page -->
    <owners>$Author</owners>
    <!-- The description for the chocolatey package -->
    <description>$($Description)</description>
    <!-- The summary for the chocolatey package -->
    <summary>$Summary</summary>
    <!-- Project URL provides a link for the Chocolatey package page -->
    <projectUrl>$Projecturl</projectUrl>
    <!-- Package icon url Chocolatey package page -->
    <iconUrl>$iconurl</iconUrl>
    <!-- Project Source URL provides a link for the Chocolatey -->
    <projectSourceUrl>$projectSourceurl</projectSourceUrl>
    <!-- Documentation URL provides a link for the software docs -->
    <docsUrl>$docsurl</docsUrl>
    <!-- Mailing List URL provides a link for the software mailing list -->
    <mailingListUrl>$mailingListurl</mailingListUrl>
    <!-- Bug Tracker URL provides a link for the software bug tracker -->
    <bugTrackerUrl>$bugTrackerurl</bugTrackerUrl>
    <!-- License URL provides a link for the software license -->
    <licenseUrl>$Licenseurl</licenseUrl>
    <!-- Tags appear in the gallery and can be used for tag searches -->
    <tags>$Tags</tags>
    <!-- If true, this value prompts the user to accept the license wheninstalling the package. -->   
    <requireLicenseAcceptance>$Acceptance</requireLicenseAcceptance>
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
        Write-LogTastic -Message "Done" -Name $global:LOGTASTIC_MOD_NAME -Type "success" -submessage
    }
    catch [System.Exception] {
        Write-LogTastic -Message "[NuspecPackageFile] Template Create Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
    }
    Write-LogTastic -Message "Creating File Manifest" -Name $global:LOGTASTIC_MOD_NAME -Type "Info"
    Write-LogTastic -Message "Adding files to manifest to @{pt:{xmlNodePath=nuspec.package.files.file}}" -Name $global:LOGTASTIC_MOD_NAME -Type "action" -Submessage
    #! check for readme.txt and icon.png 
    # Update and add all files to the manifest
    try {
        Write-LogTastic -Message "Getting Directory Properties" -Name $global:LOGTASTIC_MOD_NAME -Type "Info" -Submessage
        $DirectoryProperty = Get-itemProperty -Path $path
    }
    catch [System.Exception] {
        Write-LogTastic -Message "Get-ItemProperty Failed Error: @{pt:{Error=$($_.Exception.Message)}} " -Name $global:LOGTASTIC_MOD_NAME -Type "error"
        return
    }

    Get-Childitem -path $DirectoryProperty.FullName -Recurse | foreach-object {
        if ($_.PSIsContainer -eq $false) {
            
            #? https://learn.microsoft.com/en-us/nuget/reference/errors-and-warnings/nu5019
            $RelativePath = $_.fullname.Replace($DirectoryProperty.FullName, "").TrimStart("\")
            try {
                # replace souce path with empty string to get relative path 
                if($_.name -match "(I|i)(con.png)") {
                    Write-LogTastic -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)
                }
                elseif($_.name -match "(R|r)(eadme|EADME).md") {
                    Write-LogTastic -Message "{ct:blue:required} @{pt:{path=$RelativePath}}" -Name $global:LOGTASTIC_MOD_NAME -Type "complete" -Submessage
                    # add readme.txt and icon.png to the root of the package as default requirements
                    $fileElement = $nuspec.CreateElement("file")
                    $fileElement.SetAttribute("target", $RelativePath)
                    $fileElement.SetAttribute("src", $RelativePath)       
                }else{
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
                break;
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
    $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd")
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
Export-modulemember -function New-ChocoNuspecFile