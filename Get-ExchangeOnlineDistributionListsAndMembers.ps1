## Credentials
$Credentials = Get-Credential

## Connection into Office 365 Management
Connect-MsolService -Credential $Credentials

## Connection into Exchange Management
$MsoExchangeURL = "https://outlook.office365.com/powershell-liveid/"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $MsoExchangeURL -Credential $Credentials -Authentication Basic -AllowRedirection

## Import session allowing to override current commands
Import-PSSession $Session -DisableNameChecking

$Groups = Get-UnifiedGroup -ResultSize Unlimited
$Members = @()

Write-Host "Groups"

ForEach($Group in $Groups) {
    
    $GroupLinks  = Get-UnifiedGroupLinks -Identity $Group.Name -LinkType Members -ResultSize Unlimited
    
    ForEach($GroupLink in $GroupLinks) {

        $Members += New-Object -TypeName PSObject -Property @{
            Group = $Group.DisplayName
            Member = $GroupLink.Name
            EmailAddress = $GroupLink.PrimarySMTPAddress
            RecipientType= $GroupLink.RecipientType
        }

    }
}

$Members | Export-Csv "C:\Temp\ExchangeOnlineDLMembers.csv" -NoTypeInformation

$Members