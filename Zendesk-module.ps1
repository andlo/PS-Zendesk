#requires -Version 3.0
<#
    .Synopsis
    Creates a connectionstring to Zendesk
    
    .DESCRIPTION
    Nothing yet...

    .EXAMPLE
    
    $Zendesk = New-ZendeskConnection -ZendeskSite captosupport.zendesk.com -ZendeskUser <ZendeskUser> -ZendeskToken <TOKEN> -Verbose
    
    .INPUTS
    Inputs to this cmdlet (if any)
    
    .OUTPUTS
    A ZendeskConnection Object    
    .NOTES
    This function is not yet complete. At the moment it only auhenticates using token
    .COMPONENT
    PS-Zendesk
#>

Function New-ZendeskConnection
{
  [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
      SupportsShouldProcess = $true, 
      PositionalBinding = $false,
  ConfirmImpact = 'Medium')]
  [Alias()]
  [OutputType('ZendestConnection')]
  Param
  (
    # The zendesk site - eg. CronusSupport.zendesk.com 
    [string]
    $ZendeskSite,

    # Zendesk User Name - normaly the loginname to your ZendeskSite
    [String]
    $ZendeskUser,

    # Zendesk Access token
    [String]
    $ZendeskToken
  )
  
  Begin
  {
  }
  Process
  {
    $ZendeskURI = "https://$ZendeskSite/api/v2/"
    $ZendeskHeaders = @{
      Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($ZendeskUser)/token:$($ZendeskToken)"))
    }        
  }
  End
  {
    Return [PSCustomObject]@{
      ZendeskURI     = $ZendeskURI
      ZendeskHeaders = $ZendeskHeaders
    }
  }
}
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
    
    .INPUTS
    Inputs to this cmdlet (if any)
    .OUTPUTS
    One or more Tickets as posershell objects
    
    .NOTES
    This function is not yet complete. At the moment I cant get it to return multiple tickets when using -TicketID 75,76,77
    .COMPONENT
    PS-Zendesk
#>
function Get-ZendeskTicket
{
  [CmdletBinding()]
  [Alias()]
  [OutputType('ZendestTicket[]')]
  Param
  (
    # A ZendeskConnection object
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    $ZendeskConnection,

    # a ticketnumber
    [int[]]$TicketID
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
      return Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers $Headers
    }
    else 
    {
      if ($TicketID.Count -eq 1)
      {
        $URI = $ZendeskConnection.ZendeskURI + 'tickets/' + $TicketID + '.json'
        return Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers $Headers  
      }    
      else
      { 
        foreach ($Number in $TicketID)
        {
          $ids = $ids + "$Number," 
        }
        $URI = $ZendeskConnection.ZendeskURI + 'tickets/show_many.json?ids=' + $ids
        return Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers $Headers
      }
    }
  }
  end
  {
  }
}

<#
    .Synopsis
    Searching Zendesk
    
    .DESCRIPTION
    Nothing yet...

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query 3245227 

    The ticket with the id 3245227
    .EXAMPLE 
    Search-Zendesk -ZendeskConection <Connection> -query Greenbriar

    Any record with the word Greenbriar

    .EXAMPLE 
    Search-Zendesk -ZendeskConection <Connection> -query type:user "Jane Doe"

    User records with the exact string "Jane Doe"

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query type:ticket status:open

    Open tickets

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query type:organization created<2015-05-01

    Organizations created before May 1, 2015

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query status<solved requester:user@domain.com type:ticket
    
    Unsolved tickets requested by user@domain.com

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query type:user tags:premium_support

    Users tagged with premium_support

    .EXAMPLE
    Search-Zendesk -ZendeskConection <Connection> -query created>2012-07-17 type:ticket organization:"MD Photo"
    
    Tickets created in the MD Photo org after July 17, 2012
    
    .INPUTS
    Inputs to this cmdlet (if any)
    
    .OUTPUTS
    A ZendeskSearchResult Object    
    .NOTES
    This function is not yet complete. 
    
    .COMPONENT
    PS-Zendesk
#>
Function Search-Zendesk
{
  [CmdletBinding()]
  [Alias()]
  [OutputType('ZendeskSearchResultget')]
  Param
  (
    # A ZendeskConnection object
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    $ZendeskConnection,

    # Search String
    [string]$Query
  )
  Begin
  {
    $Headers = $ZendeskConnection.ZendeskHeaders
  }
  process
  {
    #GET /api/v2/search.json?query={search_string}
    $URI = $ZendeskConnection.ZendeskURI + 'search.json?query=' + $Query
    return Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers $Headers
  }
  end
  {
  }
}


