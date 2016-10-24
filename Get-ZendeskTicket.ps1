function Get-ZendeskTicket
{
  [CmdletBinding()]
  [OutputType('ZendestTicket[]')]
  Param
  (
    # A ZendeskConnection object
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [Object]$ZendeskConnection,

    # a ticketnumber
    [Parameter(Mandatory = $true)][int[]]$TicketID
  )
  Begin
  {
    $Headers = $ZendeskConnection.ZendeskHeaders
  }
  process
  {
    if (!$TicketID) 
    { 
      $URI = $ZendeskConnection.ZendeskURI + 'tickets.json'
      return Invoke-RestMethod -Uri ('{0}' -f $URI) -Method 'GET' -Headers $Headers
    }
    else 
    {
      if ($TicketID.Count -eq 1)
      {
        $URI = $ZendeskConnection.ZendeskURI + 'tickets/' + $TicketID + '.json'
        return Invoke-RestMethod -Uri ('{0}' -f $URI) -Method 'GET' -Headers $Headers  
      }    
      else
      { 
        foreach ($Number in $TicketID)
        {
          $ids = $ids + ('{0},' -f $Number)
        }
        $URI = $ZendeskConnection.ZendeskURI + 'tickets/show_many.json?ids=' + $ids
        return Invoke-RestMethod -Uri ('{0}' -f $URI) -Method 'GET' -Headers $Headers
      }
    }
  }
  end
  {
  }
}