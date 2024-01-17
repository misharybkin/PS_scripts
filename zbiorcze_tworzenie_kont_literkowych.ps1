Import-Module ActiveDirectory
Import-Module ExchangeOnlineManagement



# Читання вмісту .txt файлу
$content = Get-Content -Path "C:\Users\mr3\Desktop\tescik.txt" -Encoding UTF8 

# Вивід вмісту на екран
$content


$replaceMap = @{
    'ą' = 'a'
    'ć' = 'c'
    'ę' = 'e'
    'ł' = 'l'
    'ń' = 'n'
    'ó' = 'o'
    'ś' = 's'
    'ź' = 'z'
    'ż' = 'z'
}

function ReplacePolishLetters($text){
foreach ($key in $replaceMap.Keys) {
        $text = $text -replace $key, $replaceMap[$key]
    }
    return $text
}


$lines = Get-Content -Path "C:\Users\mr3\Desktop\tescik.txt" | Measure-Object -Line | Select-Object -ExpandProperty Lines 

for($i=0; $i -ne $lines; $i++){

    $line = Get-Content -Path "C:\Users\mr3\Desktop\tescik.txt" -Encoding UTF8 | Select-Object -Index $i
    
    $elements = $line -split '\s+'  # розділення рядка за пробілами (або іншим роздільником)
    $imie = $elements[0]
    $nazwisko = $elements[1]
    
    Write-Host "Imię użytkownika to:" $imie
        $login = $FirstName_notPl[0] + $LastName_notPl.ToLower()
        $SamAccountName = $login
        $UserPrincipalName = "$SamAccountName@lot.pl"
        $FirstName = "$imie"
        $LastName ="$nazwisko"
        $imie2 = "$imie"
        $nazwisko2 = "$nazwisko"
        $FirstName_notPl = ReplacePolishLetters($imie2).ToLower()
        $LastName_notPl = ReplacePolishLetters($nazwisko2)
        $email = $FirstName_notPl[0] + "." + $LastName_notPl.ToLower() + "@lot.pl"
        
        $DisplayName = "$LastName $FirstName"
        $Password = "Warszawa2023." | ConvertTo-SecureString -AsPlainText -Force
        $Description = "new test user"
        $OUPath = "OU=Internal,OU=Users,OU=Corporation,DC=ax,DC=lot,DC=pl"
        New-ADUser -SamAccountName $login -UserPrincipalName $UserPrincipalName -Name $DisplayName -GivenName $FirstName -Surname $LastName -DisplayName $DisplayName -Description $Description -AccountPassword $Password -Path $OUPath -OtherAttributes @{'extensionAttribute10'="SYNC"} -EmailAddress $email  -Enabled $true
        $userName = $SamAccountName
        #grupy podstawowe
        $groupNames = @("SEC_AZURE_SSPR", "SEC_AZURE_MFA")
        Write-Host "Użytkownik założony"
        $credentialFilePath = "D:\skrypty\AesKeyGenerator\newuser.txt"
        $AESKeyFilePath = "D:\skrypty\AesKeyGenerator\newuserAES.txt"
        $decryptMode = "AES"
        $AESKey = Get-Content $AESKeyFilePath

        $credFiles = Get-Content $credentialFilePath
        $adminuserName = $credFiles[0]
        $adminpassword = $credFiles[1] | ConvertTo-SecureString -Key $AESKey

        

        # Додавання користувача до групи
        foreach($groupName in $groupNames){
        Add-ADGroupMember -Identity $groupName -Members $userName
        
        
}

}

Invoke-Command -ComputerName ADCONNECTPDC.ax.lot.pl -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}


