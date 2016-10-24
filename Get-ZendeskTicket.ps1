function Get-ZendeskTicket
{
  <#
      .Synopsis
      Retives one or mre tickets from Zendesk and return them as Powershell Objects
    
      .DESCRIPTION
      Nothing yet...

      .EXAMPLE
      This retives all tickets from Zendesk

      $Zendesk = New-ZendeskConnection -ZendeskSite captosupport.zendesk.com -ZendeskUser <ZendeskUser> -ZendeskToken <TOKEN> -Verbose
      Get-ZendeskTicket -ZendeskConnection $Zendesk 

      .EXAMPLE
      This retives all ticket #75 from Zendesk

      $Zendesk = New-ZendeskConnection -ZendeskSite captosupport.zendesk.com -ZendeskUser <ZendeskUser> -ZendeskToken <TOKEN> -Verbose
      Get-ZendeskTicket -ZendeskConnection $Zendesk -TicketID 75
    
      .EXAMPLE
      This return three tickets
    
      $Zendesk = New-ZendeskConnection -ZendeskSite captosupport.zendesk.com -ZendeskUser <ZendeskUser> -ZendeskToken <TOKEN> -Verbose
      Get-ZendeskTicket -ZendeskConnection $Zendesk -TicketID 75,76,77
    

      .INPUTS
      Inputs to this cmdlet (if any)
      .OUTPUTS
      One or more Tickets as posershell objects
    
      .NOTES
      This function is not yet complete. At the moment I cant get it to return multiple tickets when using -TicketID 75,76,77
      .COMPONENT
      PS-Zendesk
  #>
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
