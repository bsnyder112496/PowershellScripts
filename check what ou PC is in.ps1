$pcname = Read-Host 'Enter PC name to find what OU it is in'

((Get-ADComputer $pcname).DistinguishedName)


Read-Host 'Press Enter To Continue'

