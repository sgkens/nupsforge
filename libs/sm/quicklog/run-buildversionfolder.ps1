
using module G:\devspace\projects\powershell\buildtoversionfolder\libs\Copy-BuildToVersionFolder.ps1
$props = @{
    SourcePath ="$(get-location)"
    DestinationPath = ".\dist"
    FilesToCopy =  @("quicklog.ps1")
    FoldersToCopy = @("libs")
    IncrementVersion = "build"
    apira            = $true
    pssi             = $true
    psmm             = $true
}
Copy-BuildToVersionFolder -SourcePath $props.SourcePath `
                          -DestinationPath $props.DestinationPath `
                          -FilesToCopy $props.FilesToCopy `
                          -FoldersToCopy $props.FoldersToCopy `
                          -IncrementVersion $props.IncrementVersion `
                          -apira:$props.apira `
                          -pssi:$props.pssi `
                          -psmm:$props.psmm