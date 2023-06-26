using module ..\pongo\libs\new-pongo.ps1
$pango_build_data = get-content "$(get-location)\apira_build_data.json" | convertfrom-json
[pscustomobject]$pango_build_data = @{
    projectname           = "$($pango_build_data.projectname)"; #?___________________________________? name of your project
    version               = "$($pango_build_data.version)"; #?___________________________________? version number of applcation
    Name                  = "@$($pango_build_data.user)"; #?___________________________________? Username Or companyname or both
    savepath              = "$($pango_build_data.export_directory)"; #?____________________? Save path for SVG
    NameColor             = "#3e6e83"; #?___________________________________? Color of the username/company name
    projectnamecolor      = "#3e6e83"; #?___________________________________? Color of ProjectName/Application Name
    versioncolor          = "#2a1fd6"; #?___________________________________? Color of Version Text
    versiontitlecolor     = "#383838"; #?___________________________________? Color of Version Titled "version" #default
    lineseperatorcolor    = "#383838"; #?___________________________________? Color of Line Serperator in the middle
    rectheadercolor       = "#283593"; #?___________________________________? Color of Rectangle - background for logo
    rectheaderstroke      = "3"; #?___________________________________? stroke of Rectangle - background for logo
    rectheaderstrokecolor = "#4DD0E1"; #?___________________________________? stroke-color of Rectangle - background for logo
    datapaths             = @{ 
        viewbox = "0 0 280 260"
        paths   = @( 
            @{ fill = "#DC772C"; path = "M0, 138.555c0, 15.245, 6.289, 29.56, 17.303, 42.014l15.929, 31.376c6.175, 23.191, 30.725, 42.065, 54.734, 42.065h95.258
			c24.177,0,49.686-17.77,58.07-40.457l28.759-51.491l-0.104,0.12c4.684-7.518,7.42-15.436,7.42-23.634
			c0-20.546-11.42-39.419-30.472-54.287c4.879-4.99,13.181-15.357,12.756-27.825c-0.346-9.855-5.879-18.643-16.477-26.123
			c-27.306-19.287-57.841,5.8-72.003,23.803c-10.43-1.568-21.297-2.419-32.492-2.419c-12.95,0-25.471,1.135-37.368,3.215
			C87.44,36.863,56.419,10.737,28.701,30.313c-10.597,7.48-16.134,16.268-16.475,26.123c-0.509,15.041,11.701,27.06,15.242,30.225
			C10.213,101.14,0,119.1,0,138.555z M169.112,65.9c3.836,0,6.928,3.105,6.928,6.934c0,3.824-3.101,6.93-6.928,6.93
			c-3.825,0-6.922-3.105-6.922-6.93C162.19,69.005,165.282,65.9,169.112,65.9z M92.964,67.648c3.833,0,6.925,3.105,6.925,6.933
			c0,3.825-3.096,6.93-6.925,6.93c-3.828,0-6.924-3.105-6.924-6.93C86.04,70.753,89.131,67.648,92.964,67.648z M31.932,83.115
			L31.932,83.115C31.932,83.115,31.932,83.12,31.932,83.115L31.932,83.115z M138.683,89.991c62.995,0,112.353,26.574,112.353,60.509
			c0,33.932-49.357,60.509-112.353,60.509c-62.999,0-112.354-26.582-112.354-60.509C26.329,116.565,75.684,89.991,138.683,89.991z"; 
            }, 
            @{ fill = "#DC772C"; path = "M138.683,199.802c54.818,0,101.144-22.582,101.144-49.303c0-26.721-46.325-49.302-101.144-49.302
			c-54.823,0-101.146,22.574-101.146,49.302C37.537,177.225,83.859,199.802,138.683,199.802z M140.067,115.769
			c47.179,0,84.139,18.783,84.139,42.77h-5.603c0-20.143-35.965-37.165-78.536-37.165c-42.581,0-78.547,17.022-78.547,37.165h-5.603
			C55.921,134.552,92.88,115.769,140.067,115.769z"; 
            }
        )
    }
}; 

# cmd online method
new-pongo -projectname $pango_build_data.projectname `
    -version $pango_build_data.version `
    -Name $pango_build_data.Name `
    -savepath $pango_build_data.savepath `
    -NameColor $pango_build_data.NameColor `
    -projectnamecolor $pango_build_data.projectnamecolor `
    -versioncolor $pango_build_data.versioncolor `
    -versiontitlecolor $pango_build_data.versiontitlecolor `
    -lineseperatorcolor $pango_build_data.lineseperatorcolor `
    -rectheadercolor $pango_build_data.rectheadercolor `
    -rectheaderstroke $pango_build_data.rectheaderstroke `
    -rectheaderstrokecolor $pango_build_data.rectheaderstrokecolor `
    -datapaths $pango_build_data.datapaths `
    -beta `
    -addlogobg `
    #-animatelogobg `
    #-animatelogo `