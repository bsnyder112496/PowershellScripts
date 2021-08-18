$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "DC=sfcu,DC=local" 
Foreach($G In $Groups)
{
    Write-Host $G.name
    Write-Host "-------------"
    Write-Host " "
    $G.Members
}

read-host 'press enter to continue'

