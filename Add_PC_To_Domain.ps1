if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
write-host 'Add pc to domain'
$pcname = read-host 'Please Enter the PC Name'
Add-Computer -ComputerName $pcname -LocalCredential $pcname\build -DomainName sfcu.local -Credential sfcu.local\snyderb-admin -Restart -Force

read-host 'press enter to continue'