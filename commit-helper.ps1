<#
  Commit Fusion template file
  use to create large detailed commits
#>
$Params = @{
  Type = "feat";
  Scope = "Module";
  Description = "Core functionality update pre-release";
  Notes = @(
    "Provided a way to create .nuspec file from cmdlet New-NuspecPacakgeFile",
    "Provided a way to create .nupkg file from cmdlet New-NuspecPacakge",
    "Included logtatastic as the console logger",
    "Included shelldock runspace wrapper to excute creation process",
    "added module meta data",
    "Added module icon",
    "added ci-build scripts(Still requires more configuration)"
  );
  #Footer=$true
  GitUser = "sgkens";
  GitGroup = "powershell";
  # FeatureAddtions = @(
  #   "Exposes all methods and properties of the Table and Rule class"
  #   "``New-Object Spectre.Console.Table`` and ``New-Object Spectre.Console.Rule``"
  # );
  #BugFixes = @();
  #BreakingChanges = @();
  #FeatureNotes = @();
  #AsString = $true #Default is $true
}

# ACTIONS
# -------

# ConventionalCommit with params sent commit
New-ConventionalCommit @params #| set-commit

# ConventionalCommit with params sent commit
#New-ConventionalCommit @Params | Set-Commit

# ConventionalCommit with params, written to changelog and sent commit
#New-ConventionalCommit @Params | Format-FusionMD | Update-ChangeLog -logfile .\changelog.md | Set-Commit