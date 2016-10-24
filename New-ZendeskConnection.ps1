Function New-ZendeskConnection
{
  [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
      SupportsShouldProcess = $true, 
      PositionalBinding = $false,
  ConfirmImpact = 'Medium')]
  [OutputType('ZendestConnection')]
  Param
  (
    # The zendesk site - eg. CronusSupport.zendesk.com 
    [Parameter(Mandatory = $true)][string]
    $ZendeskSite,

    # Zendesk User Name - normaly the loginname to your ZendeskSite
    [Parameter(Mandatory = $true)][String]
    $ZendeskUser,

    # Zendesk Access token
    [Parameter(Mandatory = $true)][String]
    $ZendeskToken
  )
  
  Begin
  {
  }
  Process
  {
    $ZendeskURI = ('https://{0}/api/v2/' -f $ZendeskSite)
    $ZendeskHeaders = @{
      Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('{0}/token:{1}' -f ($ZendeskUser), ($ZendeskToken))))
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