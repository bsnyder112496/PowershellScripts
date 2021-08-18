Get-ADUser -Filter 'enabled -eq $true' -Properties SamAccountname,DisplayName,memberof | % {
New-Object PSObject -Property @{
UserName = $_.DisplayName
oSamAccountname= $_.SamAccountname
Groups = ($_.memberof | Get-ADGroup | Select -ExpandProperty Name) -join 
","}
} | Select oSamAccountname,UserName,Groups | Export-Csv C:\Users\snyderb\Desktop\NETWORK_USERS.csv

Import-Csv C:\Users\snyderb\Desktop\NETWORK_USERS.csv | sort username -Descending | Export-Csv -Path C:\Users\snyderb\Desktop\NETWORK_USERS+GROUPS.csv -NoTypeInformation