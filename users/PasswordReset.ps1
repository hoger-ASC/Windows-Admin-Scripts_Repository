# Default filepath for csv is C:\Users\Administrator\scripts\creds.csv ; Modify accordingly

$csv = Import-CSV -Path C:\Users\Administrator\scripts\creds.csv
Set-ADAccountPassword -Identity $csv.user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $csv.NewPassword -Force)
