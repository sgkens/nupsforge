using module libs\quicklog_lib.psm1
using module libs\cmdlets\Write-QLMessage.psm1

#! CLASS TESTING
# creat class call examplate
$quicklog = [QuickLog]::new("ql"<#NAME#>,$null<##>)
$quicklog.enablelogdate()
$quicklog.unicode = "#1F951"

# ACTION
$quicklog.WriteLog("Action Message", "action" , $false)
$quicklog.WriteLog("Action Message with propture test @{pt:{path=G:/devspace/projects/powershell/_repos/quicklog/libs/quicklog-example.ps1,parsevalue2=myvale2}}", "action" , $false)
$quicklog.WriteLog("Action Message with propture @{pt:{parsevalue1=myvale}} and custom quicklog logo", "action" , $false)
$quicklog.WriteLog("Action SubMessage", "action" , $true)
$quicklog.WriteLog("Action Message with propture @{pt:{unicode=#1F41F}} and custom quicklog logo and is a submessage", "action" , $true)

# INFO
$quicklog.WriteLog("info Message", "info" , $false)
$quicklog.WriteLog("info Message with propture @{pt:{path=G:/devspace/projects/powershell/_repos/quicklog/libs/quicklog-example.ps1}} @{pt:{parsevalue2=myvale2}}", "info" , $false)
$quicklog.WriteLog("info Message with propture @{pt:{parsevalue1=myvale}} and custom quicklog logo", "info" , $false)
$quicklog.WriteLog("info SubMessage", "info" , $true)
$quicklog.WriteLog("info Message with propture @{pt:{unicode=#1F41F}} and custom quicklog logo and is a submessage", "info" , $true)


#start-sleep -Seconds 3
# SUCCESS
$quicklog.WriteLog("success Message", "success" , $false)
$quicklog.WriteLog("success Message with propture @{pt:{path=G:/devspace/projects/powershell/_repos/quicklog/libs/quicklog-example.ps1}} @{pt:{parsevalue2=myvale2}}", "success" , $false)
$quicklog.WriteLog("success Message with propture @{pt:{parsevalue1=myvale}} and custom quicklog logo", "success" , $false)
$quicklog.WriteLog("success SubMessage", "success" , $true)
$quicklog.WriteLog("success Message with propture @{pt:{unicode=#1F41F}} and custom quicklog logo and is a submessage", "success" , $true)

# ERROR
$quicklog.WriteLog("error Message", "error" , $false)
$quicklog.WriteLog("error Message with propture @{pt:{path=G:/devspace/projects/powershell/_repos/quicklog/libs/quicklog-example.ps1}} @{pt:{parsevalue2=myvale2}}", "error" , $false)
$quicklog.WriteLog("error Message with propture @{pt:{parsevalue1=myvale}} and custom quicklog logo", "error", $false)
$quicklog.WriteLog("error SubMessage", "error" , $true)
$quicklog.WriteLog("error Message with propture @{pt:{unicode=#1F41F}} and custom quicklog logo and is a submessage", "error", $true)

# COMPLETE
$quicklog.WriteLog("complete Message", "complete" , $false)
$quicklog.WriteLog("complete Message with propture @{pt:{path=G:/devspace/projects/powershell/_repos/quicklog/libs/quicklog-example.ps1}} @{pt:{parsevalue2=myvale2}}", "complete" , $false)
$quicklog.WriteLog("complete Message with propture @{pt:{parsevalue1=myvale}} and custom quicklog logo", "complete" , $false)
$quicklog.WriteLog("complete SubMessage", "complete" , $true)
$quicklog.WriteLog("complete Message with propture @{pt:{unicode=#1F41F}} and custom quicklog logo and is a submessage", "complete", $true)

#PROGRESS BAR
$quicklog.Writeprogress(@{"item" = "item1"; "percent" = 10; "status" = "status1"; "submessage" = $false })
$quicklog.Writeprogress(@{"item" = "item1"; "percent" = 20; "status" = "status1"; "submessage" = $false })
$quicklog.Writeprogress(@{"item" = "item1"; "percent" = 30; "status" = "status1"; "submessage" = $false })
#$quicklog.Writeprogress(@{"item" = "item1"; "percent" = 10; "status" = "status1"; "submessage" = $true })



#! CMDLET TESTING

#! Action
Write-QLMessage -Message "Action Message" -Name "ql" -Type "action"
Write-QLMessage -Message "Action Message Custom unicode" -Name "ql" -Type "action" -Unicode "#1F951"
Write-QLMessage -Message "Action SubMessage" -Name "ql" -Type "action" -SubMessage
Write-QLMessage -Message "Action Message with proture @{pt:{prop=provalue}}" -Name "ql" -Type "action"

#! Info
Write-QLMessage -Message "Info Message" -Name "ql" -Type "Info"
Write-QLMessage -Message "Info Message Custom unicode" -Name "ql" -Type "Info" -Unicode "#1F951"
Write-QLMessage -Message "Info SubMessage" -Name "ql" -Type "Info" -SubMessage
Write-QLMessage -Message "Info Message with proture @{pt:{prop=provalue}}" -Name "ql" -Type "Info"

#! success
Write-QLMessage -Message "success Message" -Name "ql" -Type "success"
Write-QLMessage -Message "success Message Custom unicode" -Name "ql" -Type "success" -Unicode "#1F951"
Write-QLMessage -Message "success SubMessage" -Name "ql" -Type "success" -SubMessage
Write-QLMessage -Message "success Message with proture @{pt:{prop=provalue}}" -Name "ql" -Type "success"


#! error
Write-QLMessage -Message "error Message" -Name "ql" -Type "error"
Write-QLMessage -Message "error Message Custom unicode" -Name "ql" -Type "error" -Unicode "#1F951"
Write-QLMessage -Message "error SubMessage" -Name "ql" -Type "error" -SubMessage
Write-QLMessage -Message "error Message with proture @{pt:{error=errorvalue}}" -Name "ql" -Type "error"

#! complete
Write-QLMessage -Message "complete Message" -Name "ql" -Type "complete"
Write-QLMessage -Message "complete Message Custom unicode" -Name "ql" -Type "complete" -Unicode "#1F951"
Write-QLMessage -Message "complete SubMessage" -Name "ql" -Type "complete" -SubMessage
Write-QLMessage -Message "complete Message with proture @{pt:{prop=provalue}}" -Name "ql" -Type "complete"

# Write-QLM - Full message call class method message
# Write-QLInfo - Auto Set Info
# Write-QLError - Auto Set Error
# Write-QLComplete - Auto Set Complete
# Write-QLSuccess - Auto Set Success
# Write-QLAction - Auto Set Action






