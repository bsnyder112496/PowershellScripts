$Groups = Get-ADGroup -Properties name -Filter name -SearchBase "DC=sfcu,DC=local" 
Foreach($G In $Groups)
{
    Write-Host $G.Name
    Write-Host "-------------"
    $G.Members
}

read-host 'press enter to continue'