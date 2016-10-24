Function Search-Zendesk
{
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
