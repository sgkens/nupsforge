using module libs\logtastic_lib.psm1
using module libs\cmdlets\Get-LogTasticModuleInstance.psm1
using module libs\cmdlets\New-LogTastic.psm1
using module libs\cmdlets\Write-LogTastic.psm1
using module libs\cmdlets\Write-LogTasticProgress.psm1

Export-ModuleMember -Function Write-LogTastic, Get-LogTasticModuleInstance, Write-LogTasticProgress, New-LogTastic
