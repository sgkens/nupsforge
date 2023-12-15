# ---[ CONFIG ]

$ModuleName = "nupsforge"
$Gitlab_Username = "sgkens"
$Gitlab_uri = "https://gitlab.lab.davilion.online"
$projectid = "183"

# ---[ ------ ]

$ModuleManifest = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName.psd1"
$SemVerVersion = $ModuleManifest.Version -replace "\.\d+$", ""
$NugetProjectPath = "api/v4/projects/$projectid/packages/nuget"

try {
  [console]::write("Attempting to Register Gitlab: $($gitlab_uri)@$($Gitlab_Username)`n")
  dotnet nuget add source $gitlab_uri/$NugetProjectPath --name gitlab --username $GitLab_Username --password $ENV:GITLAB_API_KEY
  [console]::write("Complete`n")
}
catch [system.exception] {
  [console]::write("Failed to add source $($gitlab_uri/$NugetProjectPath) `n")
  [console]::write("$($_)`n")
}
try {
  Write-host -foregroundcolor yellow "Attempting to push $modulename to Gitlab: $gitlab_uri"
  dotnet nuget push .\dist\nuget\$($ModuleManifest.CompanyName).$modulename.$SemVerVersion.nupkg --source gitlab
}
catch [system.exception] {
  [console]::write("Failed to push to gitlab: $($Gitlab_uri)`n")
  [console]::write("$($_)`n")
}
dotnet nuget remove source gitlab