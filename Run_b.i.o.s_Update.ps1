if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

read-host 'Press Enter to run BIOS update'
$Bios = Get-ChildItem C:\temp -Recurse | Where-Object {$_.name -match 'bios|optiplex|dell|opti|plex'} | foreach { $_.Name }

Start-Process -FilePath C:\temp\$bios