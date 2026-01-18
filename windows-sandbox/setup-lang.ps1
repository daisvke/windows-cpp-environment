# PowerShell script to install French, Japanese and English (United Kingdom) keyboards

$log = "C:\Users\WDAGUtilityAccount\Desktop\WindowsSandbox\setup-log.txt"

try {
    # Create language list
    $LangList = New-WinUserLanguageList "fr-FR"
    $LangList.Add("ja-JP")
    $LangList.Add("en-GB")
    Set-WinUserLanguageList $LangList -Force

    "Languages added manually: fr-FR, ja-JP, en-GB" | Out-File -FilePath $log -Append
}
catch {
    "Error during language list setup: $($_.Exception.Message)" | Out-File -FilePath $log -Encoding utf8 -Append
}

try {
    if (Get-Command Set-WinUILanguageOverride -ErrorAction SilentlyContinue) {
        Set-WinUILanguageOverride -Language "fr-FR"
        "UI language override set to fr-FR" | Out-File -FilePath $log -Append
    } else {
        "Set-WinUILanguageOverride not available" | Out-File -FilePath $log -Encoding utf8 -Append
    }
}
catch {
    "Error during UI language setup: $($_.Exception.Message)" | Out-File -FilePath $log -Encoding utf8 -Append
}

try {
    if (Get-Command Set-WinSystemLocale -ErrorAction SilentlyContinue) {
        Set-WinSystemLocale -SystemLocale "fr-FR"
        "System locale set to fr-FR" | Out-File -FilePath $log -Append
    } else {
        "Set-WinSystemLocale not available" | Out-File -FilePath $log -Encoding utf8 -Append
    }
}
catch {
    "Error during system locale setup: $($_.Exception.Message)" | Out-File -FilePath $log -Encoding utf8 -Append
}

"=== Script finished $(Get-Date) ===" | Out-File -FilePath $log -Encoding utf8 -Append
