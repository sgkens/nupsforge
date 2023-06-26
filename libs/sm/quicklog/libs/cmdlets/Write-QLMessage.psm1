using module ..\quicklog_lib.psm1
<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: Write-QLMessage Cmdlet
##   AUTHER------: snoonx | nytscripts
#?   DESCRIPTION-: Cmdlet function Write-QLMessage interface for quicklog class.          
*?   DEPENDANCIES: quicklog 
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
** ******************************************************************************************************#>
Function Write-QLMessage ( ){
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet('error', 'success', 'info', 'complete', 'action',IgnoreCase = $true)]
        [string]$Type,
        [Parameter(Mandatory = $false)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Unicode,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false, Position = 4)]
        [switch]$SubMessage = $false
    )
    process {
        if($null -eq $name -or $name.length -eq 0 ) { $name = "ql" }
        $ql = [QuickLog]::new($name,$null)
        $ql.enablelogdate()
        if($null -ne $unicode -and $unicode.length -gt 0 ) { $ql.unicode = $unicode }
        else{ $ql.unicode = "#1F951" }
        $ql.WriteLog($message, $type, $submessage)   
    }
}
Export-ModuleMember -Function Write-QLMessage