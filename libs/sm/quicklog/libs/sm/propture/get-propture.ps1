<#  -------------------------------------------------------------------------------------------------------
/** ******************************************************************************************************* 
#!   NAME--------: propture
##   AUTHER------: mnoxx | codedus
#!   VERSION-----: 0.1
#?   DESCRIPTION-: Function used to extract a string from a string via regex and parse the data into hastable
#?                 it then returns the value in hastable data format
#?                 
*?   DEPENDANCIES:
*                  
##   BUILD ENV---: BUILD: Powershellcore 7.3.1
*?   LICENCE-----: MIT
*********************************************************************************************************#>
function Get-Propture( ){ }

function Get-ProptureSD( ) {
    param(
        [string]$stringdata
    )
    $stringdata= $stringdata -replace "\\", "/"
    $formatted_stringdata = $stringdata -replace ','," `n "
    $hashedtdata = ConvertFrom-StringData -StringData $formatted_stringdata

    return $hashedtdata

}

#$pt = get-propture -stringdata "my log messhae > @{pt:{Name=myfIle.html,size=100mb}} afsf isfisfas a console log messaage exablee @{pt:{prop1=myprob,prop2=mypoprb2}}"
#$pt
# get-proptureSD -stringdata "Name=G:\users\gsnow,size=100"