# Token Testing only

if(!(get-command coveralls)){
    throw [system.exception]::new("Unable to find converalls in $env:path")
    break;
}
coveralls.exe report --repo-token="$COVERALLS_REPO_TOKEN_NUPSFORGE"