# SAMPLE CODE:
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
# PURPOSE. We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and 
# distribute the object code form of the Sample Code, provided that. You agree: (i) to not use Our name, logo, or
# trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright
# notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and 
# defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result
# from the use or distribution of the Sample Code  
# ################################
# This script retrieves a number of mobile devices specified by the user and returns the statistics
# In this case, we are just filtering on when the device partnership was created, and when it was
# most likely re-provisioned (Policy reapplied)
# We limit the number of devices, in order to avoid potential throttling, and to allow validation 
# of theories against smaller data sets. (easier to analyse and evaluate)
# This is currently only a very basic implementation for proof of concept
# Use at your own risk.

$numberOfDevicesToQuery = 2000
$FileName = "DeviceStats.csv"

# Will write debug output to the console
$debug = $true

$FileStream = [System.IO.StreamWriter] $FileName

#sets the headers for the file
$FileStream.WriteLine("Guid,UserDisplayName,DeviceModel,FirstSyncTime,LastPolicyUpdateTime")
write-host "Querying the first " + $numberOfDevicesToQuery + " devices ... "

$DeviceList = get-mobiledevice -resultSize $numberOfDevicesToQuery 
$debugcount = 0
foreach ($device in $DeviceList)
{
	if($debug)
	{
		write-host $debugcount
		write-host $device.UserDisplayName
		$debugcount++
	}
	
	
	$FileStream.write($device.Guid)
	$FileStream.write(",")
	$FileStream.write($device.UserDisplayName)
	$FileStream.write(",")
	$FileStream.write($device.DeviceModel)
	$FileStream.write(",")
	
	$stats = get-mobiledevicestatistics $device.Id
	
	$FileStream.write($stats.FirstSyncTime)
	$FileStream.write(",")
	$FileStream.write($stats.LastPolicyUpdateTime)
	$FileStream.write([System.Environment]::NewLine)
	#new line
	
}
  
$FileStream.Close()

# The End
