<#
  Commit Fusion template file
  use to create large detailed commits
#>
$Params = @{
  Type = "feat";
  Scope = "cmdlets";
  Description = "Implimented cmdlet to handle choco .nupkg generation";
  Notes = @(
    "Added figlet static logo for New-NupkgPackage and New-Chocopackage",
    "Deleted/moved .ps1 scripts",
    "Updated logtastic log message to include Choco package creation"
  );
  #Footer=$true
  #GitUser = "sgkens";
  GitGroup = "powershell";
  FeatureAddtions = @(
    "Access to New Cmdlet New-ChocoPackage, New-ChocoNupsecFile allowing the creation of comptatable chocolatey packages, instead of using nuget.exe or dotnet nuget Compress-Archive is used and output is a.nupkg file"
  );
  # BugFixes = @(
  #   ""
  # );
  #BreakingChanges = @();
  #FeatureNotes = @();
  #AsString = $true #Default is $true
}

# ACTIONS
# -------

# ConventionalCommit with params sent commit
New-ConventionalCommit @params #| set-commit

# ConventionalCommit with params sent commit
#New-ConventinalCommit @Params | Set-Commit

# ConventionalCommit with params, written to changelog and sent commit
#New-ConventionalCommit @Params | Format-FusionMD | Update-ChangeLog -logfile .\changelog.md | Set-Commit