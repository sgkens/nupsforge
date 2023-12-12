using module .\New-NuspecPacakgeFile.psm1


New-NuspecPacakgeFile -path .\ `
                      -ModuleName "NupkgPacakge" `
                      -ModuleVersion "0.0.1" `
                      -Author "Snoonx" `
                      -Description "Powershell Module use to build NupkgPacakges" `
                      -ProjectUrl "https://github.com/snoonx/projects/NupkgPacakge" `
                      -License "MIT" `
                      -company "SimpleScripts" `
                      -Tags "PowerShell, Module, automation, nupkg, build" `
                      -dependencies @{id="bitstransfer";version="1.2.3"},@{id="quicklog";version="1.2.3"}`


# [xml]$nuspec = @"
# <?xml version="1.0"?>
# <package>
#   <metadata>
#     <id>MyModule</id>
#     <version>1.0.0</version>
#     <title>My PowerShell Module</title>
#     <authors>John Doe</authors>
#     <owners>John Doe</owners>
#     <description>A PowerShell module for doing awesome things.</description>
#     <projectUrl>https://github.com/johndoe/mymodule</projectUrl>
#     <iconUrl>https://github.com/johndoe/mymodule/icon.png</iconUrl>
#     <license type="expression">MIT</license>
#     <tags>powershell module</tags>
#     <dependencies>
#       <dependency id="SomeOtherModule" version="[1.0.0]" />
#     </dependencies>
#   </metadata>
#   <files>
#     <file src="MyModule.psd1" target="tools\MyModule.psd1" />
#     <file src="MyModule.psm1" target="tools\MyModule.psm1" />
#   </files>
# </package>
# "@

# $nuspec.package.metadata.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd")

# $nuspec.Save("MyModule.nuspec")