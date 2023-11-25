using module sm\Get-Elapsed.psm1
using module sm\Get-PropTune.psm1
using module sm\Get-ColorTune.psm1
using module sm\powerunicode\powerunicode.psm1
#*  ____       _      __   __
#*  / __ \__ __(_)____/ /__/ / ___ ___ _
#  / /_/ / // / // __/  '_/ /_/ _ Y _ `/
#  \___\_\_,_/_/ \__/_/\_Y____|___|_, /
#&                               /__
<# ----------------------------------------o
& CLASSNAME: [logtastic]
~ VERSION: 0.1.0
- AUTHOR: Snoonx @ SimpleScripts.dev
- LICENSE: MIT   
* DESCRIPTION:   
    LogTastic is a PowerShell Module that outputs styled log message to the console. 
    It is designed to be used in conjunction with other PowerShell modules to provide 
    a consistent look and feel to the console output.
  
? DEPENDANCIES:
    • Get-Elapsed
    • Get-Proptune
    • Get-ColorTune 
    • PowerUnicode 
? NOTES
    This class is still in development and is not ready for production use.
    @Colorful comments vscode url: 
        - #? https://marketplace.visualstudio.com/items?itemName=bierner.colorful-comments
    BUILD ENV
        Powershellcore 7.3.1
----------------------------------------o #>
class logtastic {
    [String]$name
    [String]$type
    [String]$unicode = $null
    [Bool]$submessage
    [String]$datestring
    [datetime]$date
    [String]$message
    [PSCustomObject]$icons
    [Bool]$logdate
    [Bool]$logicon
    [Bool]$logfile
    [Bool]$ExecTime
    [String]$PTSeperator
    [Int]$sm_indent
    [String]$CurrentLogTime
    [String]$LastLogTime
    [PSCustomObject]$themeProperties = [PSCustomObject]@{ ascii=""; utfe=""; nerdf=""; custom=""; }
    [String]$theme
    [string]$LogMessage
    

    LogTastic() {
        $this.themeProperties.utfe = Get-Content -Path "$PSSCriptRoot\theme-utf8-lt.json" | ConvertFrom-Json
        $this.themeProperties.nerdf = Get-Content -Path "$PSSCriptRoot\theme-nerdfont-lt.json" | ConvertFrom-Json
        $this.themeProperties.ascii = Get-Content -Path "$PSSCriptRoot\theme-ascii-lt.json" | ConvertFrom-Json
        switch($this.theme){
            "utfe" {
            }
            "nerdf" {
            }
            "ascii" {
            }
            "custom" {
            }
            default {
            }
        }
        
        $this.icons = $this.themeProperties.utfe
        # $this.icons = [PSCustomObject]@{
        #     Error           = "#2753" # ❓
        #     Error2          = "#2757" # ❗
        #     Success         = "#1F7E2" # 🟢
        #    # Info            = "#1F300" # 🌀
        #     Info            = "#1F9FE" # 🧾
        #     Complete        = "#2705"  # ✅
        #     Action          = "#1F4A6" # 💦
        #     request         = "#1F310" # 🌐
        #     response        = "#1F311" # 🌑
        #     Speaker         = "#1F50A" # 🔊
        #     Seperator       = "#1F4A0" # 💠
        #     Separator2      = "#2666"  # ♦
        #     Separator3      = "#2638"  # ☸ 
        #     LeftArrow       = "#2771"  #  ❱
        #     Plus            = "#2795"  # ➕
        #     logtime         = "#23F0"  # ⏰
        #     download        = "#1F4E5"  # 
        #     download2       = "#1F300" # 🌀
        #     upload          = "#1F4E4" # 📤
        #     submessage      = "#21AA"  # ↪
        #     ArrowDiagUp     = "#2197"  # ↗
        #     UpCurvedArrow   = "#2197"  # ↗
        #     ArrowUp         = "#2B06"  # ⬆
        #     ArrowDown       = "#2B07"  # ⬇
        #     ArrowLeft       = "#2B05"  # ⬅
        #     ArrowRight      = "#27A1"  # ➡
        #     DataStreamLeftRight  = "#2194"  # ↔
        #     DataStreamUpDown     = "#2195"  # ↕
        #     DataStreamRight      = "#21C4" # ⇄
        #     DataStreamLeft       = "#21C6" # ⇆
        #     DataStreamDUpDown    = "#21C5" # ⇅
        #     ArrowDataStreamUp    = "#21C8" # ⇈
        #     ArrowDataStreamLeft  = "#21C7" # ⇇
        #     ArrowDataStreamRight = "#21C9" # ⇉
        #     TleftArrow           = "#21A4" # ↤
        #     TRightArrow          = "#21A6" # ↦
        #     submessageAlt     = "#21B3" # ↳
        #     Tick                 = "#2714"  # ✔
        # }
        $this.logdate = $true
        $this.Type = "info"
        $this.sm_indent = 5
        $this.LastLogTime = $this.GetLogTime()
        if ($null -eq $this.unicode -or $this.unicode.Length -eq 0) {
            $this.unicode = "#1F365" # 🍥
        }
        $this.SetConsoleEncoding()
    }

