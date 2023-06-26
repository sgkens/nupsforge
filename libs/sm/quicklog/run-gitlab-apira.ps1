using module G:\devspace\projects\powershell\gitlab-apira\New-ApiraAutoGen.ps1

New-ApiraAutoGen -gitlaburl "https://gitlab.snowlab.tk" `
    -name "quicklog" `
    -projectpath "G:\devspace\projects\powershell" `
    -description "The New-Quicklog function is a PowerShell script that outputs a formatted log message to the console." `
    -initcommitmessage 'phell::auto-generated-repo::quicklog::success' `
    -user 'mnoxx' `
    -token 'QuKeQXyos8vHSpGzT6rE' `
    -license `
    -licenseType "mit" `
    -branchtype 'main' `
    -readme `
    -changelog `
    -verbosecompiler `
    -group 'powershell' `
    -tags @("LogMessage", "log","automation", "module","powershell") `
    -visibility 'public' `
    -ci `
    -citemplate "default" `
    -gitignore `
    -gitmodule `
    -version '0.1.0' `
    -companyname 'Codedus' `
    -powershellManifest `
    -BuildData
    #-PowerShellClassTemplate `
