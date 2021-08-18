if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$date = Get-Date -Format "dddd MM/dd/yyyy"
$user = read-host 'Enter SCU Username (LAST NAME + FIRST INITIAL)' 

Set-ADAccountExpiration -Identity $user -DateTime ("$date" + ' ' + "18:00:00")


Get-ADUser -Identity $user -Properties accountexpirationdate | Select sAMAccountName, UserPrincipalName, AccountExpirationDate


#zip users H: drive and place it into //opsfs1/user archive
$source = "\\adminfs1\\dfs\users\PersonalFolder\$user"
$destination = "\\opsfs1\Users Archive\$user Archive.zip"
Add-Type -AssemblyName "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($source, $destination)

Write-Host 'User account is set to expire today at 6:00 pm'

Read-Host "User's H: drive was zipped into //opsfs1/user archive, press enter to continue"