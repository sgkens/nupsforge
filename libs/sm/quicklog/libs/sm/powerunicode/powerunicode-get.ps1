
    # enable class static prop
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # ======================================
    # make webrequest
    $req = Invoke-Webrequest -URI https://unicode.org/emoji/charts/full-emoji-list.html
    # convert html to PSObject for parsing
    $htmlObject = ConvertFrom-Html -Content $req.Content

    $unicodeIndex = @()

       $htmlObject = ConvertFrom-Html -Content $req.Content

        foreach ($node in $htmlObject.SelectSingleNode("//body").childnodes) {
            if($node.Attributes.name -eq 'class' -and $node.Attributes.Value -eq 'main'){
                foreach($subnode in $node.childnodes){
                    if($subnode.name -eq 'table'){
                        foreach($trnode in $subnode.childnodes){
                            if($trnode.name -eq 'tr'){
                                foreach($tdnode in $trnode.childnodes){
                                    #? Get Name from html table entry
                                    if($tdnode.Attributes.Name -eq "class" -and $tdnode.Attributes.value -eq "name"){
                                        # Unicode Name
                                        $name = $tdnode.innertext
                                        $unicode_label_string = $name -replace ' ', '_' -replace '“', '' -replace '-', '_' -replace ':', '' -replace '\(', '' -replace '\)', ''
                                        $unicode_label_string = $unicode_label_string -replace '__','' -replace '!','' -replace ';','' -replace '⊛_','' -replace '”','' -replace '⊛ ',''

                                    }
                                    #? get unicode value from html table entry
                                    if($tdnode.Attributes.Name -eq "class" -and $tdnode.Attributes.value -eq "code"){
                                        # Unicode Name
                                        # ? Codes with Multipla values
                                        if($tdnode.childnodes[0].innertext -like "* *" -and $tdnode.childnodes[0].innertext -notlike "*flag*" ){
                                            $unicode = $tdnode.childnodes[0].innertext
                                        }
                                        #? Code with single unicode value
                                        elseif ($tdnode.childnodes[0].innertext -notlike "*flag*" ){
                                           $unicode = $tdnode.childnodes[0].innertext.tostring()
                                        }
                                        else{

                                        }

                                    }
                                }
                                # populate hastable array with unicode objects
                                $unicodeIndex += new-object -TypeName psobject -Property @{
                                    label = $name
                                    unicode = $unicode
                                    name = $unicode_label_string
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
$unicodeIndex | where-object { $_.name -notlike "*flag*" } | convertto-json | Out-File .\unicode-index.json