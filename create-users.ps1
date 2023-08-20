$PASSWORDS = "s0me_User@domain" #all the users will use a default password to connect #there are some length and complexity requirements for password
$USERS_LIST = Get-Content .\usernames.txt
# -------------------------------------

$password = ConvertTo-SecureString $PASSWORDS -AsPlainText -Force #security measure, protects confidential text by encrypting it and deleting it from computer memory after use
New-ADOrganizationalUnit -Name _USERS  -ProtectedFromAccidentalDeletion $false # just like we created ADMINS organizational unit, we'll be adding USERS, _ added cuz Users already exists

foreach ($user in $USERS_LIST){
    $first_name = $user.Split(" ")[0].ToLower()
    $last_name = $user.Split(" ")[1].ToLower()
    # then create the username by concatenating the intials of the first to the last name:
    $username = "$($first_name.Substring(0,1))$($last_name)".ToLower()

    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor White
    New-ADUser -AccountPassword $password -GivenName $first_name -Surname $last_name -DisplayName $username -Name $username -PasswordNeverExpires $true -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" -Enabled $true
}
