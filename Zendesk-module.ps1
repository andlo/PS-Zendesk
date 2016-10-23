#requires -Version 3.0
<#
    .Synopsis
    Short description
    .DESCRIPTION
    Long description
    .EXAMPLE
    Example of how to use this cmdlet
    .EXAMPLE
    Another example of how to use this cmdlet
    .INPUTS
    Inputs to this cmdlet (if any)
    .OUTPUTS
    Output from this cmdlet (if any)
    .NOTES
    General notes
    .COMPONENT
    The component this cmdlet belongs to
    .ROLE
    The role this cmdlet belongs to
    .FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function New-ZendeskConnection
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
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-ZendeskTicket
{
  [CmdletBinding()]
  [Alias()]
  #[OutputType([int])]
  Param
  (
    # Param1 help description
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
    Position=0)]
    $ZendeskConnection,

    # Param2 help description
    [int]
    $TicketID
  )

  Begin
  {
  }
  Process
  {
  }
  End
  {
    $URI = ' ' + $ZendeskConnection.ZendeskURI + 'tickets.json' 
    $Headers = $ZendeskConnection.ZendeskHeaders
    Write-output "Return Invoke-RestMethod -Uri "$URI" -Method GET' -Headers 'yyyy'" 
    $Result = Invoke-RestMethod -Uri "$URI" -Method 'GET' -Headers "$Headers"
    $Result
  }
}
