#requires -Version 3.0 -Modules ActiveDirectory
$username = 'alo@capto.dk' 
$token = 'OAEkQmDl9UkSisxBHmwMGZWDQw9iKjkR91SIOXSC'
$params = @{
  Uri     = ' https://captosupport.zendesk.com/api/v2/tickets.json'
  Method  = 'Get'
  Headers = @{
    Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($username)/token:$($token)"))
  }
} 
$result = Invoke-RestMethod -Uri $params.Uri -Method $params.Method -Headers $params.Headers 
$result.tickets |
Where-Object -FilterScript {
  $_.Status -ne 'normal'
} |
Select-Object -Property id , subject , Description , Priority , status |
Sort-Object -Property priority |
Out-host

#SS
