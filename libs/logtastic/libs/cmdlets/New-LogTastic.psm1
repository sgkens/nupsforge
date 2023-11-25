using module ..\logtastic_lib.psm1
<#
.SYNOPSIS
Returns and instance of the LogTastic class.

.DESCRIPTION
Returns and instance of the LogTastic class, providing access to the LogTastic methods.

.PARAMETER Name
Name of the log file. (Optional)

.PARAMETER Unicode
Specifies char for the log name. (Optional)

.EXAMPLE
$ltm = New-LogTastic -Name "Log1" -unicode $null
$ltm.enablelogdate()
$ltm.enablelogicon()
$ltm.WriteMessage("This is an information message", "info", $false)
$ltm.WriteMessage("This is an information message", "info", $true) # submessage

This example writes an information message to the log file with the name "Log1".

.INPUTS
None.

.OUTPUTS
returns an instance of the LogTastic class. [object]

.NOTES
- 

.LINK
logtastic (Module): https://github.com/sgkens/logtastic
#>
Function New-LogTastic() {
  [alias("nlt")]
  [CmdletBinding()]
  [OutPutType([object])]
  param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$name,
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Unicode,
    [Parameter(Mandatory = $false, Position = 2)]
    [string]$LogDate,
    [Parameter(Mandatory = $false, Position = 3)]
    [string]$LogIcon
  )
  process {
    if ($null -eq $name -or $name.length -eq 0 ) { $name = "ltm" }
    if ($null -eq $Unicode -or $Unicode.length -eq 0 ) { 
      $ltm = New-Object -TypeName Logtastic
      $ltm.disablelogicon()
    }else{
      $ltm = New-Object -TypeName Logtastic
      $ltm.enablelogdate()
      $ltm.enablelogicon()
    }
    return $ltm
  }
}
Export-ModuleMember -Function New-LogTastic