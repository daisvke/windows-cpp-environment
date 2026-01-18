# Mute Windows Sandbox system audio
# Log file is generated at $log

$log = "C:\Users\WDAGUtilityAccount\Desktop\WindowsSandbox\setup-log.txt"
"=== Script started $(Get-Date) ===" | Out-File -FilePath $log -Encoding utf8

try {
	# Mute audio by sending Volume Down keys
	$wshell = New-Object -ComObject WScript.Shell

	# Press Volume Down multiple times to ensure silence
	$wshell.SendKeys([char]173)
	$wshell.SendKeys([char]173)
	$wshell.SendKeys([char]173)

	"System audio set to mute" | Out-File -FilePath $log -Encoding utf8 -Append
}
catch {
    "Error during audio muting: $($_.Exception.Message)" | Out-File -FilePath $log -Encoding utf8 -Append
}