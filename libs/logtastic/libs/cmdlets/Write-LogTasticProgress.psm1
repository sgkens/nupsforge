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
Function Write-LogTasticProgress() {
    [CmdletBinding()]
    [OutPutType([void])]
    param(
      [Parameter(Mandatory = $true, Position = 0)]
      [int]$barcount,
      [Parameter(Mandatory = $true, Position = 1)]
      [int]$percent,
      [Parameter(Mandatory = $false)]
      [string]$name,
      [Parameter(Mandatory = $false)]
      [string]$status,
      [Parameter(Mandatory = $false)]
      [switch]$submessage = $false,
      [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
      [string]$total,
      [Parameter(Mandatory = $false)]
      [String]$bandwidth,
      [Parameter(Mandatory = $false)]
      [string]$transferred,
      [Parameter(Mandatory = $false)]
      [string]$eta,
      [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
      [switch]$NoDateTime,
      [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
      [switch]$NoLogIcon

    )
    process{
        # Fetch the logtastic instance
        $lti = Get-LogTasticModuleInstance

        # disable exectime
        $lti.DisableExectime()

        if($submessage){$submessage = $true} else {$submessage = $false}

        # Set the log name
        if($null -eq $name -or $name.length -eq 0 ) { $name = "logt" }
        $lti.name = $name # Default lt
        
        # Set the unicode char
        if($unicode -eq $true) { $lti.unicode = $unicode }
        else{ $lti.Unicode = "#1F365" }

        # Set the log type
        if($NoDateTime -eq $true){ $lti.disablelogdate() }
        else { $lti.enablelogdate() }

        # Set the log type
        if($NoLogIcon -eq $true){ $lti.disablelogicon() }
        else{ $lti.enablelogicon() }

        $Props = [PSCustomObject]@{
          barcount    = [int]$barcount
          percent     = [int]$percent
          status      = [String]$status
          submessage  = [Bool]$submessage
          total       = [String]$total
          bandwidth   = [String]$bandwidth
          transferred = [String]$transferred
          eta         = [String]$eta
        }

        # Write the message
        $lti.Writeprogress($Props)
    }
}
Export-ModuleMember -Function Write-LogTasticProgress
