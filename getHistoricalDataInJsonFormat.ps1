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
	  Retrieving Historical Data of a Measure - /api/eg/analytics/getHistoricalData
	.DESCRIPTION
	  Use this REST API client to figure out whether the target environment is functioning without any glitches, more often than not, administrators tend to monitor the performance of certain key measures over a period of time. Using the eG REST API, administrators are befitted in monitoring the performance of the measures over a period of time without logging into the eG console. The table below specifies the parameters that should be used to retrieve the historical data of the measures.
		Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Retrieving-Historical-Data-of-a-Measure.htm
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
	  Creation Date:  12 Oct 2021
	  Purpose/Change: Initial script development
	  
	.EXAMPLE
	  .\getHistoricalDataInJsonFormat.ps1 -managerurl "https://192.168.20.30:7077" -user myuser -pwd cGFzc3dvcmQ= -timeline "1 hour" -server "Microsoft SQL:apac_database:1433" -test TCP -measure "Current connections"
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
	$timeline, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$server, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$test,
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$measure
	)

#-------------------assignments----------------------	
$api = ($managerurl+'/api/eg/analytics/getHistoricalData')

$header = @{
	'managerurl' = $managerurl
	'user' = $user
	'pwd' = $pwd
	'Content-Type' = 'application/json'
}


$body = @{
	hostip = $hostip
	timeline = $timeline
	server = $server
	test = $test
	measure = $measure
}

#-------------------processing----------------------	
$nullVariables = [System.Collections.ArrayList]@()
foreach($key in $body.keys)
{
	$value = $body[$key]
	if ($value -eq $null){
		[void]$nullVariables.Add($key)
		#Write-Output ($key+"value is null.")
	}
}

foreach ($key in $nullVariables){
	$body.Remove($key);
	#Write-Output ($key+"is removed.")
}

$JsonBody = $Body | ConvertTo-Json

$output = Invoke-RestMethod -Method 'Post' -Uri $api -Body $JsonBody -Header $header -ContentType 'application/json'

foreach ($record in $output){
	$record|ConvertTo-Json
}