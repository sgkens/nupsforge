using module ..\logtastic_lib.psm1
<#
.SYNOPSIS
Cmdlet function Write-LogTastic interface for LogTastic class.

.DESCRIPTION
Cmdlet function Write-LogTastic is an interface for the Logtastic psm1 lib. It allows you to custom log messages to the console and log file.

.PARAMETER Message
The log message to be written.

.PARAMETER Type
The type of the log message. Valid values are: 'error', 'success', 'info', 'complete', 'action'. Case-insensitive. (Optional)

.PARAMETER Name
The name to be associated with the log. (Optional) eg. [myname-icon-date]

.PARAMETER Unicode
Specifies char for the log name. (Optional) 

.PARAMETER SubMessage
Switch parameter to indicate if the message is a submessage. (Optional)

.PARAMETER NoDatTime
Switch parameter to indicate if the message should include the date and time. (Optional)

.PARAMETER NoLogIcon
Switch parameter to indicate if the message should include the log icon. (Optional)

.EXAMPLE
Write-LogTastic -Message "This is an information message" -Type "info" -Name "Log1"

This example writes an information message to the log file with the name "Log1".

.INPUTS
None.

.OUTPUTS
None. The function does not return any output. writes to console and log file. [Write-Host] is the method used to write to console.

.NOTES
- 

.LINK
logtastic (Module): https://github.com/sgkens/logtastic
#>
Function Write-LogTastic(){
    [alias("wlt")]
    [CmdletBinding()]
    [OutPutType([void])]
    param(
        [Alias('m')]
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet('Error', 'Success', 'Info', 'Complete', 'Action', IgnoreCase = $true)]
        [alias('t')]
        [string]$Type = 'info',
        [Parameter(Mandatory = $false)]
        [alias('n')]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [alias('uc')]
        [string]$Unicode,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('sm')]
        [switch]$SubMessage = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('ndt')]
        [switch]$NoDateTime = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('nli')]
        [switch]$NoLogIcon = $false,
        [Parameter (ValueFromPipeline = $true, Mandatory = $false)]
        [alias('et')]
        [switch]$NoExectime
    )
    process{
        # Fetch the logtastic instance
        $lti = Get-LogTasticModuleInstance

        # Enable or disable exectime
        if ($NoExectime  ) { $lti.DisableExectime() }
        else { $lti.EnableExectime() }

        # Set the log name
        if($null -eq $name -or $name.length -eq 0 ) { $name = "logt" }
        $lti.name = $name # Default lt
        
        # Set the unicode char
        if($null -ne $unicode -and $unicode.length -gt 0 ) { $lti.unicode = $unicode }
        else{ $lti.Unicode = "#1F365" }

        # Set the log type
        if($NoDateTime -eq $true){ $lti.disablelogdate() }
        else { $lti.enablelogdate() }

        # Set the log type
        if($NoLogIcon -eq $true){ $lti.disablelogicon() }
        else{ $lti.enablelogicon() }

        # Write the message
        $lti.WriteLog($message, $type, $submessage)
    }
}
Export-ModuleMember -Function Write-LogTastic