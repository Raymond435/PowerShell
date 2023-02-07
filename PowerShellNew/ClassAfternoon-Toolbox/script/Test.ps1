function global:Get-Kill {
    param (
        $Mode
    )
    if ($Mode -eq "Hard") {
        $e = $_.Exception.GetType().FullName
        $line = $_.InvocationInfo.ScriptLineNumber
        $msg = $_.Exception.Message
        Write-Output "$(Get-Date -Format "HH:mm")[Error]: Initialization failed at line [$line] due [$e] `n`nwith details `n`n[$msg]`n"
        Write-Output "`n`n------------------END ROOT-------------------------"
        Stop-Transcript | Out-Null
        ClearCreateCSV
        exit
    }else{
        Write-Output "`n`n------------------END ROOT-------------------------"
        Stop-Transcript | Out-Null
        ClearCreateCSV
        exit
    }
    
}