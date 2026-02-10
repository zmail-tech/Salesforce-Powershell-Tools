# Salesforce PowerShell Modules

This repository contains two PowerShell modules (`Get-SalesforceRecords.psm1` and `Get-SalesforceToken.psm1`) for interacting with the Salesforce API.

## Overview

These modules provide functions to authenticate with Salesforce using the OAuth 2.0 Client Credentials flow and retrieve data using SOQL queries.

## Modules

### Get-SalesforceToken

Retrieves an access token from Salesforce using the OAuth 2.0 Client Credentials Grant flow.

**Function:** `Get-SalesforceToken`

**Parameters:**
- `clientId` (String): The client ID of the Salesforce Connected App.
- `clientSecret` (String): The client secret of the Salesforce Connected App. Must be provided as a SecureString.
- `endpoint` (String): The base URL of the Salesforce instance (e.g., `https://myorg.my.salesforce.com`).

**Example Usage:**
```powershell
$secret = ConvertTo-SecureString -String "MySecret" -AsPlainText -Force
$token = Get-SalesforceToken -clientId "MyAppID" -clientSecret $secret -endpoint "https://myorg.my.salesforce.com"
Write-Host $token
```

### Get-SalesforceRecords

Retrieves Salesforce records based on the provided query and outputs them as a CSV file.

**Function:** `Get-SalesforceRecords`

**Parameters:**
- `clientId` (String): The Salesforce client ID for authentication.
- `clientSecret` (String): The Salesforce client secret for authentication.
- `endpoint` (String): The Salesforce API endpoint (e.g., `https://salesforce--dev.sandbox.my.salesforce.com`).
- `query` (String): The SOQL query to retrieve records from Salesforce.
- `fileName` (String): The name of the CSV file to store the retrieved records.
- `apiVersion` (String): The Salesforce API version to use (Default: `65.0`).

**Example Usage:**
```powershell
Get-SalesforceRecords -clientId "YourClientID" -clientSecret "YourClientSecret" -endpoint "https://salesforce--dev.sandbox.my.salesforce.com" -query "SELECT Id,Name,SobjectType FROM RecordType" -fileName "RecordTypes.csv"
```

## Installation

1. Place the `.psm1` files in your PowerShell module path.
   - On Windows, you can place them in `C:\Users\<YourUsername>\Documents\WindowsPowerShell\Modules\GetSalesforce\` or `$env:USERPROFILE\Documents\PowerShell\Modules\GetSalesforce\`.
2. Ensure you have the necessary modules imported.

**Importing the module:**
```powershell
Import-Module .\GetSalesforce.psd1
```

## Requirements

- PowerShell 5.1 or higher (or PowerShell Core 7+)
- Salesforce Connected App configured for Client Credentials flow
- Access to the Salesforce API

## License

This project is licensed under the MIT License.