    [void]SetConsoleEncoding(){
        [Console]::OutputEncoding = [Text.Encoding]::UTF8
    }

    [void]EnableLogdate(){
        $this.logdate = $true
    }

    [void]DisableLogdate(){
        $this.logdate = $false
    }

    [void]EnableLogIcon(){
        $this.logicon = $true
    }

    [void]DisableLogIcon(){
        $this.logicon = $false
    }

    [void] EnableLogfile(){
        $this.logfile = $true
    }

    [void]DisableLogfile(){
        $this.logfile = $false
    }

    [void]EnableExectime(){
        $this.Exectime = $true
    }

    [void]DisableExectime(){
        $this.Exectime = $false
    }

    [string]NewIndent([int]$indent){
        [string] $indentstring = " "
        $indentstring = $indentstring * $indent
        return $indentstring
    }

    [string]GetLogTime(){
        return (Get-Date).toString()
    }

    [void]EnableLogfile([string]$path){
        if(test-path -path $path){
            Start-Transcript -path "$path\documents\$($this.name).log" -Append
        }else{
            Start-Transcript -path "$env:HOMEDRIVE$env:HOMEPATH\documents\$($this.name).log" -Append
        }
    
    }
    [PSCustomObject]GetThemeProperty([string]$property){

        return $this.icons.utfeprops.Where({$_.id -eq $property})
    }
    # Find the unicode for a theme property and convert it to a string for printing to the console
    # Powerunicode is a dependancy for this function
    [String]GetThemeUnicode([string]$property){

        return [PowerUnicode]::PrintByUnicode($this.icons.utfeprops.Where({$_.id -eq $property}).unicode)
    }

