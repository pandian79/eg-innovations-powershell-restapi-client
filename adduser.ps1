<#
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	.SYNOPSIS
	  Adding a User
	.DESCRIPTION
	  Use this API to add a user to the eG manager.
		Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Adding-a-User.htm
	.PARAMETER managerurl
		URL of the eG manager. E.g., http://192.168.8.8:7077
	.PARAMETER user
		valid user for the eG manager
	.PARAMETER pwd
		base64 encoded password
	.PARAMETER userrole
		User role
	.PARAMETER userid
		User ID
	.PARAMETER password
		Password for the user to be created
	.PARAMETER expirydate
		User expiry date in MM/DD/YYYY
	.PARAMETER alarmsbymail
		comma -separated list of Critical/Major /Minor alarms (or) All
	.PARAMETER to
		comma-separated list of Mail IDs/Mobile numbers
	.PARAMETER cc
		comma-separated list of Mail IDs/Mobile numbers
	.PARAMETER bcc
		comma-separated list of Mail IDs/Mobile numbers
	.INPUTS
	  None
	.OUTPUTS
	  Shows the confirmation or error
	.NOTES
	  Version:        1.0
	  Author:         pandian
	  Creation Date:  14 Oct 2021
	  Purpose/Change: Initial script development
	  
	.EXAMPLE
	  .\adduser.ps1  -managerurl https://192.168.10.20 -user admin -pwd cGFzc3dvcmQ= -userrole Admin -userid user1 -password password -expirydate 12/31/2021
#>

#-------------------get command line parameters----------------------
param (
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$managerurl, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$user, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$pwd, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$userrole, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$userid,
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$password,
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$expirydate,
	$alarmsbymail,
	$to,
	$cc,
	$bcc
	)

#-------------------assignments----------------------	
$api = ($managerurl+'/api/eg/orchestration/adduser')

$header = @{
	'managerurl' = $managerurl
	'user' = $user
	'pwd' = $pwd
	'Content-Type' = 'application/json'
}

$body = @{
	userrole = $userrole
	userid = $userid
	password = $password
	expirydate = $expirydate
	alarmsbymail = $alarmsbymail
	to = $to
	cc = $cc
	bcc = $bcc
}

#-------------------processing----------------------	
$nullVariables = [System.Collections.ArrayList]@()
foreach($key in $body.keys)
{
	$value = $body[$key]
	if ($value -eq $null){
		$nullVariables.Add($key)
		#Write-Output ($key+"value is null.")
	}
}

foreach ($key in $nullVariables){
	$body.Remove($key);
	#Write-Output ($key+"is removed.")
}

$JsonBody = $Body | ConvertTo-Json

Invoke-RestMethod -Method 'Post' -Uri $api -Body $JsonBody -Header $header -ContentType 'application/json'

#>