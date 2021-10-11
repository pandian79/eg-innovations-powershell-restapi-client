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
   Retrieving Test Data - /api/eg/analytics/getTestData
 .DESCRIPTION
   This is a powershell client of the eG REST API using which administrators can retrieve the measurement data collected upon execution of tests across all relevant component types. The table below specifies the parameters that should be used to retrieve the measures of the tests.
  Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Retrieving-Test-Data.htm
  
 .PARAMETER managerurl
  (mandatory) URL of the eG manager. E.g., http://192.168.8.8:7077
 .PARAMETER user
  (mandatory) valid user for the eG manager
 .PARAMETER pwd
  (mandatory) base64 encoded password
 .PARAMETER test
  name of the eG test for which the data is requested
 .PARAMETER hostname
  name of the component for which the data is requested
 .PARAMETER port
  port of the component for which the data is requested. Provide NULL for the host tests.
 .PARAMETER info
  descriptor of the component for which the data is requested. Provide NULL for the host tests.
 .PARAMETER lastmeasure
  true/false.
 .PARAMETER startDate
  start date
 .PARAMETER endDate
  end date
 .PARAMETER measures
  comma-separated list of measures
 .PARAMETER msmthost
  Measurement Host
 .PARAMETER type
  dd
 .PARAMETER segment
  Segment name
 .PARAMETER service
  Service name
 .PARAMETER searchhost
  Search Host
 .PARAMETER searchinfo
  Search info
 .PARAMETER groupby
  data can be grouped based on a measure, if needed
 .PARAMETER orderby
  Ascending/Descending
 .PARAMETER dateformat
  Date formant
 .INPUTS
   None
 .OUTPUTS
   Shows the measurement of the requested test or error
 .NOTES
   Version:        1.0
   Author:         pandian
   Creation Date:  11 Oct 2021
   Purpose/Change: Initial script development
   
 .EXAMPLE
   .\getTestData.ps1 -managerurl "https://192.168.20.30:7077" -user myuser -pwd cGFzc3dvcmQ= -test TCP -hostname mysqlserver -port NULL -info IPv4
#>

#-------------------get command line parameters----------------------
param (
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $managerurl, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $user, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $pwd, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $test, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $hostname, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $port, 
 [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
 $info, 
 $lastmeasure,
 $startDate,
 $endDate,
 $measures,
 $msmthost,
 $type,
 $segment,
 $service,
 $searchhost,
 $searchinfo,
 $groupby,
 $orderby,
 $dateformat
)

#-------------------assignments---------------------- 

$header = @{
 managerurl = $managerurl
 user = $user
 pwd = $pwd
}
$Body = @{
	'test' = $test 
	'host' = $hostname 
	'port' = $port 
	'info' = $info 
	'lastmeasure' = $lastmeasure 
	'startDate' = $startDate 
	'endDate' = $endDate 
	'measures' = $measures 
	'msmthost' = $msmthost 
	'type' = $type 
	'segment' = $segment 
	'service' = $service 
	'searchhost' = $searchhost 
	'searchinfo' = $searchinfo 
	'groupby' = $groupby 
	'orderby' = $orderby 
	'dateformat' = $dateformat
}


$api = ($managerurl+'/api/eg/analytics/getTestData')

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
$JsonBody

Invoke-RestMethod -verbose -Method 'Post' -Uri $api -Body $JsonBody -Header $header

#>