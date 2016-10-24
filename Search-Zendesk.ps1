Function Search-Zendesk
{
  [CmdletBinding()]
  [OutputType('ZendeskSearchResultget')]
  Param
  (
    # A ZendeskConnection object
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [Object]$ZendeskConnection,

    # Search String
    [Parameter(Mandatory = $true)][string]$Query
  )
  Begin
  {
    $Headers = $ZendeskConnection.ZendeskHeaders
  }
  process
  {
    try
    {
      $URI = $ZendeskConnection.ZendeskURI + 'search.json?query=' + $Query
      return Invoke-RestMethod -Uri ('{0}' -f $URI) -Method 'GET' -Headers $Headers
    }
    catch 
    {
      if ($_.ErrorDetails) 
      {
        Write-Error -Message $_.ErrorDetails.Message
      } 
      else 
      {
        Write-Error -Message $_
      }
    }
  }
  end
  {
  }
}