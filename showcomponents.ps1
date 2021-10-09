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
	  Displaying Components - /api/eg/orchestration/showcomponents
	.DESCRIPTION
	  Administrators can use this API to display all the components available in the target environment.
		Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Displaying-Components.htm
	.PARAMETER managerurl
		URL of the eG manager. E.g., http://192.168.8.8:7077
	.PARAMETER user
		valid user for the eG manager
	.PARAMETER pwd
		base64 encoded password
	.PARAMETER componenttype
		A valid component type of eG manager like 'Microsoft Windows'. To display all components provide component type as All.
	.INPUTS
	  None
	.OUTPUTS
	  Shows all the components assigned to the given user
	.NOTES
	  Version:        1.0
	  Author:         pandian
	  Creation Date:  9 Oct 2021
	  Purpose/Change: Initial script development
	  
	.EXAMPLE
	  .\showcomponents.ps1 -managerurl "https://192.168.8.8:443" -user pandian -pwd cGFzc3dvcmQ= -componenttype All
	  .\showcomponents.ps1 -managerurl "https://192.168.8.8:443" -user pandian -pwd cGFzc3dvcmQ= -componenttype "Microsoft Windows"
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
	$componenttype
	)
#-------------------assignments----------------------	
$api = ($managerurl+'/api/eg/orchestration/showcomponents')
$header = @{
	'managerurl'=$managerurl
	'user'=$user
	'pwd'=$pwd
}
$body = @{
	componenttype="All"
}
$JsonBody = $Body | ConvertTo-Json

#-------------------processing----------------------	
Invoke-RestMethod -Method 'Post' -Uri $api -Body $JsonBody -Headers $header | Format-Table -Property componentType, ip, componentName, port, externalAgent