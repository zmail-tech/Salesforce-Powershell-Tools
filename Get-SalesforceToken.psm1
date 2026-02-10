<#
.SYNOPSIS
    Retrieves an access token from Salesforce using Client Credentials flow.

.DESCRIPTION
    This function authenticates with a Salesforce Connected App using the OAuth 2.0 Client Credentials Grant flow.
    It returns the access token string required for making API calls.

.PARAMETER clientId
    The client ID of the Salesforce Connected App.

.PARAMETER clientSecret
    The client secret of the Salesforce Connected App. Must be provided as a SecureString.

.PARAMETER endpoint
    The base URL of the Salesforce instance (e.g., https://yourorg.my.salesforce.com).

.EXAMPLE
    $secret = ConvertTo-SecureString -String "MySecret" -AsPlainText -Force
    $token = Get-SalesforceToken -clientId "MyAppID" -clientSecret $secret -endpoint "https://myorg.my.salesforce.com"
    Write-Host $token
#>

function Get-SalesforceToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$clientId,

        [Parameter(Mandatory=$true)]
        [string]$clientSecret,

        [Parameter(Mandatory=$true)]
        [string]$endpoint
    )

    $postRequest = @{
        Uri = "$endpoint/services/oauth2/token?grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret"
        Method = 'POST'
        Headers = $headers
    }

    $response = Invoke-RestMethod @postRequest
    $accessToken = $response.access_token

    # Return the access token directly
    return $accessToken
}