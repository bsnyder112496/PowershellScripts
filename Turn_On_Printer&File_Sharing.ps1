if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Domain

Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled True -Profile Domain
