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
	  Adding Remote Agents - /api/eg/orchestration/addremoteagent
	.DESCRIPTION
	  Use this API to add remote agents for monitoring to the eG manager.
		Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Adding-External-Agents.htm
	.PARAMETER managerurl
		URL of the eG manager. E.g., http://192.168.8.8:7077
	.PARAMETER user
		valid user for the eG manager
	.PARAMETER pwd
		base64 encoded password
	.PARAMETER hostip
		IP of the server that has external agent.
	.PARAMETER agentname
		Hostname or IP or FQDN of the server that has external agent.
	.PARAMETER clientemulation
		This accepts Yes/No. Is client emulation or synthetic monitoring (Robotic record and playback or synthetic transaction) functionalities to be enabled.
	.INPUTS
	  None
	.OUTPUTS
	  Shows the confirmation or error
	.NOTES
	  Version:        1.0
	  Author:         pandian
	  Creation Date:  9 Oct 2021
	  Purpose/Change: Initial script development
	  
	.EXAMPLE
	  .\addremoteagent.ps1 -managerurl https://192.168.10.20 -user admin -pwd cGFzc3dvcmQ= -hostip 192.168.10.10 -agentname win10
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
	$hostip, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$agentname
	)

#-------------------assignments----------------------	
$api = ($managerurl+'/api/eg/orchestration/addremoteagent')

$header = @{
	'managerurl' = $managerurl
	'user' = $user
	'pwd' = $pwd
	'Content-Type' = 'application/json'
}


$body = @{
	hostip = $hostip
	agentname = $agentname
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