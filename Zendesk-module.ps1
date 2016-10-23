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
      foreach ($Number in $TicketID)
      {
         $ids = $ids + "$Number," 
      }
      
      $URI = $ZendeskConnection.ZendeskURI + 'tickets/show_many.json?ids=' + $ids
      return Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers $Headers
    }
  }
  end
  {
  }
}
