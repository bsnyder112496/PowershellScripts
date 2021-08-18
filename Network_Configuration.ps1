if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
Set-ExecutionPolicy remotesigned -Scope CurrentUser
Get-Netadapter
write-host ' '
write-host ' '
write-host ' '
write-host ' '
write-host ' '
write-host ' '
write-host ' '
#Turn off DHCP
$adaptername = Read-Host 'Please enter an adapter name from the furthest left row'
Set-NetIPInterface -InterfaceAlias $adaptername -Dhcp Disabled
Write-Host 'Disabling DHCP'
sleep 3
$intindex = Read-Host 'Please Enter the Interface Index Number Correlated With Your Adapter'
write-host ' '
write-host ' '
write-host ' '
write-host ' '
#Change IPv4 address
$ipv4address = read-host 'Please Enter your IP Address'
#Default Gateway
$defaultgateway = Read-Host 'Please Enter your default gateway'
#dns servers
$dns1 = '172.17.60.5'
$dns2 = '172.17.0.10'

$ipParams = @{
InterfaceIndex = $intindex
IPAddress = $ipv4address
PrefixLength = 24
DefaultGateway = $defaultgateway
AddressFamily = "IPv4"

}
New-NetIPAddress @ipParams


$dnsParams = @{
InterfaceIndex = $intindex
ServerAddresses = ($dns1,$dns2)
}
Set-DnsClientServerAddress @dnsParams


# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.FlushInputBuffer()   # Make sure buffered input doesn't "press a key" and skip the ReadKey().
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}