<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: Get-Elapsed
##   AUTHER------: mnoxx | codedus
#!   VERSION-----: 0.1.0
#?   DESCRIPTION-: Simple function return elapsed time from datetime
#?                  
#?                 
*?   SUNMODULES--: 
*            
##   BUILD ENV---: BUILD: Powershellcore 7.3.3
*?   LICENCE-----: MIT
*********************************************************************************************************#>
function Get-Elapsed() {
    param(
        [datetime] $Datetime,
        [Parameter(ValueFromPipeline = $true)][switch] $Formattedstring = $false

    )
    $timespan = new-timespan -start $datetime

    $timespan_f = [pscustomobject]@{}
    # add members by default
    $timespan_f | add-member -membertype noteproperty -name 'milliseconds' -value "$( [math]::round($timespan.milliseconds, 0) )Ms"
    $timespan_f | add-member -membertype noteproperty -name 'seconds' -value "$( [math]::round($timespan.totalseconds, 0) )s"
    $timespan_f | add-member -membertype noteproperty -name 'minutes' -value "$( [math]::round($timespan.totalminutes, 0) )m"
    # if more than 1 hour, add hours
    if ($timespan.totalhours -gt 1) {
        $timespan_f | add-member -membertype noteproperty -name 'hours' -value "$( [math]::round($timespan.totalhours, 0) )h"
    }
    # if more than 1 day, add days
    if ($timespan.totaldays -gt 1) {
        $timespan_f | add-member -membertype noteproperty -name 'days' -value "$( [math]::round($timespan.totaldays, 0) )d"
    }
    if ($true -eq $Formattedstring) {
        [string]$timeblock # block string
        if ($timespan.totaldays -gt 1) { $timeblock += "$($timespan_f.days) " }
        if ($timespan.totalhours -gt 1) { $timeblock += "$($timespan_f.hours) " }
        $timeblock += "$($timespan_f.minutes) $($timespan_f.seconds) $($timespan_f.milliseconds)"
        return $timeblock
    }
    else {
        return $timespan_f
        
    }
}