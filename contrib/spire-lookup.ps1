$ErrorActionPreference = "Stop"

$inFile = Get-ChildItem $args[0]
$outFile = New-Item -ItemType File -Path "$($inFile.BaseName)-result$($inFile.Extension)"

foreach($row in (Import-Csv -Path $inFile)) {
  $userLookup = Get-ADUser -Filter "employeeID -eq $($row.spire_id) -and employeeType -like 'P*'" `
                           -Properties UserPrincipalName,msDS-ExternalDirectoryObjectId

  If ($userLookup -ne $null) {
    # External object IDs are prefixed with the object type
    # e.g. 'User_0d0d947f-25b0-4a5a-b9a8-0094d1221ca3'
    $uid = $userLookup.("msDS-ExternalDirectoryObjectId")
    If ($uid -ne $null) { $uid = $uid.split("_")[-1] }

    New-Object -TypeName PSObject -Property @{
      id = $row.id
      net_id = $userLookup.UserPrincipalName
      uid = $uid
    } | Export-Csv -Path $outFile -Append
  }
}
