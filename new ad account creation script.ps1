if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$samaccount_to_copy = Read-Host 'Please Enter Username of Account You Are Copying From'
$new_samaccountname = read-host "Please Enter New User's Username (lastname + first initial)"
$new_displayname = $new_samaccountname
$new_firstname = Read-Host "Enter New User's First name"
$new_lastname = Read-Host "Enter New User's Last name"
$new_name = $new_samaccountname
$new_user_logon_name = $new_samaccountname
$new_password = '!SecretSecret!'
$enable_user_after_creation = $true
$password_never_expires = $false
$cannot_change_password = $false


$ad_account_to_copy = Get-Aduser $samaccount_to_copy -Properties StreetAddress,City,Title,PostalCode,Office,Department,Manager,memberof,description

$params = @{'SamAccountName' = $new_samaccountname;
            'Instance' = $ad_account_to_copy;
            'DisplayName' = ($new_firstname + ' ' + $new_lastname);
            'GivenName' = $new_firstname;
            'SurName' = $new_lastname;
            'PasswordNeverExpires' = $password_never_expires;
            'CannotChangePassword' = $cannot_change_password;
            'Enabled' = $enable_user_after_creation;
            'UserPrincipalName' = $new_user_logon_name;
            'EmailAddress' = ($new_samaccountname + '@securitycu.org')
            'AccountPassword' = (ConvertTo-SecureString -AsPlainText $new_password -Force);
            }

## Create the new user account
New-ADUser -Name $new_name @params

## Mirror all the groups the original account was a member of
$ad_account_to_copy.Memberof | % {Add-ADGroupMember $_ $new_samaccountname } 

#remove new user from union-opeiu, as new members should not be in that group
Remove-ADGroupMember -Identity union-opeiu -Members $new_samaccountname

## Move the new user account into the assigned OU
Get-ADUser $new_samaccountname| Move-ADObject -TargetPath 'OU=SCU_Users,DC=SFCU,dc=local'

#set users start date
Read-Host "Press Enter to open a calender and pick the user's start date"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 243, 230
    Text          = 'Select a Date'
    Topmost       = $true
}

$calendar = New-Object Windows.Forms.MonthCalendar -Property @{
    ShowTodayCircle   = $false
    MaxSelectionCount = 1
}
$form.Controls.Add($calendar)

$okButton = New-Object Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 38, 165
    Size         = New-Object Drawing.Size 75, 23
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
}
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 113, 165
    Size         = New-Object Drawing.Size 75, 23
    Text         = 'Cancel'
    DialogResult = [Windows.Forms.DialogResult]::Cancel
}
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$result = $form.ShowDialog()

if ($result -eq [Windows.Forms.DialogResult]::OK) {
    $date = $calendar.SelectionStart
    Write-Host "Start Date Selected: $($date.ToShortDateString())"
}
Set-ADUser -Identity $new_samaccountname -Add @{extensionAttribute3=$($date.ToShortDateString())}

#set exchange properties
Set-ADUser -Identity $new_samaccountname -Replace @{MailNickName = $new_samaccountname}
Set-ADUser -Identity $new_samaccountname -Add @{proxyAddresses=('SMTP:' + $new_samaccountname + '@securitycu.org')}
Set-ADUser -Identity $new_samaccountname -Add @{targetAddress=('SMTP:' + $new_samaccountname + '@securitycreditunion.onmicrosoft.com')}

#set H: drive
Set-ADUser -Identity $new_samaccountname -HomeDirectory \\adminfs1\dfs\users\personalfolder\%username% -HomeDrive H;


#make user change password at next logon
Set-ADUser -Identity $new_samaccountname -ChangePasswordAtLogon $true

#set users logon script
set-ADuser $new_samaccountname -ScriptPath SCU.bat


Write-Host "$new_samaccountname has been created in SCU_Users OU" -BackgroundColor white -ForegroundColor Black
Write-Host 'Password is !SecretSecret!' -BackgroundColor white -ForegroundColor red
Write-Host 'Do not forget about imaging and document processing setup!' -BackgroundColor white -ForegroundColor Black
Write-Host 'Do not forget to assign proper O365 licenses for email inbox' -BackgroundColor white -ForegroundColor Black
Write-Host 'Do not forget to modify exchange properties for users email' -BackgroundColor white -ForegroundColor Black
Read-Host 'Press Enter to Continue'


# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.FlushInputBuffer()   # Make sure buffered input doesn't "press a key" and skip the ReadKey().
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}