    [Void]WriteLog([string]$message, [string]$type = "info", [bool]$submessage){
        $this.datestring = Get-Date -Format "hh:mm:ss"
        $this.CurrentLogTime = $this.GetLogTime()
        $this.message = $message
        $this.type = $type
        $this.submessage = $submessage
        
        # Set default unicode if not set
        # if ($null -eq $this.unicode -or $this.unicode.length -eq 0) { $this.unicode = "#1F43D" }
        
        # Start of log message
        # write-host -foregroundcolor yellow "[" -nonewline;
        
        # New Method to un-used write-host
        $this.LogMessage = "$(Get-ColorTune -text "[" -color Yellow)"
        # Enable/Disable log icon
        if($this.logicon -eq $true){
            # write-host -ForegroundColor yellow "$([powerunicode]::printByUnicode($this.unicode))" -nonewline;
            # write-host -ForegroundColor gray "-" -nonewline;
            # write-host -ForegroundColor gray "$($this.name)" -NoNewline;

            $this.LogMessage += "$(Get-ColorTune -text $([powerunicode]::printByUnicode($this.unicode)) -Color Yellow)"
            $this.LogMessage += "$(Get-ColorTune -text "-" -color Gray)"
            $this.LogMessage += "$(Get-ColorTune -text $($this.name) -color Gray)"
        }
        else{
            # write-host -ForegroundColor white "$($this.name)" -nonewline;

            $this.LogMessage += "$(Get-ColorTune -text $($this.name) -color Gray)"
        }

        # if submessage is true, print logtime
        if ($this.submessage -eq $true) {
            if ($this.logdate -eq $true) {
                # write-host -ForegroundColor yellow "$($this.GetThemeUnicode("LogTime"))" -NoNewline;
                # write-host -ForegroundColor gray "$($this.datestring)" -NoNewline;
                # write-host -foregroundcolor yellow "]" -nonewline;

                $this.LogMessage += "$(Get-ColorTune -text $($this.GetThemeUnicode("LogTime")) -color Yellow)"
                $this.LogMessage += "$(Get-ColorTune -text $($this.datestring) -color Gray)"
                $this.LogMessage += "$(Get-ColorTune -text "]" -color Gray)"
            }
        }
        else {
            if ($this.logdate -eq $true) {
                # write-host -ForegroundColor yellow "$($this.GetThemeUnicode("LogTime"))" -NoNewline;
                # write-host -ForegroundColor gray "$($this.datestring)" -NoNewline;
                # write-host -Foregroundcolor yellow "]" -nonewline;
                # write-host -ForegroundColor yellow "$([powerunicode]::printByUnicode($this.GetThemeUnicode("logpointer")))" -NoNewline;
                $this.LogMessage += "$(Get-ColorTune -Text $($this.GetThemeUnicode("LogTime")) -Color Yellow)"
                $this.LogMessage += "$(Get-ColorTune -Text $($this.datestring) -Color Gray)"
                $this.LogMessage += "$(Get-ColorTune -Text "]" -Color Yellow)"
            }else{
                # write-host -ForegroundColor yellow "]" -nonewline;
                # write-host -ForegroundColor yellow "$([powerunicode]::printByUnicode($this.GetThemeUnicode("logpointer")))" -NoNewline;
                $this.LogMessage += "$(Get-ColorTune -Text "]" -Color Yellow)"
            }
        }
        # if submessage is true, do not print logtime
        if ($this.submessage -eq $true) {
            switch ($type) {
                success { 
                    # Write-Host -ForegroundColor green "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline;
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color Green) "
                }
                error { 
                    # Write-Host -ForegroundColor red "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline;
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color red) "
                }
                info { 
                    # Write-Host -ForegroundColor blue "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline; 
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color blue) "
                }
                complete { 
                    # Write-Host -ForegroundColor darkgreen "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline;
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color darkgreen) "
                }
                action { 
                    # Write-Host -ForegroundColor yellow "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline;
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color yellow) "
                 }
                default { 
                    # Write-Host -ForegroundColor blue "$($this.NewIndent($this.sm_indent))$($this.GetThemeUnicode("submessage")) " -nonewline;
                    $this.LogMessage += "$($this.NewIndent($this.sm_indent))$(Get-ColorTune -Text "$($this.GetThemeUnicode("submessage"))" -Color blue) "
                }
            }
        }
        else {
            switch ($this.type) {
                success { 
                    # Write-Host -ForegroundColor green "$($this.GetThemeUnicode("success"))$($this.GetThemeUnicode("logpointer")) " -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("success"))$($this.GetThemeUnicode("logpointer")) "
                }
                error { 
                    # Write-Host -ForegroundColor red "$($this.GetThemeUnicode("error"))$($this.GetThemeUnicode("logpointer"))$($this.GetThemeUnicode("error2"))" -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("error"))$($this.GetThemeUnicode("logpointer"))$($this.GetThemeUnicode("error2"))"
                }
                info { 
                    # Write-Host -ForegroundColor blue "$($this.GetThemeUnicode("info"))$($this.GetThemeUnicode("logpointer")) " -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("info"))$($this.GetThemeUnicode("logpointer")) "
                }
                complete { 
                    # Write-Host -ForegroundColor darkgreen "$($this.GetThemeUnicode("complete"))$($this.GetThemeUnicode("logpointer")) " -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("complete"))$($this.GetThemeUnicode("logpointer")) "
                }
                action { 
                    # Write-Host -ForegroundColor yellow "$($this.GetThemeUnicode("action"))$($this.GetThemeUnicode("logpointer")) " -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("action"))$($this.GetThemeUnicode("logpointer")) "
                }
                default { 
                    # Write-Host -ForegroundColor blue "$($this.GetThemeUnicode("info"))$($this.GetThemeUnicode("logpointer")) " -nonewline;
                    $this.LogMessage += "$($this.GetThemeUnicode("info"))$($this.GetThemeUnicode("logpointer")) "
                }   
            }
        }

        # Message Area -if colortune Key is prsent ---------------
        $ColorElements = [regex]::Matches($this.message,"(\{ct:)(.*?)(\})")
        if($ColorElements) {
            for($i=0; $i -lt $ColorElements.count; $i++){
                $PropColorData = $ColorElements[$i].value -replace "{ct:", "" -replace "}", ""
                $color = $PropColorData.split(":")[0]
                $text = $PropColorData.split(":")[1]
                # inline color 
                #$InlineTextColor = Get-ColorTune -text $text -color $color
                $this.message = $this.message.replace($ColorElements[$i].value, $(Get-ColorTune -Text "$text" -color "$color"))
            }
         }

        # $PropElements = [regex]::Matches($this.message, "(@\{pt:\{)(.*?)(\}\})")
        # if ($PropElements) {
        #     for ($i = 0; $i -lt $PropElements.count; $i++) {
        #         $PropColorData = $PropElements[$i].value -replace "{pt:{", "" -replace "}}", ""
        #         $propdata = Get-Proptune -StringData $PropColorData
        #         $propname = $propdata.Name
        #         $propvalue = $propdata.Value
        #         # inline color 
        #         # $InlineTextColor = Get-ColorTune -text $text -color $color
        #         # $PropMessageBody = $this.message.replace($PropElements[$i], "o-$(Get-ColorTune -Text "$propname" -color "Yellow"):$(Get-ColorTune -Text "$propvalue" -color "blue")")
        #         # $this.LogMessage += $PropMessageBody
        #     }
        #  }

        # Message Area -if Proptune Key is prsent ---------------
        $PropElements = [regex]::Matches($this.message, "(\@\{pt:\{)(.*?)(\}\})")
        if ($PropElements.count -ne 0){
            foreach($emsp in $PropElements){
                $emsp_cleaned = $emsp -replace "@{pt:{", "" -replace "}}",""
                $props = Get-PropTune -StringData $emsp_cleaned
                foreach($propname in $props.keys){
                    # write-host "$([char]0x25CB)$([char]0x2500)" -foregroundColor yellow -nonewline; 
                    # write-host -foregroundColor Magenta "$propname`:" -nonewline; 
                    # write-host -foregroundColor darkgray "$value" -nonewline; 
                    # write-host "" -nonewline;
                    $FormattedProp = "$(Get-ColorTune -Text "○-" -Color yellow)"
                    $FormattedProp += "$(Get-ColorTune -Text "$($propname)" -Color Magenta)"
                    $FormattedProp += ":"
                    $FormattedProp += "$(Get-ColorTune -Text "$($props[$propname])" -Color Darkgray)"
                    $FormattedProp += ""
                    $this.message = $this.message -replace "$emsp", $FormattedProp
                    $this.LogMessage += $this.message
                }
            }
        }else{
            $this.LogMessage += $this.message
        }
        <#-#MESSAGES#-#>
        if(!$this.submessage){
            switch ($this.type) {
                success { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "s-ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color Green)"

                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                error { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "e-ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"
                        
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color Red)"
                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                info { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "i-ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"
                        
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color DarkCyan)"

                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                complete { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "c-ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"

                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color DarkCyan)"

                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                action { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "a-ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"

                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color DarkCyan)"
                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
                Default { 
                    if($this.Exectime){
                        # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("exectime"))" -nonewline;
                        # write-host -ForegroundColor DarkCyan "ex:$(Get-Elapsed -From $this.LastLogTime -To $this.CurrentLogTime -Formattedstring)"

                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("seperator2"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "$($this.GetThemeUnicode("exectime"))" -Color DarkCyan)"
                        $this.LogMessage += " $(Get-ColorTune -Text "ex" -color yellow):$(Get-ColorTune -Text "$(Get-Elapsed -From $($this.LastLogTime) -To $($this.CurrentLogTime) -Formattedstring)" -Color DarkCyan)"
                    }else{
                        # write-host ""

                        $this.LogMessage += ""
                    }
                }
            }         
        }
        <#-#SUBMESSAGES#-#>
        else{
            switch ($this.type) {
                success{ 
                    # Write-Host " "
                    $this.LogMessage += " "
                }
                error{ 
                    # Write-Host " "
                    $this.LogMessage += " "
                }
                info{
                    # Write-Host " "
                    $this.LogMessage += " "
                }
                complete{
                    # Write-Host -ForegroundColor DarkCyan " $($this.GetThemeUnicode("seperator2")) $($this.GetThemeUnicode("tick"))"
                    $this.LogMessage += " $($this.GetThemeUnicode("seperator2")) $($this.GetThemeUnicode("tick"))"
                }
                action{
                    # Write-Host " "
                    $this.LogMessage += " "
                }
                default{
                    # Write-Host " "
                    $this.LogMessage += " "
                }                
            }
            $this.LastLogTime = $this.GetLogTime()
        }
        [console]::Write("$($this.LogMessage)`n")
        # Set the last log message time allows to calculate athe time difference between the logs
    }

    [string]BuildProgressBar([int]$percent, [int]$barcount = 50){
        # 25 is the number of characters in the progress bar
        $bar = ""
        $bar = $bar + "$(Get-ColorTune -Text "[" -Color Cyan)"
        $bar = $bar + ("$([char]0x25CF)" * [math]::floor(($barcount * $percent) / 100))
        $bar = $bar + "$(Get-ColorTune -Text ">" -Color Magenta)"
        $bar = $bar + ("$([char]0x2501)" * [math]::floor($barcount - (($barcount * $percent) / 100)))
        $bar = $bar + "$(Get-ColorTune -Text "]" -Color Cyan)"
        return $bar
    }

    [Void]Writeprogress([PSCustomObject]$stats) {
        write-host -ForegroundColor Magenta "[" -nonewline;
        if($this.LogIcon -eq $true){
            write-host "$([powerunicode]::printByUnicode($this.unicode))-" -nonewline;
            write-host -ForegroundColor gray "$($this.name)" -NoNewline;
        }
        else{
            write-host "$($this.name)" -NoNewline;
        }


        if ($stats.submessage -eq $true) {
            write-host -ForegroundColor white "$(if($this.logdate -eq $true){$this.GetThemeUnicode("logtime")})$(if($this.logdate -eq $true){$this.datestring})" -NoNewline;
            write-host -ForegroundColor Magenta "]" -NoNewline;
            Write-Host -ForegroundColor yellow "     " -NoNewline;
            write-host -ForegroundColor Blue "$($this.GetThemeUnicode("submessage")) " -NoNewline;
            write-host -foregroundcolor DarkYellow "$($this.buildprogressbar($stats.percent,$stats.barcount))" -NoNewline;
            write-host -ForegroundColor blue " [" -NoNewline;
            write-host -ForegroundColor Magenta "$($this.GetThemeUnicode("bandwidth")) " -NoNewline;
            Write-Host -ForeGroundcolor DarkGray "$($stats.bandwidth)" -NoNewline;
            write-host -ForegroundColor Cyan " $([char]0x00BB) " -NoNewline;
            write-host -ForegroundColor Cyan "(" -NoNewline;
            write-host -ForegroundColor DarkGreen "$($stats.transferred)" -NoNewline;
            write-host -ForegroundColor Cyan "/" -NoNewline;
            write-host -ForegroundColor DarkGreen "$($stats.Total)" -NoNewline;
            write-host -ForegroundColor blue ")" -NoNewline;
            write-host -ForegroundColor blue "]" -NoNewline;
            write-host -ForegroundColor blue "$([char]0x2524)" -NoNewline;
            write-host -ForegroundColor blue "$($stats.status)" -NoNewline;
            write-host -ForegroundColor DarkMagenta " $($stats.eta)"
        }
        else {
            write-host -ForegroundColor white "$(if($this.logdate -eq $true){$this.GetThemeUnicode("logtime")})$(if($this.logdate -eq $true){$this.datestring})" -NoNewline;
            write-host -ForegroundColor Magenta "]" -NoNewline;
            Write-Host -ForegroundColor magenta "$($this.GetThemeUnicode("logpointer"))" -NoNewline
            Write-Host -ForegroundColor blue "$($this.GetThemeUnicode("download"))" -NoNewline;
            write-host -foregroundcolor DarkYellow "$($this.buildprogressbar($stats.percent,$stats.barcount))" -NoNewline;
            write-host -ForegroundColor blue " [" -nonewline;
            write-host -ForegroundColor Magenta "$($this.GetThemeUnicode("bandwidth")) " -NoNewline;
            Write-Host -ForeGroundcolor DarkGray "$($stats.bandwidth)" -NoNewline;
            write-host -ForegroundColor Cyan " $([char]0x00BB) " -NoNewline;
            write-host -ForegroundColor Cyan "(" -NoNewline;
            write-host -ForegroundColor DarkGreen "$($stats.transferred)" -NoNewline;
            write-host -ForegroundColor Cyan "/" -NoNewline;
            write-host -ForegroundColor DarkGreen "$($stats.Total)" -NoNewline;
            write-host -ForegroundColor blue ")" -NoNewline;
            write-host -ForegroundColor blue "]" -NoNewline;
            write-host -ForegroundColor blue "$([char]0x2524)" -NoNewline;
            write-host -ForegroundColor Blue "$($stats.status)" -NoNewline;
            write-host -ForegroundColor DarkMagenta " $($stats.eta)"
        }
    }
}