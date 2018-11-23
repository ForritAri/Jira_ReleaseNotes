<#
Typical flow:

$a = Get-CHeader
Get-ReleaseNotes -pHeaders $a -pFixVersion "2018.3" -pBaseURI "https://jira.mycompany.com/rest/api/2/" | Out-file 2018.3-rn.txt
#>


function Get-CHeader {
	$creds = Get-Credential
	$user = $creds.UserName
	$pass = $creds.GetNetworkCredential().Password
	$pair = $user + ':' + $pass
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
	$basicAuthValue = "Basic $encodedCreds"
	$Headers = @{
		Authorization = $basicAuthValue
	}
	Write-Output $Headers
}


function Get-ReleaseNotes
{
	Param ([hashtable]$pHeaders, [string]$pFixVersion, [string]$pBaseURI)

	$my_issues = Invoke-RestMethod -Uri $pBaseURI+'search?jql=fixversion = '+$pFixVersion+' and "Release Comments" is not empty'  -Method get -ContentType "application/json" -Headers $pHeaders

	foreach ($issue in $my_issues.issues.GetEnumerator()) 
	{ 
		$ut = $ut + $issue.key, $issue.fields.customfield_17041
	}

		Write-Output $ut
}
