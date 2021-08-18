

Set-ExecutionPolicy -ExecutionPolicy remotesigned -Scope localmachine




Copy-Item -Path "I:\Public\regedits" -Destination "C:\temp\tempregedit" -Recurse



Get-ChildItem 'C:\temp\tempregedit' | ForEach-Object {
  & $_.FullName
}

Remove-Item C:\temp\tempregedit

Read-Host 'Press Enter To Continue'