# Default csv filepath is C:\Users\Administrator\scripts\creds.csv ; Modify accordingly

if (-Not (Test-Path C:\Users\Administrator\scripts\creds.csv)){
	$User = Read-Host "Type in the full username to add `n"
	$Password = Read-Host -AsSecureString "Type in password for this user `n"
}
else {
	$csv = Import-CSV -Path C:\Users\Administrator\scripts\creds.csv
	$User = $csv.user
	$Password = $csv.NewPassword
}

New-ADUser -Name $User -SamAccountName $User.Trim() -AccountPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -Enabled $true
