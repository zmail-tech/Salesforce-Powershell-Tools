<#
.SYNOPSIS
    Retrieves Salesforce records and outputs them as a CSV file.
.DESCRIPTION
    This function retrieves Salesforce records based on the provided query and outputs them as a CSV file.
    It uses the Salesforce API with an access token obtained from the provided client credentials.
.PARAMETER clientId
    The Salesforce client ID for authentication.
.PARAMETER clientSecret
    The Salesforce client secret for authentication.
.PARAMETER endpoint
    The Salesforce API endpoint (e.g., instance URL).
.PARAMETER query
    The SOQL query to retrieve records from Salesforce.
.PARAMETER fileName
    The name of the CSV file to store the retrieved records.
.EXAMPLE
    Get-SalesforceRecords -clientId "YourClientID" -clientSecret "YourClientSecret" -endpoint "https://salesforce--dev.sandbox.my.salesforce.com" -query "SELECT Id,Name,SobjectType FROM RecordType" -fileName "RecordTypes.csv"
#>

function Get-SalesforceRecords {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$clientId,

        [Parameter(Mandatory=$true)]
        [string]$clientSecret,

        [Parameter(Mandatory=$true)]
        [string]$endpoint,

        [Parameter(Mandatory=$true)]
        [string]$query,

        [Parameter(Mandatory=$true)]
        [string]$fileName,

        [Parameter]
        [string]$apiVersion = "65.0"
    )

    # Call the function to get the access token
    $accessToken = Get-SalesforceToken -clientId $clientId -clientSecret $clientSecret -endpoint $endpoint

    # Define headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")
    $headers.Add("Authorization", "Bearer $accessToken")

    # Initialize variables for pagination
    $allRecords = @()
    $url = "$endpoint/services/data/v$apiVersion/query/?q=$query"

    # Retrieve all pages of records
    do {
        # Invoke API
        $response = Invoke-RestMethod $url -Method 'GET' -Headers $headers
        
        # Add records to collection
        $allRecords += $response.records
        
        # Check if there are more records to retrieve
        if ($response.nextRecordsUrl) {
            $url = $endpoint + $response.nextRecordsUrl
        } else {
            $url = $null
        }
    } while ($url)

    # Filter out the 'attributes' property from all records
    $filteredOutput = $allRecords | ForEach-Object {
        $obj = $_
        $obj.PSObject.Properties.Remove("attributes") | Out-Null
        $obj
    }

    # Convert to CSV with lowercase headers
    $csvContent = $filteredOutput | ConvertTo-Csv -NoTypeInformation
    # Replace the header line with lowercase version
    $csvContent[0] = $csvContent[0].ToLower()
    
    # Output as CSV
    $csvContent | Out-File -FilePath "$fileName" -Encoding utf8

    # Return the total number of records retrieved
    Write-Output "Generated CSV file $fileName with $($allRecords.Count) records"
}

# Export the function
Export-ModuleMember -Function Get-SalesforceRecords