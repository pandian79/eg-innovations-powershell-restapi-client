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
	  Adding Maintenance Policies - /api/eg/orchestration/addmaintenancepolicy
	.DESCRIPTION
	  This API helps administrators add maintenance policies to the eG manager.
		Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Adding-Maintenance-Policies.htm
	.PARAMETER managerurl
		URL of the eG manager. E.g., http://192.168.8.8:7077
	.PARAMETER user
		valid user for the eG manager
	.PARAMETER pwd
		base64 encoded password
	.PARAMETER timeline
		Timeline for retrieving the measure data (in hours/days/weeks)
	.PARAMETER server
		Component Type:Component name:Port/Null
	.PARAMETER test
		Test name
	.PARAMETER measure
		Measure name
	.INPUTS
	  None
	.OUTPUTS
	  Shows metrics for the given parameters or error
	.NOTES
	  Version:        1.0
	  Author:         pandian
	  Creation Date:  13 Oct 2021
	  Purpose/Change: Initial script development
	  
	.EXAMPLE
	  .\addmaintenancepolicy.ps1 -managerurl "https://192.168.20.30:7077" -user myuser -pwd cGFzc3dvcmQ= -policyname apipolicy -timefrequency "Daily=00:00-23:59"
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
	$policyname, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$timefrequency 
	)

#-------------------assignments----------------------	
$api = ($managerurl+'/api/eg/orchestration/addmaintenancepolicy')

$header = @{
	'managerurl' = $managerurl
	'user' = $user
	'pwd' = $pwd
	'Content-Type' = 'application/json'
}


$body = @{
	policyname = $policyname
	timefrequency = $timefrequency
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