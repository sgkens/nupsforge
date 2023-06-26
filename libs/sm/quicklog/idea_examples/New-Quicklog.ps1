using module .\sm\get-elapsed.psm1
using module .\sm\propture\get-propture.ps1 
using module .\sm\powerunicode\powerunicode.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: quicklog
##   AUTHER------: mnoxx | codedus
#!   VERSION-----: 0.1.0
#?   DESCRIPTION-: A Simple powershell script file to output log messages to console, script provides some costomization, wrapper for write-host
#?                 can be used for any script 
#?                 
*?   DEPENDANCIES:
*                  - Get-Elapsed
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
*********************************************************************************************************#>
function New-QuickLog() {
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Name,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('error', 'success', 'info', 'complete', 'action')]
        [string]$Type,
        [Parameter(Mandatory = $false, Position = 3)]
        [string]$Unicode,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false, Position = 4)]
        [switch]$SubMessage = $false
    )
    if ($message -like "*@{pt:{*") { $message_exploded = $message.split('@').split('}}') } else { $message_exploded = $null }
    if($null -eq $Unicode -or $unicode.length -eq 0 ){ $Unicode = "#1F438" }
    #TODO: Change to psobject 
    $unicodeError = "#1FAD6"
    $unicodeSuccess = "#1F350"
    $unicodeInfo = "#2615"
    $unicodeComplete = "#1F375"
    $unicodeAction = "#1F963"
    $unicodeSperator = "#2194"
    $unicodeLeftArrow = "#25B6"
    $unicodePlus = "#2795"
    $unicodeArrorDiagDown = "#2198"
    $unicodeDownCurvedArrow = "#21AA"
    $date = get-date 
    #TODO: change write-host to single line and use inline color statements
    write-host -ForegroundColor yellow "[" -nonewline;
    write-host "$([powerunicode]::printByUnicode($unicode))" -nonewline;
    write-host -ForegroundColor Magenta "-$name" -NoNewline;
    if($SubMessage -eq $true){
        write-host -ForegroundColor yellow "]" -NoNewline;
    }else{
        write-host -ForegroundColor yellow "]$([powerunicode]::printByUnicode($unicodeSperator))" -NoNewline;
    }
    if($SubMessage -eq $true){
        switch ($type) {
            success  { Write-Host -ForegroundColor green "      " -nonewline; }
            error    { Write-Host -ForegroundColor red "      " -nonewline; }
            info     { Write-Host -ForegroundColor blue "      " -nonewline; }
            complete { Write-Host -ForegroundColor darkgreen "      " -nonewline; }
            action   { Write-Host -ForegroundColor yellow "      " -nonewline; }
        }
    }else{
        switch ($type) {
            success  { Write-Host -ForegroundColor green     "$([powerunicode]::printByUnicode($unicodeSuccess)) $([powerunicode]::printByUnicode($unicodeLeftArrow)) " -nonewline; }
            error    { Write-Host -ForegroundColor red       "$([powerunicode]::printByUnicode($unicodeError)) $([powerunicode]::printByUnicode($unicodeLeftArrow)) " -nonewline; }
            info     { Write-Host -ForegroundColor blue      "$([powerunicode]::printByUnicode($unicodeInfo)) $([powerunicode]::printByUnicode($unicodeLeftArrow)) " -nonewline; }
            complete { Write-Host -ForegroundColor darkgreen "$([powerunicode]::printByUnicode($unicodeComplete)) $([powerunicode]::printByUnicode($unicodeLeftArrow)) " -nonewline; }
            action   { Write-Host -ForegroundColor yellow    "$([powerunicode]::printByUnicode($unicodeAction)) $([powerunicode]::printByUnicode($unicodeLeftArrow)) " -nonewline; }    
        }
    }
    # Message Area ----------------
    if ($null -ne $message_exploded) {

        foreach ($emsp in $message_exploded) {
            if ($emsp -like "*{pt:{*") {
                $emsp_pt_removed = $emsp -replace "{pt:{", ""
                $props = Get-ProptureSD -stringdata $emsp_pt_removed
                foreach ($propname in $props.keys) {
                    $value = $props[$propname]
                    if ( $type -eq "error") {
                        write-host -foregroundColor Magenta "$propname" -nonewline; write-host ":" -nonewline; write-host "{ " -nonewline; write-host -foregroundColor darkgray "$value" -nonewline; write-host " } " -nonewline;
                    }
                    else {
                        write-host -foregroundColor Magenta "$propname" -nonewline; write-host ":" -nonewline; write-host "{ " -nonewline; write-host -foregroundColor darkgray "$value" -nonewline; write-host " } " -nonewline;
                    }
                }
            }
            else {
                if ( $type -eq "error") {
                    write-host -foregroundColor red $emsp -NoNewline;
                }
                else {
                    write-host $emsp -NoNewline; 
                }
            }
        }
    }
    elseif ($null -eq $message_exploded) {
        if ( $type -eq "error") {
            write-host -ForegroundColor red $message -nonewline;
        }
        else {
            write-host $message -nonewline;
        }
    }
    else {

    }
    # Message Area ----------------
    switch ($type) {
        success { Write-Host -ForegroundColor green " $([powerunicode]::printByUnicode($unicodeSperator)) S $(get-elapsed -Datetime $date -Formattedstring)" }
        error { Write-Host -ForegroundColor red " $([powerunicode]::printByUnicode($unicodeSperator)) E $(get-elapsed -Datetime $date -Formattedstring)" }
        info { Write-Host -ForegroundColor blue " $([powerunicode]::printByUnicode($unicodeSperator)) I $(get-elapsed -Datetime $date -Formattedstring)" }
        complete { Write-Host -ForegroundColor darkgreen " $([powerunicode]::printByUnicode($unicodeSperator)) C $(get-elapsed -Datetime $date -Formattedstring)" }
        action { Write-Host -ForegroundColor yellow " $([powerunicode]::printByUnicode($unicodeSperator)) A $(get-elapsed -Datetime $date -Formattedstring)" }
    }
    
}
