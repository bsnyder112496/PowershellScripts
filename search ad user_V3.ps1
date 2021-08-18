$SearchName = Read-Host 'Enter name to search for'
$SearchResults = Get-Aduser -Filter "anr -like '$SearchName'"
 
If($SearchResults.GetType().Name -ne "Object[]"){
CLS;Get-ADUser -Identity $SearchResults.samaccountname -Properties * | fl
}else
{$menu = @{}
for ($i=1;$i -le $SearchResults.count; $i++) {
Write-Host "$i. $($SearchResults[$i-1].name)" -ForegroundColor Green
$menu.Add($i,($SearchResults[$i-1].samaccountname))
}
[int]$ans = Read-Host 'Enter selection'
$selection = $menu.Item($ans)
Get-ADUser -Identity $selection -Properties SamAccountName | fl
}


$easyusername = $SearchResults| Select name -ExpandProperty Name
$easyusername2 = $selection | Select name -ExpandProperty Name

$easyusername
$easyusername2