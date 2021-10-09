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
	  Adding Components - /api/eg/orchestration/addcomponent
	.DESCRIPTION
	  This API aids in adding new components to the eG Enterprise.
	  Ref: https://www.eginnovations.com/documentation/Automatically-Configuring-the-Target-Environment-using-REST-API/Displaying-Components.htm
	.PARAMETER managerurl
		(mandatory) URL of the eG manager. E.g., http://192.168.8.8:7077
	.PARAMETER user
		(mandatory) valid user for the eG manager
	.PARAMETER pwd
		(mandatory) base64 encoded password
	.PARAMETER hostip
		(mandatory) IP of the component to be added
	.PARAMETER componenttype
		(mandatory) Type of the component. Eg., "Microsoft Windows"
	.PARAMETER componentname, 
		(mandatory) Hostname or IP or FQDN of the component
	.PARAMETER port
		Port to which the component is listening, if any.
	.PARAMETER sid
		If you add Oracle database component, enter the SID as comma separated value here
	.PARAMETER externalagents
		Enter the name of the external agent
	.PARAMETER $agentless
		[Yes/No]. If the component is to be monitored in agentless manner, choose this as yes.
	.PARAMETER os
		[Linux/Windows/VMware]. If the component is monitored in agentless manner, specify the Operating System of the target server/application/applicance to be monitored.
	.PARAMETER mode
		[SSH/Rexec/Perfmon/Other]. If the component is monitored in agentless manner, specify the mode of data collection. 
	.PARAMETER encrypttype
	.PARAMETER keyfilename
	.PARAMETER remoteagent
		If the component is monitored in agentless manner, specify the name of the remote agent
	.PARAMETER remoteport
	.PARAMETER remoteuser
	.PARAMETER remotepwd
	.PARAMETER internalagentassignment
		[Auto/Manual] When internal agent assignment is to be set, this parameter is given. Default is Auto.
	.PARAMETER internalagent
		When internal agent assignment is Manual, specify the name of the internal agent to be used
	.PARAMETER mtsenabled
		[Yes/No] if MTS is enabled, specify Yes.
	.PARAMETER virtualenv
	.PARAMETER virtualserver
	.PARAMETER ispassive
		[Yes/No] if the given server is not a active server in an active/passive environment, choose Yes.
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
	  .\addcomponent.ps1 -managerurl "https://192.168.8.65:443" -user pandian -pwd cGFzc3dvcmQ= -hostip 192.169.8.150 -componenttype "Microsoft Windows" -componentname LAPTOP
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
	$componenttype, 
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	$componentname, 
	$port, 
	$sid,$externalagents,$agentless,$os,$mode,$encrypttype,
	$keyfilename,$remoteagent,$remoteport,$remoteuser,$remotepwd,
	$internalagentassignment,$internalagent,$mtsenabled,$virtualenv,
	$virtualserver,$ispassive)

write-host ("Processing "+$hostip)

#-------------------assignments----------------------	

$header = @{
	managerurl=$managerurl
	user=$user
	pwd=$pwd
}
$Body = @{
	hostip = $hostip
	componenttype = $componenttype
	componentname = $componentname
	port = $port
	sid = $sid
	externalagents = $externalagents
	agentless = $agentless
	os = $os
	mode = $mode
	encrypttype = $encrypttype
	keyfilename = $keyfilename
	remoteagent = $remoteagent
	remoteport = $remoteport
	remoteuser = $remoteuser
	remotepwd = $remotepwd
	internalagentassignment = $internalagentassignment
	internalagent = $internalagent
	mtsenabled = $mtsenabled
	virtualenv = $virtualenv
	virtualserver = $virtualserver
	ispassive = $ispassive

}


$api = ($managerurl+'/api/eg/orchestration/addcomponent')

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

Invoke-RestMethod -Method 'Post' -Uri $api -Body $JsonBody -Header $header

#>